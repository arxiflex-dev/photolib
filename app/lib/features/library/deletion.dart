import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/trash/trash.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';

/// What deleting a selection removes where (ADR-0200 rows X1–X5): how many of
/// its items, and their bytes, are on this device and backed up, only on this
/// device, or only in the library.
@immutable
class DeletionPlan {
  /// A plan by its groups.
  const new({
    this.both = (0, 0),
    this.device = (0, 0),
    this.library = (0, 0),
    this.photos = false,
  });

  /// The plan of deleting [items].
  factory of(Iterable<ThumbnailItem> items) {
    var both = (0, 0);
    var device = (0, 0);
    var library = (0, 0);
    var photos = false;
    for (final item in items) {
      (int, int) add((int, int) group) => (group.$1 + 1, group.$2 + item.bytes);
      switch (item.backup) {
        case Availability.backedUp:
          both = add(both);
        case Availability.notBackedUp:
          device = add(device);
        case Availability.cloudOnly:
          library = add(library);
      }
      photos |=
          item.backup != Availability.cloudOnly && item.uri.isScheme('ph');
    }
    return DeletionPlan(
      both: both,
      device: device,
      library: library,
      photos: photos,
    );
  }

  /// The items on this device and backed up, and the bytes of their device
  /// copies.
  final (int, int) both;

  /// The items only on this device, and their bytes.
  final (int, int) device;

  /// The items only in the library, and the bytes of the server's copies.
  final (int, int) library;

  /// Whether a device copy is in Apple Photos, where iCloud Photos follows a
  /// deletion.
  final bool photos;

  /// How many items in all.
  int get count => both.$1 + device.$1 + library.$1;
}

/// *Move to trash* takes every copy, each to its trash; *Remove from this
/// device* only the device copies of backed-up items, which the library keeps.
enum DeleteChoice {
  /// Every copy, each into its trash.
  trash,

  /// The device copies of backed-up items.
  removeFromDevice,
}

/// Asks what to delete, saying exactly what goes where (ADR-0200 proposal
/// 11); null when the user cancels.
Future<DeleteChoice?> confirmDeletion(
  BuildContext context,
  DeletionPlan plan,
) => showDialog<DeleteChoice>(
  context: context,
  builder: (context) {
    final strings = AppLocalizations.of(context);
    final formats = Formats(strings);
    final onDevice = plan.both.$1 + plan.device.$1 > 0;
    Widget option(DeleteChoice choice, String title, String scope) => ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(scope),
      onTap: () => Navigator.pop(context, choice),
    );
    return AlertDialog(
      title: Text(strings.deleteTitle(plan.count)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final ((count, bytes), says) in [
              (plan.both, strings.deleteBoth),
              (plan.device, strings.deleteDevice),
              (plan.library, strings.deleteLibrary),
            ])
              if (count > 0)
                Text([says(count), formats.fileSize(bytes)].join(' · ')),
            if (onDevice) ...[
              const SizedBox(height: 8),
              Text(strings.deleteSpaceReturns),
            ],
            if (plan.photos) ...[
              const SizedBox(height: 8),
              Text(strings.deleteICloud),
            ],
            const SizedBox(height: 8),
            option(
              DeleteChoice.trash,
              strings.actionTrash,
              strings.deleteTrashWhere(
                plan.both.$1 + plan.library.$1 == 0
                    ? 'device'
                    : onDevice
                    ? 'both'
                    : 'library',
              ),
            ),
            if (plan.both.$1 > 0)
              option(
                DeleteChoice.removeFromDevice,
                strings.deleteRemove,
                strings.deleteRemoveWhat(plan.both.$1),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  },
);

/// Moves [items] to the trash, signed in as the user chooses in
/// [confirmDeletion], else the device's at once, as nothing else holds them
/// (docs/10 §5.4). [chosen] runs once they chose, and returns the context the
/// deletion goes on in, as a selection clears or the viewer closes.
Future<void> deleteItems(
  BuildContext context,
  WidgetRef ref,
  List<ThumbnailItem> items, {
  required BuildContext Function() chosen,
}) async {
  final signedIn = ref.read(serverProvider).value?.account != null;
  final plan = DeletionPlan.of(items);
  // Signed out nothing asks first but the platform; yet where it is Apple
  // Photos, whose own dialog is the only one that would say iCloud follows.
  final choice = signedIn || plan.photos
      ? await confirmDeletion(context, plan)
      : DeleteChoice.trash;
  if (choice == null || !context.mounted) return;
  final everywhere = choice == DeleteChoice.trash;
  final going = [
    for (final i in items)
      if (everywhere || i.backup == Availability.backedUp) i,
  ];
  await moveToTrash(
    chosen(),
    ref,
    [for (final i in going) ?i.id],
    assets: [
      if (everywhere)
        for (final i in going)
          if (i.backup != Availability.notBackedUp) ?i.asset,
    ],
    count: going.length,
  );
}

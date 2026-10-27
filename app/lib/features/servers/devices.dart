import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/problems.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib_api/photolib_api.dart';
import 'package:protobuf/protobuf.dart';

/// The devices signed in to the account of [client]'s session, most recently
/// seen first, each of which it signs out: this one too, which then signs the
/// app out (ADR-0052).
class DevicesView extends StatefulWidget {
  /// The list of [client]'s devices.
  const new(this.client, {super.key});

  /// The session whose account's devices it lists.
  final RpcClient client;

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  late Future<ListDevicesResponse> _devices = _list();

  /// Handled, so that a list the view no longer shows, as once signed out,
  /// fails no test.
  Future<ListDevicesResponse> _list() =>
      AuthServiceApi(widget.client).listDevices(null, ListDevicesRequest())
        ..ignore();

  void _reload() => setState(() {
    _devices = _list();
  });

  @override
  void didUpdateWidget(DevicesView old) {
    super.didUpdateWidget(old);
    if (old.client != widget.client) _devices = _list();
  }

  Future<void> _signOut(Device device) async {
    try {
      await AuthServiceApi(widget.client)
          .revokeDevice(null, RevokeDeviceRequest(deviceId: device.deviceId));
    } on CallError catch (error) {
      if (mounted) showProblem(context, error);
    }
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _devices,
    builder: (context, snapshot) {
      final s = AppLocalizations.of(context);
      if (snapshot.error case final error?) {
        return ErrorView(error: error, onRetry: _reload);
      }
      final devices = snapshot.data?.devices;
      if (devices == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: [
          for (final device in devices)
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(device.name),
              subtitle: Text(_subtitle(context, device)),
              trailing: TextButton(
                onPressed: () => _signOut(device),
                child: Text(s.serverSignOut),
              ),
            ),
        ],
      );
    },
  );
}

/// The platform of [device], and whether it is this one or when it was last
/// seen.
String _subtitle(BuildContext context, Device device) {
  final s = AppLocalizations.of(context);
  if (device.current) return '${device.platform} · ${s.adminThisDevice}';
  final time = device.lastSeenAt.toDateTime().toLocal();
  final clock = MaterialLocalizations.of(context)
      .formatTimeOfDay(TimeOfDay.fromDateTime(time));
  final seen = '${Formats.of(context).date(time)} $clock';
  return '${device.platform} · ${s.adminLastSeen(seen)}';
}

/// Opens the [DevicesView] of [session]'s account.
class DevicesTile extends StatelessWidget {
  /// The tile of [session]'s devices.
  const new(this.session, {super.key});

  /// The signed-in session.
  final RpcClient session;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.devices_outlined),
      title: Text(s.adminDevices),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(s.adminDevices)),
            body: DevicesView(session),
          ),
        ),
      ),
    );
  }
}

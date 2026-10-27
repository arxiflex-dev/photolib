import 'dart:typed_data';

import 'package:photolib_data/src/replica.dart';

/// The person the people widget shows (MOB-11, ADR-0401): the named, visible,
/// unmerged person with the most faces, and the asset their cover face is in;
/// null when no person has a name and a cover. The caller shows the asset
/// through a query that keeps out the folders the user hides.
Future<({String name, Uint8List asset})?> topPerson(Replica db) async {
  final rows = await db
      .customSelect(
        'SELECT p.name AS name, f.asset_id AS asset FROM person p '
        'JOIN face f ON f.id = p.cover_face_id '
        'WHERE p.hidden = 0 AND p.merged_into IS NULL '
        "AND IFNULL(p.name, '') <> '' "
        'ORDER BY (SELECT count(*) FROM face c WHERE c.person_id = p.id) DESC, '
        'p.name LIMIT 1',
        readsFrom: {db.person, db.face},
      )
      .get();
  if (rows.isEmpty) return null;
  return (
    name: rows.single.read<String>('name'),
    asset: rows.single.read<Uint8List>('asset'),
  );
}

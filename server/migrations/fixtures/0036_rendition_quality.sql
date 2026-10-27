-- The upgrade fixture of schema version 0036_rendition_quality (docs/dev/migrations.md#upgrade-path-harness): a small
-- library with rows in every table, loaded into a database at that version. Ids read <entity>-0000-7000-8000-<n>; a
-- link's token is its id. Released, like the migration: never edit it.

INSERT INTO photolib_instance (instance_id) VALUES ('00000000-0000-7000-8000-000000000001');

INSERT INTO users (id, handle, display_name, email, role, status, quota_bytes, locale) VALUES
('00000001-0000-7000-8000-000000000001', 'ada', 'Ada', 'ada@example.org', 'admin', 'active', NULL, 'en'),
('00000001-0000-7000-8000-000000000002', 'bea', 'Bea', 'bea@example.org', 'user', 'active', 10737418240, 'de-DE'),
('00000001-0000-7000-8000-000000000003', 'cyd', 'Cyd', NULL, 'user', 'invited', NULL, 'ar'),
('00000001-0000-7000-8000-000000000004', 'dee', 'Dee', 'dee@example.org', 'user', 'disabled', NULL, NULL),
('00000001-0000-7000-8000-000000000005', 'eli', 'Eli', 'eli@example.org', 'user', 'active', NULL, 'fr'),
('00000001-0000-7000-8000-000000000006', 'fay', 'Fay', 'fay@example.org', 'user', 'active', NULL, NULL);
INSERT INTO user_keys (user_id, key_bundle) VALUES
('00000001-0000-7000-8000-000000000001', convert_to('public key bundle of ada', 'UTF8'));
INSERT INTO devices (id, user_id, name, platform, app_version, capabilities, device_public_key, last_seen_at,
                     is_trusted_node) VALUES
('00000002-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'Pixel', 'android', '0.1.0',
 '{sync.v1}', convert_to('device key of the Pixel', 'UTF8'), '2026-01-02 10:00:00+00', false),
('00000002-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', 'Desktop', 'linux', '0.1.0',
 '{sync.v1,ml}', convert_to('device key of the desktop', 'UTF8'), '2026-01-03 10:00:00+00', true);

-- A managed library, a private one, an external read-only one being scanned, and Bea's.
INSERT INTO libraries (id, owner_id, name, kind, privacy, access, root_uri, is_upload_target, storage_template,
                       scan_policy, state) VALUES
('00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'Photos', 'managed', 'standard',
 'rw', 'managed:photos', true, '{yyyy}/{MM}/{filename}', NULL, 'online'),
('00000003-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', 'Private', 'managed', 'private',
 'rw', 'managed:private', false, NULL, NULL, 'online'),
('00000003-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001', 'NAS archive', 'external',
 'standard', 'ro', 'file:///srv/photos', false, NULL, '{"interval": "1d"}', 'scanning'),
('00000003-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000002', 'Bea', 'managed', 'standard',
 'rw', 'managed:bea', true, NULL, NULL, 'online');
-- Since 0036: the NAS archive is on a small disk, so its previews are 2160 px; every other library is high.
UPDATE libraries SET rendition_quality = 'standard' WHERE name = 'NAS archive';
INSERT INTO library_members (library_id, user_id, role) VALUES
('00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000002', 'viewer'),
('00000003-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000002', 'contributor'),
('00000003-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000001', 'editor');

INSERT INTO places (id, parent_id, level, names, lat, lon) VALUES
('00000004-0000-7000-8000-000000000001', NULL, 'country', '{"en": "Portugal", "pt": "Portugal"}', NULL, NULL),
('00000004-0000-7000-8000-000000000002', '00000004-0000-7000-8000-000000000001', 'city',
 '{"en": "Lisbon", "pt": "Lisboa"}', 38.7223, -9.1393);

INSERT INTO stacks (id, owner_id, kind, origin, review_state, ranking) VALUES
('00000005-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'burst', 'camera', 'reviewed',
 '{"best": "00000006-0000-7000-8000-000000000004"}'),
('00000005-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', 'raw_jpeg', 'camera',
 'unreviewed', NULL);

-- Assets of every kind: a live photo, a video, a burst, RAW+JPEG, a scan, an import, an edit copy, a private asset
-- (ciphertext only), trashed, archived and locked, and one of Bea's.
INSERT INTO assets (id, library_id, owner_id, original_filename, source, source_ref, content_hash, media_kind, facets,
                    taken_local, tz_offset_min, tz_name, taken_utc, time_source, time_confidence, time_precision,
                    tz_assumed, lat, lon, location_source, place_id, width, height, duration_ms, fps, codec, make,
                    model, title, description, rating, color_label, archived, locked, trashed_at, field_hlc, rights,
                    stack_id, stack_order) VALUES
('00000006-0000-7000-8000-000000000001', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'IMG_0001.HEIC', 'upload', NULL, sha256('\x01'), 'image', '{live}', '2024-05-01 14:00:00', 60, 'Europe/Lisbon',
 '2024-05-01 13:00:00+00', 'exif', 100, 'second', false, 38.7115, -9.1300, 'exif',
 '00000004-0000-7000-8000-000000000002', 4032, 3024, NULL, NULL, NULL, 'Apple', 'iPhone 15', 'Tram 28',
 'Up the hill to the castle', 4, 'red', false, false, NULL, '{"title": "1714568400000-0-pixel"}',
 '{"creator": "Ada"}', NULL, NULL),
('00000006-0000-7000-8000-000000000002', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'VID_0002.MOV', 'upload', NULL, sha256('\x02'), 'video', '{}', '2024-05-01 15:00:00', 60, 'Europe/Lisbon',
 '2024-05-01 14:00:00+00', 'quicktime', 100, 'second', false, NULL, NULL, NULL, NULL, 1920, 1080, 12000, 30, 'hevc',
 'Apple', 'iPhone 15', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, NULL, NULL),
('00000006-0000-7000-8000-000000000003', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'BURST_0003.JPG', 'upload', NULL, sha256('\x03'), 'image', '{burst}', '2024-05-02 09:00:00', 60, 'Europe/Lisbon',
 '2024-05-02 08:00:00+00', 'exif', 100, 'ms', false, NULL, NULL, NULL, NULL, 4000, 3000, NULL, NULL, NULL, 'Sony',
 'A7 IV', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, '00000005-0000-7000-8000-000000000001', 1),
('00000006-0000-7000-8000-000000000004', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'BURST_0004.JPG', 'upload', NULL, sha256('\x04'), 'image', '{burst}', '2024-05-02 09:00:00.25', 60,
 'Europe/Lisbon', '2024-05-02 08:00:00.25+00', 'exif', 100, 'ms', false, NULL, NULL, NULL, NULL, 4000, 3000, NULL,
 NULL, NULL, 'Sony', 'A7 IV', NULL, NULL, 5, NULL, false, false, NULL, '{}', NULL,
 '00000005-0000-7000-8000-000000000001', 2),
('00000006-0000-7000-8000-000000000005', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'DSC_0005.ARW', 'upload', NULL, sha256('\x05'), 'image', '{raw}', '2024-05-03 18:30:00', 60, 'Europe/Lisbon',
 '2024-05-03 17:30:00+00', 'exif', 100, 'second', false, NULL, NULL, NULL, NULL, 6000, 4000, NULL, NULL, NULL,
 'Sony', 'A7 IV', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, '00000005-0000-7000-8000-000000000002', 1),
('00000006-0000-7000-8000-000000000006', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'DSC_0005.JPG', 'upload', NULL, sha256('\x06'), 'image', '{}', '2024-05-03 18:30:00', 60, 'Europe/Lisbon',
 '2024-05-03 17:30:00+00', 'exif', 100, 'second', false, NULL, NULL, NULL, NULL, 6000, 4000, NULL, NULL, NULL,
 'Sony', 'A7 IV', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, '00000005-0000-7000-8000-000000000002', 2),
('00000006-0000-7000-8000-000000000007', '00000003-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001',
 'scan_1987_03.tif', 'scan', 'file:///srv/photos/1987/scan_1987_03.tif', sha256('\x07'), 'image', '{scan}',
 '1987-03-01 00:00:00', NULL, NULL, NULL, 'user', 40, 'month', true, NULL, NULL, NULL, NULL, 3000, 2000, NULL, NULL,
 NULL, 'Epson', 'Perfection V600', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, NULL, NULL),
('00000006-0000-7000-8000-000000000008', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'PXL_0008.jpg', 'import', 'takeout:Photos from 2019/PXL_0008.jpg', sha256('\x08'), 'image', '{}',
 '2019-08-10 12:00:00', 120, 'Europe/Berlin', '2019-08-10 10:00:00+00', 'sidecar', 80, 'second', false, NULL, NULL,
 'import', NULL, 4000, 3000, NULL, NULL, NULL, 'Google', 'Pixel 3', NULL, NULL, 0, NULL, false, false, NULL, '{}',
 NULL, NULL, NULL),
('00000006-0000-7000-8000-000000000009', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'IMG_0001 (edited).jpg', 'edit_copy', '00000006-0000-7000-8000-000000000001', sha256('\x09'), 'image', '{}',
 '2024-05-01 14:00:00', 60, 'Europe/Lisbon', '2024-05-01 13:00:00+00', 'exif', 100, 'second', false, NULL, NULL,
 NULL, NULL, 4032, 3024, NULL, NULL, NULL, 'Apple', 'iPhone 15', NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL,
 NULL, NULL),
('00000006-0000-7000-8000-000000000011', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'IMG_0011.JPG', 'upload', NULL, sha256('\x11'), 'image', '{}', NULL, NULL, NULL, NULL, 'unknown', NULL, NULL,
 false, NULL, NULL, NULL, NULL, 800, 600, NULL, NULL, NULL, NULL, NULL, NULL, NULL, -1, NULL, false, false,
 '2026-01-05 08:00:00+00', '{}', NULL, NULL, NULL),
('00000006-0000-7000-8000-000000000012', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'IMG_0012.JPG', 'upload', NULL, sha256('\x12'), 'image', '{}', '2023-12-24 20:00:00', 60, 'Europe/Berlin',
 '2023-12-24 19:00:00+00', 'exif', 100, 'second', false, NULL, NULL, NULL, NULL, 800, 600, NULL, NULL, NULL, NULL,
 NULL, NULL, NULL, 0, NULL, true, true, NULL, '{}', NULL, NULL, NULL),
('00000006-0000-7000-8000-000000000013', '00000003-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000002',
 'bea.jpg', 'upload', NULL, sha256('\x13'), 'image', '{}', '2021-06-01 10:00:00', 120, 'Europe/Berlin',
 '2021-06-01 08:00:00+00', 'exif', 100, 'second', false, NULL, NULL, NULL, NULL, 800, 600, NULL, NULL, NULL, NULL,
 NULL, NULL, NULL, 0, NULL, false, false, NULL, '{}', NULL, NULL, NULL);
INSERT INTO assets (id, library_id, owner_id, source, meta_core, meta_user, meta_ml) VALUES
('00000006-0000-7000-8000-000000000010', '00000003-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001',
 'upload', convert_to('sealed core metadata', 'UTF8'), convert_to('sealed user metadata', 'UTF8'),
 convert_to('sealed ml results', 'UTF8'));
UPDATE stacks SET cover_asset_id = '00000006-0000-7000-8000-000000000004'
WHERE id = '00000005-0000-7000-8000-000000000001';
UPDATE stacks SET cover_asset_id = '00000006-0000-7000-8000-000000000006'
WHERE id = '00000005-0000-7000-8000-000000000002';

INSERT INTO custom_fields (id, library_id, name, kind, options) VALUES
('00000007-0000-7000-8000-000000000001', '00000003-0000-7000-8000-000000000003', 'Film stock', 'text', NULL),
('00000007-0000-7000-8000-000000000002', '00000003-0000-7000-8000-000000000003', 'Format', 'enum',
 '["35 mm", "120"]');
INSERT INTO asset_custom_values (asset_id, field_id, value) VALUES
('00000006-0000-7000-8000-000000000007', '00000007-0000-7000-8000-000000000001', '"Kodak Gold 200"'),
('00000006-0000-7000-8000-000000000007', '00000007-0000-7000-8000-000000000002', '"35 mm"');

-- Originals, a Live Photo's video, a sidecar, renditions, an encrypted original and a missing one.
INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash, state, crypto_header,
                         render_spec) VALUES
('00000008-0000-7000-8000-000000000001', '00000006-0000-7000-8000-000000000001', 'original', 'managed',
 '2024/05/IMG_0001.HEIC', 'image/heic', 2400000, sha256('\x01'), 'present', NULL, NULL),
('00000008-0000-7000-8000-000000000002', '00000006-0000-7000-8000-000000000001', 'live_video', 'managed',
 '2024/05/IMG_0001.MOV', 'video/quicktime', 3100000, sha256('\x81'), 'present', NULL, NULL),
('00000008-0000-7000-8000-000000000003', '00000006-0000-7000-8000-000000000001', 'thumbnail', 'derived',
 'thumbs/00000006-0000-7000-8000-000000000001.webp', 'image/webp', 9000, NULL, 'present', NULL,
 '{"generator": "thumb", "version": 1, "size": 256}'),
('00000008-0000-7000-8000-000000000004', '00000006-0000-7000-8000-000000000002', 'original', 'managed',
 '2024/05/VID_0002.MOV', 'video/quicktime', 48000000, sha256('\x02'), 'present', NULL, NULL),
('00000008-0000-7000-8000-000000000005', '00000006-0000-7000-8000-000000000007', 'original', 'external',
 '1987/scan_1987_03.tif', 'image/tiff', 36000000, sha256('\x07'), 'offline', NULL, NULL),
('00000008-0000-7000-8000-000000000006', '00000006-0000-7000-8000-000000000007', 'sidecar', 'external',
 '1987/scan_1987_03.tif.xmp', 'application/rdf+xml', 2000, NULL, 'present', NULL, NULL),
('00000008-0000-7000-8000-000000000007', '00000006-0000-7000-8000-000000000010', 'original', 'managed',
 'objects/00000006-0000-7000-8000-000000000010', NULL, 2500000, NULL, 'present',
 convert_to('sealed file header', 'UTF8'), NULL),
('00000008-0000-7000-8000-000000000008', '00000006-0000-7000-8000-000000000008', 'original', 'managed',
 '2019/08/PXL_0008.jpg', 'image/jpeg', 3000000, sha256('\x08'), 'missing', NULL, NULL),
('00000008-0000-7000-8000-000000000009', '00000006-0000-7000-8000-000000000001', 'render', 'derived',
 'renders/00000009-0000-7000-8000-000000000002.jpg', 'image/jpeg', 2000000, NULL, 'present', NULL,
 '{"generator": "render", "version": 1}');

INSERT INTO versions (id, asset_id, parent_id, kind, origin, label, batch_id, recipe_hash, process_version, recipe,
                      render_file_id, created_by_device, note) VALUES
('00000009-0000-7000-8000-000000000001', '00000006-0000-7000-8000-000000000001', NULL, 'original', 'upload', NULL,
 NULL, NULL, NULL, NULL, NULL, '00000002-0000-7000-8000-000000000001', NULL),
('00000009-0000-7000-8000-000000000002', '00000006-0000-7000-8000-000000000001',
 '00000009-0000-7000-8000-000000000001', 'edit', 'app', 'Warmer', '00000009-0000-7000-8000-0000000000ff',
 sha256('\x92'), '1', convert_to('recipe: warmth +10', 'UTF8'), '00000008-0000-7000-8000-000000000009',
 '00000002-0000-7000-8000-000000000002', 'for the album'),
('00000009-0000-7000-8000-000000000003', '00000006-0000-7000-8000-000000000009', NULL, 'import_variant', 'import',
 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
UPDATE assets SET current_version_id = '00000009-0000-7000-8000-000000000002'
WHERE id = '00000006-0000-7000-8000-000000000001';
UPDATE assets SET current_version_id = '00000009-0000-7000-8000-000000000003'
WHERE id = '00000006-0000-7000-8000-000000000009';

INSERT INTO asset_user_state (user_id, asset_id, favorite, hidden_from_memories, last_viewed_at,
                              playback_position_ms) VALUES
('00000001-0000-7000-8000-000000000002', '00000006-0000-7000-8000-000000000001', true, false,
 '2026-01-04 09:00:00+00', NULL),
('00000001-0000-7000-8000-000000000001', '00000006-0000-7000-8000-000000000002', false, true, NULL, 4000);
INSERT INTO asset_embeddings (asset_id, model_id, embedding) VALUES
('00000006-0000-7000-8000-000000000001', 'siglip2-base', '\x0000803f0000003f');
INSERT INTO asset_ocr (asset_id, model_id, text, version_id, regions) VALUES
('00000006-0000-7000-8000-000000000008', 'ppocr-v5', 'Lisboa', NULL, NULL),
('00000006-0000-7000-8000-000000000001', 'ppocr-v5', 'Lisboa', '00000009-0000-7000-8000-000000000002',
 '[{"text": "Lisboa", "x": 0.1, "y": 0.2, "width": 0.5, "height": 0.1}]');
INSERT INTO asset_quality (asset_id, model_id, scores) VALUES
('00000006-0000-7000-8000-000000000003', 'aesthetic-v1', '{"aesthetic": 0.8, "sharpness": 0.6}');
INSERT INTO ml_labels (id, names) VALUES ('tram', '{"en": "tram", "de": "Straßenbahn"}');
INSERT INTO asset_ml_labels (asset_id, label_id, model_id, score) VALUES
('00000006-0000-7000-8000-000000000001', 'tram', 'labels-v1', 0.93);

INSERT INTO tags (id, owner_id, parent_id, name, path, color, is_album, origin) VALUES
('0000000a-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', NULL, 'Places', 'Places', NULL,
 false, 'user'),
('0000000a-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001',
 '0000000a-0000-7000-8000-000000000001', 'Lisbon', 'Places|Lisbon', '#ffcc00', false, 'user'),
('0000000a-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001', NULL, 'Family', 'Family', NULL,
 true, 'user'),
('0000000a-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000001', NULL, 'Takeout', 'Takeout', NULL,
 false, 'import');
INSERT INTO asset_tags (asset_id, tag_id, origin, confidence) VALUES
('00000006-0000-7000-8000-000000000001', '0000000a-0000-7000-8000-000000000002', 'user', NULL),
('00000006-0000-7000-8000-000000000008', '0000000a-0000-7000-8000-000000000004', 'import', NULL),
('00000006-0000-7000-8000-000000000003', '0000000a-0000-7000-8000-000000000003', 'ml', 0.7);

-- Albums of every kind, the first with text, heading, location, divider and date blocks.
INSERT INTO album_folders (id, owner_id, parent_id, name, sort_key) VALUES
('0000000b-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', NULL, 'Trips', 'a'),
('0000000b-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001',
 '0000000b-0000-7000-8000-000000000001', '2024', 'a');
INSERT INTO albums (id, owner_id, folder_id, sort_key, kind, title, description, cover_asset_id, sort_mode, layout,
                    privacy, query, tag_id, include_descendants, source_library_id, source_path,
                    encrypted_meta) VALUES
('0000000c-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 '0000000b-0000-7000-8000-000000000002', 'a', 'regular', 'Lisbon 2024', 'Three days in May',
 '00000006-0000-7000-8000-000000000001', 'custom', 'story', 'standard', NULL, NULL, true, NULL, NULL, NULL),
('0000000c-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', NULL, 'b', 'smart', 'Five stars',
 NULL, NULL, 'taken_desc', 'grid', 'standard', convert_to('rating >= 5', 'UTF8'), NULL, true, NULL, NULL, NULL),
('0000000c-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001', NULL, 'c', 'tag', 'Family', NULL,
 NULL, 'taken_asc', 'justified', 'standard', NULL, '0000000a-0000-7000-8000-000000000003', true, NULL, NULL, NULL),
('0000000c-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000001', NULL, 'd', 'folder_backed', '1987',
 NULL, NULL, 'name', 'grid', 'standard', NULL, NULL, true, '00000003-0000-7000-8000-000000000003', '1987/', NULL),
('0000000c-0000-7000-8000-000000000005', '00000001-0000-7000-8000-000000000001', NULL, 'e', 'regular', NULL, NULL,
 NULL, 'added_desc', 'grid', 'private', NULL, NULL, true, NULL, NULL, convert_to('sealed album title', 'UTF8'));
INSERT INTO album_items (id, album_id, kind, asset_id, caption, body, anchor_asset_id, place_id, lat, lon, sort_key,
                         encrypted) VALUES
('0000000d-0000-7000-8000-000000000001', '0000000c-0000-7000-8000-000000000001', 'heading', NULL, NULL, 'Day one',
 '00000006-0000-7000-8000-000000000001', NULL, NULL, NULL, 'a0', NULL),
('0000000d-0000-7000-8000-000000000002', '0000000c-0000-7000-8000-000000000001', 'asset',
 '00000006-0000-7000-8000-000000000001', 'Tram 28', NULL, NULL, NULL, NULL, NULL, 'a1', NULL),
('0000000d-0000-7000-8000-000000000003', '0000000c-0000-7000-8000-000000000001', 'text', NULL, NULL,
 'We took the tram up to the castle.', '00000006-0000-7000-8000-000000000002', NULL, NULL, NULL, 'a2', NULL),
('0000000d-0000-7000-8000-000000000004', '0000000c-0000-7000-8000-000000000001', 'asset',
 '00000006-0000-7000-8000-000000000002', NULL, NULL, NULL, NULL, NULL, NULL, 'a3', NULL),
('0000000d-0000-7000-8000-000000000005', '0000000c-0000-7000-8000-000000000001', 'location', NULL, 'Castelo', NULL,
 NULL, '00000004-0000-7000-8000-000000000002', 38.7139, -9.1334, 'a4', NULL),
('0000000d-0000-7000-8000-000000000006', '0000000c-0000-7000-8000-000000000001', 'divider', NULL, NULL, NULL, NULL,
 NULL, NULL, NULL, 'a5', NULL),
('0000000d-0000-7000-8000-000000000007', '0000000c-0000-7000-8000-000000000001', 'date', NULL, '2 May', NULL,
 '00000006-0000-7000-8000-000000000003', NULL, NULL, NULL, 'a6', NULL),
('0000000d-0000-7000-8000-000000000008', '0000000c-0000-7000-8000-000000000001', 'asset',
 '00000006-0000-7000-8000-000000000003', NULL, NULL, NULL, NULL, NULL, NULL, 'a7', NULL),
('0000000d-0000-7000-8000-000000000009', '0000000c-0000-7000-8000-000000000005', 'asset',
 '00000006-0000-7000-8000-000000000010', NULL, NULL, NULL, NULL, NULL, NULL, 'a0',
 convert_to('sealed caption', 'UTF8'));

-- Shares: album members, library members (above), a partner share and links: open, with a password and an expiry,
-- revoked and expired.
INSERT INTO album_members (album_id, user_id, role) VALUES
('0000000c-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000002', 'contributor'),
('0000000c-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000003', 'viewer'),
('0000000c-0000-7000-8000-000000000004', '00000001-0000-7000-8000-000000000002', 'editor');
INSERT INTO album_user_state (user_id, album_id, hide_from_timeline, hide_from_memories) VALUES
('00000001-0000-7000-8000-000000000002', '0000000c-0000-7000-8000-000000000001', true, false);
INSERT INTO library_user_state (user_id, library_id, hide_from_timeline, hide_from_memories) VALUES
('00000001-0000-7000-8000-000000000002', '00000003-0000-7000-8000-000000000001', false, true);
INSERT INTO links (id, album_id, token_hash, created_by, password_hash, allow_download, expires_at, revoked_at)
SELECT id, album_id, sha256(convert_to(id::text, 'UTF8')), '00000001-0000-7000-8000-000000000001', password_hash,
       allow_download, expires_at, revoked_at
FROM (VALUES
    ('0000000e-0000-7000-8000-000000000001'::uuid, '0000000c-0000-7000-8000-000000000001'::uuid, NULL, true,
     NULL::timestamptz, NULL::timestamptz),
    ('0000000e-0000-7000-8000-000000000002', '0000000c-0000-7000-8000-000000000001', 'argon2id:fixture', false,
     '2030-01-01 00:00:00+00', NULL),
    ('0000000e-0000-7000-8000-000000000003', '0000000c-0000-7000-8000-000000000004', NULL, false, NULL,
     '2026-01-06 00:00:00+00'),
    ('0000000e-0000-7000-8000-000000000004', '0000000c-0000-7000-8000-000000000001', NULL, false,
     '2025-01-01 00:00:00+00', NULL)
) AS l (id, album_id, password_hash, allow_download, expires_at, revoked_at);
INSERT INTO partner_shares (owner_id, partner_id, taken_since) VALUES
('00000001-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', '2020-01-01');

-- People and pets: a person, a pet and a person merged into the first; assigned, automatic and unassigned faces.
INSERT INTO persons (id, owner_id, kind, name, birth_date, hidden, merged_into) VALUES
('0000000f-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'human', 'Maria', '1960-02-29',
 false, NULL),
('0000000f-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', 'pet', 'Tiger', NULL, false, NULL),
('0000000f-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001', 'human', 'Mum', NULL, true,
 '0000000f-0000-7000-8000-000000000001');
INSERT INTO faces (id, asset_id, version_basis, bbox, landmarks, model_id, embedding, quality, person_id,
                   assignment, source_bbox, cropped) VALUES
('00000010-0000-7000-8000-000000000001', '00000006-0000-7000-8000-000000000001',
 '00000009-0000-7000-8000-000000000001', '{0.1,0.2,0.3,0.4}', '{"eyes": [[0.2, 0.3], [0.3, 0.3]]}', 'faces-v1',
 '\x0000803f', 0.9, '0000000f-0000-7000-8000-000000000001', 'user', '{0.1,0.2,0.3,0.4}', false),
('00000010-0000-7000-8000-000000000002', '00000006-0000-7000-8000-000000000003', NULL, '{0.5,0.5,0.2,0.2}', NULL,
 'faces-v1', '\x0000003f', 0.7, '0000000f-0000-7000-8000-000000000002', 'auto', NULL, false),
('00000010-0000-7000-8000-000000000003', '00000006-0000-7000-8000-000000000004', NULL, '{0.5,0.5,0.2,0.2}', NULL,
 'faces-v1', '\x0000003f', 0.6, NULL, 'auto', NULL, true);
UPDATE persons SET cover_face_id = '00000010-0000-7000-8000-000000000001'
WHERE id = '0000000f-0000-7000-8000-000000000001';
-- Since 0033: Ada agreed to the notice of version 1; the scans, the detector and the score of a face.
INSERT INTO face_consents (user_id, notice_version, granted_at) VALUES
('00000001-0000-7000-8000-000000000001', 1, '2026-01-04 09:00:00+00');
UPDATE faces SET score = 0.93, detector = 'yunet@2026may' WHERE id = '00000010-0000-7000-8000-000000000001';
INSERT INTO face_scans (asset_id, model_id, faces, scanned_at) VALUES
('00000006-0000-7000-8000-000000000001', 'sface@2021dec', 1, '2026-01-04 09:05:00+00'),
('00000006-0000-7000-8000-000000000002', 'sface@2021dec', 0, '2026-01-04 09:06:00+00');
INSERT INTO face_constraints (id, face_id, person_id, other_face_id, kind) VALUES
('00000011-0000-7000-8000-000000000001', '00000010-0000-7000-8000-000000000001',
 '0000000f-0000-7000-8000-000000000001', NULL, 'must_link'),
('00000011-0000-7000-8000-000000000002', '00000010-0000-7000-8000-000000000002', NULL,
 '00000010-0000-7000-8000-000000000003', 'cannot_link');

INSERT INTO user_places (id, user_id, name, lat, lon, radius_m, strip_on_share) VALUES
('00000012-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'Home', 52.52, 13.405, 150, true);
INSERT INTO memories (id, owner_id, kind, title_template, params, date, asset_ids, cover_asset_id, state) VALUES
('00000013-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'on_this_day',
 'memory.on_this_day', '{"years": 2}', '2026-05-01',
 '{00000006-0000-7000-8000-000000000001,00000006-0000-7000-8000-000000000002}',
 '00000006-0000-7000-8000-000000000001', 'new');

-- A processing grant to the trusted desktop, and jobs: leased, queued on a device and on the grant, dead, done by a
-- schedule and cancelled with a grant; schedules with and without a payload.
INSERT INTO processing_grants (id, user_id, processor, scope, purposes, wrapped_keys, ledger_ref, user_signature,
                               expires_at, revoked_at) VALUES
('00000014-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 '00000002-0000-7000-8000-000000000002', '{"libraries": ["00000003-0000-7000-8000-000000000002"]}',
 '{faces,search}', convert_to('wrapped library key', 'UTF8'), 'ledger:1', convert_to('signature of ada', 'UTF8'),
 '2027-01-01 00:00:00+00', NULL);
INSERT INTO jobs (id, type, payload, status, priority, placement, grant_id, attempts, run_after, lease_owner,
                  lease_until, progress, result, error, idempotency_key) VALUES
('00000015-0000-7000-8000-000000000001', 'thumbnail', convert_to('00000006-0000-7000-8000-000000000002', 'UTF8'),
 'running', 0, 'server', NULL, 1, '2026-01-07 00:00:00+00', 'worker:media@node-1', '2026-01-07 00:05:00+00', 0.5,
 NULL, NULL, 'thumbnail:00000006-0000-7000-8000-000000000002'),
('00000015-0000-7000-8000-000000000002', 'faces', NULL, 'queued', 5, 'trusted_node',
 '00000014-0000-7000-8000-000000000001', 0, '2026-01-07 00:00:00+00', NULL, NULL, NULL, NULL, NULL, NULL),
('00000015-0000-7000-8000-000000000003', 'embed', NULL, 'queued', 0, 'device', NULL, 0, '2026-01-07 00:00:00+00',
 NULL, NULL, NULL, NULL, NULL, NULL),
('00000015-0000-7000-8000-000000000004', 'scan', NULL, 'dead', 0, 'server', NULL, 3, '2026-01-07 00:00:00+00',
 NULL, NULL, NULL, NULL, 'library offline', 'scan:00000003-0000-7000-8000-000000000003'),
('00000015-0000-7000-8000-000000000005', 'reconcile', NULL, 'done', 0, 'server', NULL, 1, '2026-01-07 00:00:00+00',
 NULL, NULL, 1, convert_to('ok', 'UTF8'), NULL, 'cron:nightly:1767744000'),
('00000015-0000-7000-8000-000000000006', 'search', NULL, 'cancelled', 0, 'trusted_node',
 '00000014-0000-7000-8000-000000000001', 0, '2026-01-07 00:00:00+00', NULL, NULL, NULL, NULL, 'grant ended', NULL);
INSERT INTO job_schedules (name, cron, type, payload, next_run) VALUES
('nightly', '0 0 * * *', 'reconcile', NULL, '2026-01-08 00:00:00+00'),
('weekly-scan', '30 3 * * 1', 'scan', convert_to('00000003-0000-7000-8000-000000000003', 'UTF8'),
 '2026-01-12 03:30:00+00');

-- Since 0003 the users_audit trigger has chained an event for each account above; other events go through
-- audit_append.
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'link.revoke',
                    '{"link": "0000000e-0000-7000-8000-000000000003"}', NULL);
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'album.share',
                    '{"album": "0000000c-0000-7000-8000-000000000001"}',
                    '{"user": "00000001-0000-7000-8000-000000000003"}');

-- Ada makes Eli a viewer and deletes Fay's account, which awaits its purge; the trigger names her as the actor.
SELECT set_config('photolib.actor', '00000001-0000-7000-8000-000000000001', true);
UPDATE users SET role = 'viewer', quota_bytes = 0 WHERE id = '00000001-0000-7000-8000-000000000005';
UPDATE users SET status = 'deleted', purge_at = '2026-01-13 00:00:00+00'
WHERE id = '00000001-0000-7000-8000-000000000006';

-- The data directory and an S3 store; an intent in every state, and bytes that failed their hash.
INSERT INTO stores (name, id, created_at) VALUES
('local', '00000016-0000-7000-8000-000000000001', '2026-01-01 00:00:00+00'),
('b2', '00000016-0000-7000-8000-000000000002', '2026-01-02 00:00:00+00');
INSERT INTO file_intents (id, owner, kind, store, key, source, hash, size, state, created_at, finished_at) VALUES
('00000017-0000-7000-8000-000000000001', 7, 'put', 'local', '2024/05/IMG_0001.HEIC', '/var/tmp/upload-1',
 sha256('\x01'), 2400000, 'done', '2026-01-05 10:00:00+00', '2026-01-05 10:00:01+00'),
('00000017-0000-7000-8000-000000000002', 7, 'move', 'local', '2024/05/VID_0002.MOV', 'inbox/VID_0002.MOV',
 sha256('\x02'), 48000000, 'switched', '2026-01-05 10:01:00+00', NULL),
('00000017-0000-7000-8000-000000000003', 8, 'delete', 'b2', 'thumbs/old.webp', NULL, NULL, NULL, 'planned',
 '2026-01-05 10:02:00+00', NULL),
('00000017-0000-7000-8000-000000000004', 8, 'put', 'b2', '2019/08/PXL_0008.jpg', '/var/tmp/upload-2', sha256('\x08'),
 3000000, 'rolled_back', '2026-01-05 10:03:00+00', '2026-01-05 10:04:00+00');
INSERT INTO integrity_findings (id, store, key, detail, found_at) VALUES
('00000018-0000-7000-8000-000000000001', 'local', '2019/08/PXL_0008.jpg', 'blake3 differs from the recorded hash',
 '2026-01-06 00:02:00+00');

-- The private library lives on b2; an upload in progress into it, a complete one into Photos and an abandoned one.
UPDATE libraries SET store = 'b2' WHERE id = '00000003-0000-7000-8000-000000000002';
INSERT INTO uploads (id, owner_id, library_id, length, hash, received, store, key, completed_at, expires_at,
                     created_at) VALUES
('00000019-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000002', '00000003-0000-7000-8000-000000000002',
 10000000000, sha256('\x19'), 2516582400, NULL, NULL, NULL, '2026-01-08 10:00:00+00', '2026-01-07 09:00:00+00'),
('00000019-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000001', '00000003-0000-7000-8000-000000000001',
 2400000, sha256('\x01'), 2400000, 'local',
 'libraries/00000003-0000-7000-8000-000000000001/uploads/00000019-0000-7000-8000-000000000002',
 '2026-01-07 09:05:00+00', '2026-01-08 09:05:00+00', '2026-01-07 09:04:00+00'),
('00000019-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000005', '00000003-0000-7000-8000-000000000001',
 48000000, sha256('\x02'), 0, NULL, NULL, NULL, '2026-01-02 00:00:00+00', '2026-01-01 00:00:00+00');

-- Deletions sync still delivers: a signed-out device and a tag taken off an asset leave tombstones through the
-- capture triggers; older tombstones were purged up to the horizon.
INSERT INTO devices (id, user_id, name, platform) VALUES
('00000002-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000002', 'Old phone', 'ios');
INSERT INTO asset_tags (asset_id, tag_id) VALUES
('00000006-0000-7000-8000-000000000002', '0000000a-0000-7000-8000-000000000002');
DELETE FROM devices WHERE id = '00000002-0000-7000-8000-000000000003';
DELETE FROM asset_tags WHERE asset_id = '00000006-0000-7000-8000-000000000002';
INSERT INTO tombstone_horizon (txid) VALUES ('3');

-- Ingest: the complete upload's path on its device, a motion photo's video inside its original, a burst member.
UPDATE uploads SET path = 'DCIM/Camera/IMG_0001.HEIC' WHERE id = '00000019-0000-7000-8000-000000000002';
INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash, byte_offset) VALUES
('00000008-0000-7000-8000-000000000010', '00000006-0000-7000-8000-000000000008', 'motion_extracted', 'managed',
 '2019/08/PXL_0008.jpg', 'video/mp4', 1200000, sha256('\x88'), 1800000);
UPDATE assets SET burst_id = '0A5C3F7E-2B1D-4E6F-9A8B-7C6D5E4F3A2B', facets = '{burst_member}'
WHERE id = '00000006-0000-7000-8000-000000000008';

-- API keys since 0009: Ada's backup script in use, Bea's revoked frame key and an expired one of Ada's. A key's secret
-- is plk_ and its id's hex digits.
INSERT INTO api_keys (id, user_id, name, token_hash, scopes, expires_at, requests_per_minute, last_used_at,
                      revoked_at, created_at) VALUES
('00000020-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', 'backup script',
 sha256('plk_00000020000070008000000000000001'), '{view,download,contribute}', '2027-01-01 00:00:00+00', 600,
 '2026-01-07 03:00:00+00', NULL, '2026-01-02 00:00:00+00'),
('00000020-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000002', 'frame',
 sha256('plk_00000020000070008000000000000002'), '{view}', '2026-06-01 00:00:00+00', 60, NULL,
 '2026-01-05 00:00:00+00', '2026-01-03 00:00:00+00'),
('00000020-0000-7000-8000-000000000003', '00000001-0000-7000-8000-000000000001', 'old admin tool',
 sha256('plk_00000020000070008000000000000003'), '{manage_users}', '2026-01-04 00:00:00+00', 60000, NULL, NULL,
 '2025-12-01 00:00:00+00');
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'api_key.create',
                    '{"api_key_id": "00000020-0000-7000-8000-000000000001"}', NULL);
SELECT audit_append('00000001-0000-7000-8000-000000000002', 'api_key.revoke',
                    '{"api_key_id": "00000020-0000-7000-8000-000000000002"}', NULL);

-- Since 0010: Ada's password record and a session on each of her devices (one expired), and a password setup that
-- awaits Bea.
INSERT INTO password_records (user_id, credential, record, ksf_params) VALUES
('00000001-0000-7000-8000-000000000001',
 uuid_send('00000001-0000-7000-8000-000000000001') || '\x0f0e0d0c0b0a09080706050403020100',
 convert_to('OPAQUE registration record of ada', 'UTF8'),
 '\x0100040000000000030107070707070707070707070707070707');
INSERT INTO password_setups (user_id, token_hash, expires_at) VALUES
('00000001-0000-7000-8000-000000000002', sha256('\xb1'), '2026-01-08 00:00:00+00');
INSERT INTO sessions (id, device_id, token_hash, created_at, expires_at) VALUES
('0000001a-0000-7000-8000-000000000001', '00000002-0000-7000-8000-000000000001', sha256('\xc1'),
 '2026-01-02 10:00:00+00', '2026-04-02 10:00:00+00'),
('0000001a-0000-7000-8000-000000000002', '00000002-0000-7000-8000-000000000002', sha256('\xc2'),
 '2025-01-03 10:00:00+00', '2025-04-03 10:00:00+00');
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'session.create',
                    '{"user_id": "00000001-0000-7000-8000-000000000001", "device_id": "00000002-0000-7000-8000-000000000001"}',
                    '{}');

-- Thumbnails paused by Ada until the next morning, and stricter instance policies.
INSERT INTO job_pauses (type, until, paused_by) VALUES
('thumbnail', '2026-01-08 08:00:00+00', '00000001-0000-7000-8000-000000000001');
UPDATE instance_settings SET require_two_factor = true, trash_retention_days = 30, min_free_disk_percent = 10;

-- Since 0012: the ThumbHash of Ada's first photo.
UPDATE assets SET thumbhash = '\x1f08060d8277a9789ea8a77777888077f8ad4807'
WHERE id = '00000006-0000-7000-8000-000000000001';

-- Since 0013: Ada signs in with two OpenID Connect providers, Bea with one.
INSERT INTO oidc_identities (issuer, subject, user_id, created_at) VALUES
('https://sso.example.org/realms/home', '5f0c3a5e-ada', '00000001-0000-7000-8000-000000000001', '2026-01-04 10:00:00+00'),
('https://accounts.google.com', '104857600000000000001', '00000001-0000-7000-8000-000000000001',
 '2026-01-05 10:00:00+00'),
('https://sso.example.org/realms/home', '5f0c3a5e-bea', '00000001-0000-7000-8000-000000000002', '2026-01-06 10:00:00+00');
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'oidc.link',
                    '{"user_id": "00000001-0000-7000-8000-000000000001"}', '{}');

-- Since 0014: the source of a store move that the purge deletes a week after the switch.
INSERT INTO file_intents (id, owner, kind, store, key, state, created_at, due) VALUES
('00000017-0000-7000-8000-000000000011', 7, 'delete', 'local', 'libraries/old/originals/2024/IMG_0011.HEIC', 'switched',
 '2026-01-06 10:00:00+00', '2026-01-13 10:00:00+00');

-- Since 0016: the NAS archive's first scan, and a rescan with two folders left; the files they found: one ingested,
-- a PDF that is not media, one that could not be read and one that waits for ingest.
INSERT INTO library_scans (id, library_id, pending, started_at, finished_at) VALUES
('00000021-0000-7000-8000-000000000001', '00000003-0000-7000-8000-000000000003', 0, '2026-01-01 00:00:00+00',
 '2026-01-01 02:00:00+00'),
('00000021-0000-7000-8000-000000000002', '00000003-0000-7000-8000-000000000003', 2, '2026-01-07 00:00:00+00', NULL);
INSERT INTO library_files (library_id, dir, name, dev, inode, size, mtime_ns, state, asset_id, error) VALUES
('00000003-0000-7000-8000-000000000003', '1987', 'scan_1987_03.tif', 2049, 131074, 36000000, 1700000000000000000,
 'ingested', '00000006-0000-7000-8000-000000000007', NULL),
('00000003-0000-7000-8000-000000000003', '1987', 'contact sheet.pdf', 2049, 131075, 80000, 1700000000000000000,
 'unsupported', NULL, NULL),
('00000003-0000-7000-8000-000000000003', '1988', 'scan_1988_01.tif', 2049, 131076, 35000000, 1700000000000000000,
 'failed', NULL, 'cannot read "1988/scan_1988_01.tif": Permission denied (os error 13)'),
('00000003-0000-7000-8000-000000000003', '', 'IMG_0001.jpg', 2049, 131077, 2400000, 1767225600000000000, 'pending',
 NULL, NULL);

-- Since 0018: Ada's passkey, her TOTP secret and two unused recovery codes, under an instance that requires a second
-- factor.
INSERT INTO passkeys (id, user_id, credential_id, public_key, sign_count, name, created_at, last_used_at) VALUES
('0000001b-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001', '\x0102030405060708',
 convert_to('COSE key of ada''s passkey', 'UTF8'), 12, 'Ada''s phone', '2026-01-02 10:05:00+00',
 '2026-01-03 09:00:00+00');
INSERT INTO totp_secrets (user_id, secret, last_step) VALUES
('00000001-0000-7000-8000-000000000001', '\x3132333435363738393031323334353637383930', 58908200);
INSERT INTO recovery_codes (user_id, code_hash) VALUES
('00000001-0000-7000-8000-000000000001', sha256('aaaabbbbccccdddd')),
('00000001-0000-7000-8000-000000000001', sha256('eeeeffffgggghhhh'));
UPDATE instance_settings SET require_two_factor = true;
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'totp.enable',
                    '{"user_id": "00000001-0000-7000-8000-000000000001"}', '{}');

-- Since 0019: a PDF upload, kept as an asset without a media kind, that type detection version 1 checked.
INSERT INTO assets (id, library_id, owner_id, original_filename, source, source_ref, content_hash, sniff_version) VALUES
('00000006-0000-7000-8000-000000000014', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'notes.pdf', 'upload', 'Documents/notes.pdf', sha256('\x14'), 1);
INSERT INTO asset_files (id, asset_id, role, storage, key, mime, size, content_hash) VALUES
('00000008-0000-7000-8000-000000000011', '00000006-0000-7000-8000-000000000014', 'original', 'managed',
 '2026/01/notes.pdf', 'application/pdf', 52000, sha256('\x14'));
UPDATE assets SET sniff_version = 1 WHERE media_kind IS NOT NULL AND source = 'upload';

-- Since 0020: the secret of Ada's Pixel, and a session of her desktop rotated an hour ago whose new token was not used
-- yet, so that the old one still works.
UPDATE devices SET secret_hash = sha256('\xd1') WHERE id = '00000002-0000-7000-8000-000000000001';
INSERT INTO sessions (id, device_id, token_hash, created_at, expires_at, previous_token_hash, previous_expires_at) VALUES
('0000001a-0000-7000-8000-000000000003', '00000002-0000-7000-8000-000000000002', sha256('\xc4'),
 '2026-01-06 10:00:00+00', '2026-04-06 10:00:00+00', sha256('\xc3'), '2026-01-07 09:00:00+00');

-- Since 0021: an orphan the scrub found and a missing file it saw put back, where the scrubs of local and b2 are, the
-- Pixel's last backup report, a 30-day scrub cycle and devices silent after 24 hours.
INSERT INTO integrity_findings (id, store, key, detail, found_at, kind, resolved_at) VALUES
('00000018-0000-7000-8000-000000000002', 'local', 'libraries/00000003-0000-7000-8000-000000000001/originals/stray.jpg',
 'no file names it', '2026-01-07 00:00:00+00', 'orphan', NULL),
('00000018-0000-7000-8000-000000000003', 'local', '2026/01/notes.pdf', 'the object is gone', '2026-01-07 00:00:00+00',
 'missing', '2026-01-08 00:00:00+00');
INSERT INTO scrubs (store, checked_after, read_after, cycle_bytes, ran_at, cycle_ended_at, egress_month, egress_bytes)
VALUES
('local', '00000008-0000-7000-8000-000000000001', '00000000-0000-0000-0000-000000000000', 4000000,
 '2026-01-08 00:15:00+00', '2026-01-07 23:00:00+00', '2000-01-01', 0),
('b2', '00000000-0000-0000-0000-000000000000', '00000008-0000-7000-8000-000000000002', 1000000,
 '2026-01-08 00:15:00+00', NULL, '2026-01-01', 1000000);
INSERT INTO device_backups (device_id, reported_at, pending) VALUES
('00000002-0000-7000-8000-000000000001', '2026-01-02 10:00:00+00', 12);
UPDATE instance_settings SET scrub_days = 30, backup_silent_hours = 24;

-- Since 0022: bit-rot the scrub found in a file of the external NAS archive.
INSERT INTO integrity_findings (id, store, key, detail, found_at, kind, resolved_at, library_id) VALUES
('00000018-0000-7000-8000-000000000004', 'external', '1987/scan_1987_03.tif', 'it reads as Hash(00), Hash(01) recorded',
 '2026-01-08 00:00:00+00', 'content', NULL, '00000003-0000-7000-8000-000000000003');

-- Since 0023: the events the assets above recorded through their trigger, Ada's Home Assistant webhook, delivered up to
-- her first event, and Bea's, which failed with a 503 and waits.
INSERT INTO webhooks (id, owner_id, url, secret, created_at, after_txid, after_id, delivered_at, failing_since,
                      last_status) VALUES
('00000019-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'http://homeassistant.local:8123/api/webhook/photolib', sha256(convert_to('secret of Ada''s webhook', 'UTF8')),
 '2026-01-08 00:00:00+00', (SELECT txid FROM events ORDER BY txid, id LIMIT 1),
 (SELECT id FROM events ORDER BY txid, id LIMIT 1), '2026-01-08 00:01:00+00', NULL, NULL),
('00000019-0000-7000-8000-000000000002', '00000001-0000-7000-8000-000000000002', 'https://frame.example.org/hook',
 sha256(convert_to('secret of Bea''s webhook', 'UTF8')), '2026-01-08 00:00:00+00', '0', 0, NULL,
 '2026-01-08 00:01:00+00', 503);

-- Since 0024: the Family backup preset with uploads pinned on, Bea without face recognition and the NAS archive with
-- edits allowed.
INSERT INTO policy_switches (capability, user_id, library_id, enabled, pinned) VALUES
('managed_libraries', NULL, NULL, true, false), ('uploads', NULL, NULL, true, true),
('xmp_writes', NULL, NULL, false, false),
('face_recognition', '00000001-0000-7000-8000-000000000002', NULL, false, false),
('edits', NULL, '00000003-0000-7000-8000-000000000003', true, false);
SELECT audit_append('00000001-0000-7000-8000-000000000001', 'policy.preset', '{}', '{"preset": "family_backup"}');

-- Since 0025: the SigLIP 2 vector Ada's Pixel computed for the complete upload, 768 half floats of 1.0.
UPDATE uploads SET embedding_model = 'siglip2-b16-256@onnx-d1114256', embedding = decode(repeat('003c', 768), 'hex')
WHERE id = '00000019-0000-7000-8000-000000000002';

-- Since 0026: uploads pause below 50 GB free at most (0032 dropped the pauses' start).
UPDATE instance_settings SET min_free_disk_gb = 50;

-- Since 0027: a session that proved its person at sign-in.
UPDATE sessions SET proved_at = created_at WHERE id = '0000001a-0000-7000-8000-000000000001';

-- Since 0028: Ada's private-mode keys, her identity log's genesis in user_keys, with a password and a recovery kit she
-- verified; the bytes are stand-ins, which the server reads only by their headers.
UPDATE user_keys SET key_bundle = convert_to('identity log genesis of ada', 'UTF8')
WHERE user_id = '00000001-0000-7000-8000-000000000001';
INSERT INTO account_keys (user_id, amk_id, signing_key, decryption_key, recovery_verified_at, created_at) VALUES
('00000001-0000-7000-8000-000000000001', '\x000102030405060708090a0b0c0d0e0f', decode(repeat('08', 144), 'hex'),
 decode(repeat('09', 144), 'hex'), '2026-01-05 10:00:00+00', '2026-01-05 09:00:00+00');
INSERT INTO unlock_paths (user_id, kind, wrap, params, created_at) VALUES
('00000001-0000-7000-8000-000000000001', 'password', decode(repeat('01', 144), 'hex'), decode(repeat('02', 26), 'hex'),
 '2026-01-05 09:00:00+00'),
('00000001-0000-7000-8000-000000000001', 'recovery', decode(repeat('03', 144), 'hex'), NULL, '2026-01-05 09:00:00+00');

-- Since 0029: last night's backup, the drill that restored it, and a drill that failed the night before.
INSERT INTO backup_runs (id, kind, store, dump, ok, detail, finished_at) VALUES
('00000022-0000-7000-8000-000000000001', 'drill', 'local', 'backups/backup-20260105T030000Z.dump', false,
 'permission denied to create database', '2026-01-05 03:10:00+00'),
('00000022-0000-7000-8000-000000000002', 'backup', 'local', 'backups/backup-20260106T030000Z.dump', true,
 '1048576 bytes', '2026-01-06 03:01:00+00'),
('00000022-0000-7000-8000-000000000003', 'drill', 'local', 'backups/backup-20260106T030000Z.dump', true,
 'restored at schema 29: 2 accounts, 7 assets, 1 albums', '2026-01-06 03:02:00+00');

-- Since 0030: the NAS archive's first scan found its contact sheet missing and held it for a confirmation, having
-- listed the root and 1987 and skipped the unreadable 1988; its root's fingerprint, and a folder no watch covers.
UPDATE library_scans SET missing = 1, held = true WHERE id = '00000021-0000-7000-8000-000000000001';
INSERT INTO scan_dirs (scan_id, dir, skipped) VALUES
('00000021-0000-7000-8000-000000000001', '', false),
('00000021-0000-7000-8000-000000000001', '1987', false),
('00000021-0000-7000-8000-000000000001', '1988', true);
UPDATE library_files SET missing_since = '2026-01-01 02:00:00+00', unseen = '00000021-0000-7000-8000-000000000001'
WHERE name = 'contact sheet.pdf';
UPDATE library_files SET found_at = '2026-01-01 00:10:00+00';
UPDATE libraries SET fingerprint = '{1987,1988,IMG_0001.jpg}', unwatched = 1
WHERE id = '00000003-0000-7000-8000-000000000003';

-- Since 0031: edits from devices' outboxes, with the clock of each field's and membership's last change, one
-- mutation applied and one refused, and an asset removed from an album later than it was added.
UPDATE assets SET title = 'Tram', rating = 4,
    field_hlc = '{"title": "1767225600000-0000000000-00000002-0000-7000-8000-000000000001",
                  "rating": "1767225600000-0000000001-00000002-0000-7000-8000-000000000001"}'
WHERE id = '00000006-0000-7000-8000-000000000001';
UPDATE asset_user_state SET field_hlc = '{"favorite": "1767225600000-0000000002-00000002-0000-7000-8000-000000000001"}'
WHERE user_id = '00000001-0000-7000-8000-000000000002' AND asset_id = '00000006-0000-7000-8000-000000000001';
UPDATE album_items SET field_hlc = '{"sort_key": "1767225600000-0000000003-00000002-0000-7000-8000-000000000001"}'
WHERE id = '0000000d-0000-7000-8000-000000000004';
INSERT INTO album_item_states (id, album_id, asset_id, present, sort_key, field_hlc) VALUES
('0000000d-0000-7000-8000-000000000004', '0000000c-0000-7000-8000-000000000001',
 '00000006-0000-7000-8000-000000000002', true, 'a3',
 '{"present": "1767225600000-0000000004-00000002-0000-7000-8000-000000000001",
   "sort_key": "1767225600000-0000000003-00000002-0000-7000-8000-000000000001"}'),
('0000000d-0000-7000-8000-000000000010', '0000000c-0000-7000-8000-000000000001',
 '00000006-0000-7000-8000-000000000004', false, 'a8',
 '{"present": "1767225600000-0000000005-00000002-0000-7000-8000-000000000001"}');
INSERT INTO processed_mutations (user_id, mutation_id, rejected) VALUES
('00000001-0000-7000-8000-000000000001', '00000022-0000-7000-8000-000000000001', NULL),
('00000001-0000-7000-8000-000000000001', '00000022-0000-7000-8000-000000000002', 'mutation.forbidden');

-- photolib:drift
-- What years of use leave behind, loaded for the drifted case only. Duplicate hashes: the same bytes uploaded twice
-- into one library, and an e-mail address that differs only in case.
INSERT INTO assets (id, library_id, owner_id, original_filename, source, content_hash, media_kind) VALUES
('00000006-0000-7000-8000-000000000101', '00000003-0000-7000-8000-000000000001', '00000001-0000-7000-8000-000000000001',
 'IMG_0001 copy.HEIC', 'upload', sha256('\x01'), 'image');
INSERT INTO asset_files (id, asset_id, role, storage, key, content_hash) VALUES
('00000008-0000-7000-8000-000000000101', '00000006-0000-7000-8000-000000000101', 'original', 'managed',
 '2024/05/IMG_0001 copy.HEIC', sha256('\x01'));
INSERT INTO users (id, handle, display_name, email) VALUES
('00000001-0000-7000-8000-000000000101', 'ada2', 'Ada', 'ADA@example.org');

-- Orphans: rows whose asset was deleted while triggers were off, and ids that no foreign key guards.
SET session_replication_role = replica;
INSERT INTO asset_files (id, asset_id, role, storage, key) VALUES
('00000008-0000-7000-8000-000000000102', '00000006-0000-7000-8000-0000000001ff', 'thumbnail', 'derived',
 'thumbs/00000006-0000-7000-8000-0000000001ff.webp');
INSERT INTO faces (id, asset_id, bbox, model_id) VALUES
('00000010-0000-7000-8000-000000000101', '00000006-0000-7000-8000-0000000001ff', '{0,0,1,1}', 'faces-v1');
INSERT INTO file_intents (id, owner, kind, store, key) VALUES
('00000017-0000-7000-8000-000000000101', 9, 'delete', 'removed', 'a.jpg');
RESET session_replication_role;
UPDATE memories SET asset_ids = asset_ids || '00000006-0000-7000-8000-0000000001ff'::uuid;
INSERT INTO audit_events (actor_user_id, action, hash) VALUES
('00000001-0000-7000-8000-0000000001ff', 'user.delete', sha256('\xa3'));

-- Indexes an administrator added by hand.
CREATE INDEX manual_assets_camera ON assets (make, model);
CREATE INDEX manual_users_email ON users (lower(email));

-- Settings left on the database and on the role in it.
DO $$BEGIN
    EXECUTE format('ALTER DATABASE %I SET timezone = %L', current_database(), 'Pacific/Chatham');
    EXECUTE format('ALTER DATABASE %I SET datestyle = %L', current_database(), 'SQL, DMY');
    EXECUTE format('ALTER DATABASE %I SET photolib.legacy_mode = %L', current_database(), 'on');
    EXECUTE format('ALTER ROLE CURRENT_USER IN DATABASE %I SET intervalstyle = %L', current_database(), 'iso_8601');
    EXECUTE format('ALTER ROLE CURRENT_USER IN DATABASE %I SET work_mem = %L', current_database(), '1MB');
END$$;

import 'package:photolib_data/photolib_data.dart';

/// A platform that keeps nothing but what it was asked, and asks first when
/// [asks].
class FakePlatform implements MediaPlatform {
  new({this.asks = false, this.restores = true, this.expires = false});

  final bool asks;

  /// Each call, as `<what> <source ids>`.
  final calls = <String>[];

  void _call(String what, List<LocalAssetData> items) =>
      calls.add('$what ${[for (final i in items) i.sourceId].join(',')}');

  @override
  final bool expires;

  @override
  final bool restores;

  @override
  Future<bool> asksFirst() async => asks;

  @override
  Future<List<Binned>> trash(List<LocalAssetData> items) async {
    _call('trash', items);
    return [for (final _ in items) (bin: null, expires: null)];
  }

  @override
  Future<void> restore(List<LocalAssetData> items) async =>
      _call('restore', items);

  @override
  Future<void> purge(List<LocalAssetData> items) async => _call('purge', items);

  @override
  Future<void> favorite(
    List<LocalAssetData> items, {
    required bool value,
  }) async => _call('favorite $value', items);
}

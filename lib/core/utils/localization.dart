import 'package:flutter/foundation.dart';
import 'package:hiv/data/remote_config_datasource.dart';

class LocalizationRepositoryImpl {
  final RemoteConfigDatasource _datasource;
  final String _appId;

  // Кэш в памяти
  Map<String, dynamic> _data = {};

  LocalizationRepositoryImpl(this._datasource, this._appId);

  Future<void> init() async {
    try {
      final result = await _datasource.getStringConfig(_appId);
      if (result != null) {
        _data = result;
      }
    } catch (e) {
      debugPrint('Localization init error: $e');
    }
  }

  String get(String key, String lang) {
    // Структура в БД: { "ru": { "key": "val" }, "kk": { "key": "val" } }
    return _data[lang]?[key] ?? _data['ru']?[key] ?? key;
  }
}
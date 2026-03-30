import 'package:shared_preferences/shared_preferences.dart';

/// Сохранение выбранного языка между сессиями.
class LanguageService {
  static const _key = 'is_kazakh';

  static Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> save(bool isKazakh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isKazakh);
  }
}
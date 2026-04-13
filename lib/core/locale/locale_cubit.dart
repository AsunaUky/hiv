import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Управляет текущей локалью приложения и сохраняет выбор между сессиями.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru')) {
    _load();
  }

  static const _key = 'locale_code';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'ru';
    emit(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    emit(locale);
  }
}
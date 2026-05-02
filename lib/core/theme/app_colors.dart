import 'package:flutter/material.dart';

abstract final class AppColors {
  // Основная палитра
  static const Color background = Color(0xFF9FFFF9);
  static const Color primary    = Color(0xFF49C4BB);
  static const Color primaryDark = Color(0xFF2E9E96);
  static const Color surface    = Color(0xFFFFFFFF);

  // Текст
  static const Color textPrimary   = Color(0xFF1A2E2D);
  static const Color textSecondary = Color(0xFF4A6B69);
  static const Color textHint      = Color(0xFF8AADAB);

  // ui
  static const Color divider = Color(0xFFCAF0EE);
  static const Color error   = Color(0xFFB00020);
  static const Color overlay = Color(0x33000000);

    /// Цвет текста/иконок на primary-фоне.
  static const Color onPrimary = Colors.white;

  // ── Пункты доверия ─────────────────────────────────────────────────────────

  /// Маркер и акцент городских поликлиник.
  static const Color trustPolyclinic = Color(0xFF1565C0); // Blue 800

  /// Маркер и акцент кожно-венерологического диспансера.
  static const Color trustDermatoVenerologic = Color(0xFF6A1B9A); // Purple 800

  /// Маркер и акцент Центра СПИД.
  static const Color trustAidsCenter = Color(0xFFB71C1C); // Red 900
}
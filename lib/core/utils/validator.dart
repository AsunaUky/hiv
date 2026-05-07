import 'package:hiv/l10n/generated/app_localizations.dart';

/// Валидаторы полей форм.
abstract final class AppValidators {

  // ── Email ─────────────────────────────────────────────────────────
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validatorEnterEmail;
    final re = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!re.hasMatch(value.trim())) return l10n.validatorInvalidEmail;
    return null;
  }

  // ── Пароль при ВХОДЕ — только проверка на пустоту ─────────────────
  // Использовать на LoginScreen. Сложность не проверяем —
  // пользователь уже мог зарегистрироваться со старым паролем.
  static String? loginPassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.validatorEnterPassword;
    return null;
  }

  // ── Пароль при РЕГИСТРАЦИИ / смене пароля — полная проверка ───────
  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.validatorEnterPassword;
    if (value.length < 8) return l10n.validatorMinPassword;
    if (!value.contains(RegExp(r'[A-Za-zА-Яа-яЁё]'))) {
      return l10n.validatorPasswordNeedsLetter;
    }
    if (!value.contains(RegExp(r'\d'))) {
      return l10n.validatorPasswordNeedsDigit;
    }
    return null;
  }

  // ── Подтверждение пароля ──────────────────────────────────────────
  static String? confirmPassword(String? value, String original, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.validatorRepeatPassword;
    if (value != original) return l10n.validatorPasswordMismatch;
    return null;
  }

  // ── Имя ───────────────────────────────────────────────────────────
  static String? name(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validatorEnterName;
    if (value.trim().length < 3) return l10n.validatorNameTooShort;
    if (value.trim().length > 20) return l10n.validatorNameTooLong;
    // if (value.contains(RegExp(r'\d'))) return l10n.validatorNameNoDigits;
    if (value.contains(RegExp(r'[~@#$%^&*()+=\[\]{}|\\<>!?/]'))) {
      return l10n.validatorNameInvalidChars;
    }
    return null;
  }
}
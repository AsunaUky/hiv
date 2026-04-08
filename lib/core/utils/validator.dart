/// Валидаторы полей форм.
abstract final class AppValidators {

  // ── Email ─────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите email';
    final re = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!re.hasMatch(value.trim())) return 'Некорректный email';
    return null;
  }

  // ── Пароль при ВХОДЕ — только проверка на пустоту ─────────────────
  // Использовать на LoginScreen. Сложность не проверяем —
  // пользователь уже мог зарегистрироваться со старым паролем.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    return null;
  }

  // ── Пароль при РЕГИСТРАЦИИ / смене пароля — полная проверка ───────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    if (value.length < 8) return 'Минимум 8 символов';
    if (!value.contains(RegExp(r'[A-Za-zА-Яа-яЁё]'))) {
      return 'Добавьте хотя бы одну букву';
    }
    if (!value.contains(RegExp(r'\d'))) {
      return 'Добавьте хотя бы одну цифру';
    }
    return null;
  }

  // ── Подтверждение пароля ──────────────────────────────────────────
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Повторите пароль';
    if (value != original) return 'Пароли не совпадают';
    return null;
  }

  // ── Имя ───────────────────────────────────────────────────────────
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите имя';
    if (value.trim().length < 2) return 'Слишком короткое имя';
    if (value.contains(RegExp(r'\d'))) return 'Имя не должно содержать цифры';
    if (value.contains(RegExp(r'[@#$%^&*()+=\[\]{}|\\<>?/]'))) {
      return 'Имя содержит недопустимые символы';
    }
    return null;
  }
}
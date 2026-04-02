/// Валидаторы полей форм.
///
/// Использование:
/// ```dart
/// validator: AppValidators.email,
/// validator: AppValidators.password,
/// validator: (v) => AppValidators.confirmPassword(v, _passCtrl.text),
/// ```
abstract final class AppValidators {
  // Email — RFC-совместимая проверка через RegExp
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите email';
    final re = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!re.hasMatch(value.trim())) return 'Некорректный email';
    return null;
  }

  // Пароль — минимум 8 символов, хотя бы одна буква и одна цифра
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    if (value.length < 8) return 'Минимум 8 символов';
    if (!value.contains(RegExp(r'[A-Za-zА-Яа-я]'))) return 'Добавьте хотя бы одну букву';
    if (!value.contains(RegExp(r'\d'))) return 'Добавьте хотя бы одну цифру';
    return null;
  }

  // Подтверждение пароля
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Повторите пароль';
    if (value != original) return 'Пароли не совпадают';
    return null;
  }

  // Имя — только буквы и пробелы, минимум 2 символа
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите имя';
    if (value.trim().length < 2) return 'Слишком короткое имя';
    final re = RegExp(r"^[A-Za-zА-Яа-яЁёҚқҰұҢңӘәҒғҺһІі'\- ]+$");
    if (!re.hasMatch(value.trim())) return 'Имя содержит недопустимые символы';
    return null;
  }
}
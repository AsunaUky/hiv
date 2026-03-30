/// Локализация приложения — русский и казахский.
///
/// Использование:
/// ```dart
/// final l = AppLocale.of(isKazakh);
/// Text(l.profile)
/// ```
abstract final class AppLocale {
  static AppStrings of(bool isKazakh) =>
      isKazakh ? const KzStrings() : const RuStrings();
}

/// Базовый класс строк.
abstract class AppStrings {
  const AppStrings();
  // Профиль
  String get profile;
  String get editProfile;
  String get signOut;
  String get deleteAccount;
  String get language;

  // Диалоги
  String get cancel;
  String get confirm;
  String get signOutConfirm;
  String get deleteConfirm;
  String get deleteWarning;
  String get reAuthRequired;

  // Аккаунт
  String get account;
  String get guest;
  String get signIn;
  String get register;

  // Общие
  String get save;
  String get error;
  String get loading;
}

/// Русский
class RuStrings extends AppStrings {
  const RuStrings();

  @override String get profile       => 'Профиль';
  @override String get editProfile   => 'Редактировать профиль';
  @override String get signOut       => 'Выйти';
  @override String get deleteAccount => 'Удалить аккаунт';
  @override String get language      => 'Язык';

  @override String get cancel        => 'Отмена';
  @override String get confirm       => 'Подтвердить';
  @override String get signOutConfirm  => 'Вы уверены, что хотите выйти?';
  @override String get deleteConfirm   => 'Удалить аккаунт';
  @override String get deleteWarning   => 'Это действие необратимо. Все данные будут удалены.';
  @override String get reAuthRequired  => 'Требуется повторный вход. Выйдите и войдите снова.';

  @override String get account       => 'Аккаунт';
  @override String get guest         => 'Гость';
  @override String get signIn        => 'Войти';
  @override String get register      => 'Зарегистрироваться';

  @override String get save          => 'Сохранить';
  @override String get error         => 'Произошла ошибка';
  @override String get loading       => 'Загрузка...';
}

/// Казахский
class KzStrings extends AppStrings {
  const KzStrings();

  @override String get profile       => 'Профиль';
  @override String get editProfile   => 'Профильді өзгерту';
  @override String get signOut       => 'Шығу';
  @override String get deleteAccount => 'Аккаунтты жою';
  @override String get language      => 'Тіл';

  @override String get cancel        => 'Болдырмау';
  @override String get confirm       => 'Растау';
  @override String get signOutConfirm  => 'Аккаунттан шыққыңыз келе ме?';
  @override String get deleteConfirm   => 'Аккаунтты жою';
  @override String get deleteWarning   => 'Бұл әрекетті кері қайтару мүмкін емес.';
  @override String get reAuthRequired  => 'Қайта кіру қажет. Шығып, қайта кіріңіз.';

  @override String get account       => 'Аккаунт';
  @override String get guest         => 'Қонақ';
  @override String get signIn        => 'Кіру';
  @override String get register      => 'Тіркелу';

  @override String get save          => 'Сақтау';
  @override String get error         => 'Қате орын алды';
  @override String get loading       => 'Жүктелуде...';
}
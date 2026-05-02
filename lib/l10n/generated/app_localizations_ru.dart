// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navMap => 'Карта';

  @override
  String get navTest => 'Тест';

  @override
  String get navInfo => 'Информация';

  @override
  String get navProfile => 'Профиль';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileDeleteAccount => 'Удалить аккаунт';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileAccount => 'Аккаунт';

  @override
  String get profileGuest => 'Гость';

  @override
  String get profileGuestSubtitle =>
      'Зарегистрируйтесь, чтобы открыть все возможности';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authRegister => 'Зарегистрироваться';

  @override
  String get authCancel => 'Отмена';

  @override
  String get authConfirm => 'Подтвердить';

  @override
  String get authSignOutTitle => 'Выйти';

  @override
  String get authSignOutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get authDeleteTitle => 'Удалить аккаунт';

  @override
  String get authDeleteWarning =>
      'Это действие необратимо. Все данные будут удалены.';

  @override
  String get authDeleteConfirmBtn => 'Удалить';

  @override
  String get authReAuthRequired =>
      'Требуется повторный вход. Выйдите и войдите снова.';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonError => 'Произошла ошибка';

  @override
  String get commonLoading => 'Загрузка...';

  @override
  String get editTitle => 'Редактировать профиль';

  @override
  String get editNoGalleryAccess => 'Нет доступа к галерее';

  @override
  String get editNameLabel => 'Имя';

  @override
  String get editNamePlaceholder => 'Ваше имя';

  @override
  String get editChangePasswordLabel => 'Смена пароля';

  @override
  String get editCurrentPassword => 'Текущий пароль';

  @override
  String get editNewPassword => 'Новый пароль';

  @override
  String get editConfirmPassword => 'Повторите новый пароль';

  @override
  String get editSuccess => 'Профиль обновлён';

  @override
  String get editErrorSave => 'Ошибка сохранения. Попробуйте снова.';

  @override
  String get editWrongPassword => 'Неверный текущий пароль';

  @override
  String get editWeakPassword => 'Слишком простой пароль';

  @override
  String get editRecentLogin => 'Выйдите и войдите снова';

  @override
  String get infoTitle => 'Информация';

  @override
  String get testTitle => 'Тест оценки риска';

  @override
  String get testDescription =>
      'Ответьте на 10 вопросов — система оценит уровень риска и даст персональную рекомендацию.';

  @override
  String get testPrivacyNote =>
      'Все ответы анонимны и конфиденциальны. Данные не сохраняются.';

  @override
  String get testStartButton => 'Пройти тест';

  @override
  String get testFinishButton => 'Завершить тест';

  @override
  String testHistoryTitle(int count) {
    return 'История прохождений ($count)';
  }

  @override
  String get testResultRetry => 'Пройти ещё раз';

  @override
  String get testRiskHigh => 'Высокий риск';

  @override
  String get testRiskModerate => 'Умеренный риск';

  @override
  String get testRiskMinimal => 'Минимальный риск';

  @override
  String get mapTitle => 'Пункты доверия';

  @override
  String get mapFindMe => 'Найти меня';

  @override
  String get mapLocationError => 'Не удалось определить местоположение';

  @override
  String get mapRouteButton => 'Построить маршрут';

  @override
  String get mapHoursLabel => 'Режим работы';

  @override
  String get mapServicesLabel => 'Перечень услуг';

  @override
  String get mapLegendPolyclinic => 'Поликлиника';

  @override
  String get mapLegendDerma => 'Кожвендиспансер';

  @override
  String get mapLegendAids => 'Центр СПИД';

  @override
  String get close => 'Закрыть';

  @override
  String get retry => 'Повторить';
}

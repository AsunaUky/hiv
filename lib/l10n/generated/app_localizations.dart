import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @navMap.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get navMap;

  /// No description provided for @navTest.
  ///
  /// In ru, this message translates to:
  /// **'Тест'**
  String get navTest;

  /// No description provided for @navInfo.
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get navInfo;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get profileEdit;

  /// No description provided for @profileSignOut.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileSignOut;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get profileDeleteAccount;

  /// No description provided for @profileLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get profileLanguage;

  /// No description provided for @profileAccount.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get profileAccount;

  /// No description provided for @profileGuest.
  ///
  /// In ru, this message translates to:
  /// **'Гость'**
  String get profileGuest;

  /// No description provided for @profileGuestSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрируйтесь, чтобы открыть все возможности'**
  String get profileGuestSubtitle;

  /// No description provided for @authSignIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get authSignIn;

  /// No description provided for @authRegister.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get authRegister;

  /// No description provided for @authCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get authCancel;

  /// No description provided for @authConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get authConfirm;

  /// No description provided for @authSignOutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get authSignOutTitle;

  /// No description provided for @authSignOutConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите выйти?'**
  String get authSignOutConfirm;

  /// No description provided for @authDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get authDeleteTitle;

  /// No description provided for @authDeleteWarning.
  ///
  /// In ru, this message translates to:
  /// **'Это действие необратимо. Все данные будут удалены.'**
  String get authDeleteWarning;

  /// No description provided for @authDeleteConfirmBtn.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get authDeleteConfirmBtn;

  /// No description provided for @authReAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Требуется повторный вход. Выйдите и войдите снова.'**
  String get authReAuthRequired;

  /// No description provided for @commonSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get commonSave;

  /// No description provided for @commonError.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка'**
  String get commonError;

  /// No description provided for @commonLoading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get commonLoading;

  /// No description provided for @editTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get editTitle;

  /// No description provided for @editNoGalleryAccess.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к галерее'**
  String get editNoGalleryAccess;

  /// No description provided for @editNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get editNameLabel;

  /// No description provided for @editNamePlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Ваше имя'**
  String get editNamePlaceholder;

  /// No description provided for @editChangePasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Смена пароля'**
  String get editChangePasswordLabel;

  /// No description provided for @editCurrentPassword.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пароль'**
  String get editCurrentPassword;

  /// No description provided for @editNewPassword.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get editNewPassword;

  /// No description provided for @editConfirmPassword.
  ///
  /// In ru, this message translates to:
  /// **'Повторите новый пароль'**
  String get editConfirmPassword;

  /// No description provided for @editSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Профиль обновлён'**
  String get editSuccess;

  /// No description provided for @editErrorSave.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сохранения. Попробуйте снова.'**
  String get editErrorSave;

  /// No description provided for @editWrongPassword.
  ///
  /// In ru, this message translates to:
  /// **'Неверный текущий пароль'**
  String get editWrongPassword;

  /// No description provided for @editWeakPassword.
  ///
  /// In ru, this message translates to:
  /// **'Слишком простой пароль'**
  String get editWeakPassword;

  /// No description provided for @editRecentLogin.
  ///
  /// In ru, this message translates to:
  /// **'Выйдите и войдите снова'**
  String get editRecentLogin;

  /// No description provided for @infoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get infoTitle;

  /// No description provided for @validatorEnterEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите email'**
  String get validatorEnterEmail;

  /// No description provided for @validatorInvalidEmail.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный email'**
  String get validatorInvalidEmail;

  /// No description provided for @validatorEnterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get validatorEnterPassword;

  /// No description provided for @validatorMinPassword.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 8 символов'**
  String get validatorMinPassword;

  /// No description provided for @validatorPasswordNeedsLetter.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте хотя бы одну букву'**
  String get validatorPasswordNeedsLetter;

  /// No description provided for @validatorPasswordNeedsDigit.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте хотя бы одну цифру'**
  String get validatorPasswordNeedsDigit;

  /// No description provided for @validatorRepeatPassword.
  ///
  /// In ru, this message translates to:
  /// **'Повторите пароль'**
  String get validatorRepeatPassword;

  /// No description provided for @validatorPasswordMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get validatorPasswordMismatch;

  /// No description provided for @validatorEnterName.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get validatorEnterName;

  /// No description provided for @validatorNameTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Слишком короткое имя'**
  String get validatorNameTooShort;

  /// No description provided for @validatorNameTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Не более 20 символов'**
  String get validatorNameTooLong;

  /// No description provided for @validatorNameNoDigits.
  ///
  /// In ru, this message translates to:
  /// **'Имя не должно содержать цифры'**
  String get validatorNameNoDigits;

  /// No description provided for @validatorNameInvalidChars.
  ///
  /// In ru, this message translates to:
  /// **'Имя содержит недопустимые символы'**
  String get validatorNameInvalidChars;

  /// No description provided for @testTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тест оценки риска'**
  String get testTitle;

  /// No description provided for @testDescription.
  ///
  /// In ru, this message translates to:
  /// **'Ответьте на 10 вопросов — система оценит уровень риска и даст персональную рекомендацию.'**
  String get testDescription;

  /// No description provided for @testPrivacyNote.
  ///
  /// In ru, this message translates to:
  /// **'Все ответы анонимны и конфиденциальны. Данные не сохраняются.'**
  String get testPrivacyNote;

  /// No description provided for @testStartButton.
  ///
  /// In ru, this message translates to:
  /// **'Пройти тест'**
  String get testStartButton;

  /// No description provided for @testFinishButton.
  ///
  /// In ru, this message translates to:
  /// **'Завершить тест'**
  String get testFinishButton;

  /// No description provided for @testAllQuestionsAnswered.
  ///
  /// In ru, this message translates to:
  /// **'Все вопросы пройдены!'**
  String get testAllQuestionsAnswered;

  /// No description provided for @testHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История прохождений ({count})'**
  String testHistoryTitle(int count);

  /// No description provided for @testResultRetry.
  ///
  /// In ru, this message translates to:
  /// **'Пройти ещё раз'**
  String get testResultRetry;

  /// No description provided for @testRiskHigh.
  ///
  /// In ru, this message translates to:
  /// **'Высокий риск'**
  String get testRiskHigh;

  /// No description provided for @testRiskModerate.
  ///
  /// In ru, this message translates to:
  /// **'Умеренный риск'**
  String get testRiskModerate;

  /// No description provided for @testRiskMinimal.
  ///
  /// In ru, this message translates to:
  /// **'Минимальный риск'**
  String get testRiskMinimal;

  /// No description provided for @mapTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пункты доверия'**
  String get mapTitle;

  /// No description provided for @mapFindMe.
  ///
  /// In ru, this message translates to:
  /// **'Найти меня'**
  String get mapFindMe;

  /// No description provided for @mapLocationError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось определить местоположение'**
  String get mapLocationError;

  /// No description provided for @mapRouteButton.
  ///
  /// In ru, this message translates to:
  /// **'Построить маршрут'**
  String get mapRouteButton;

  /// No description provided for @mapHoursLabel.
  ///
  /// In ru, this message translates to:
  /// **'Режим работы'**
  String get mapHoursLabel;

  /// No description provided for @mapServicesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Перечень услуг'**
  String get mapServicesLabel;

  /// No description provided for @mapLegendPolyclinic.
  ///
  /// In ru, this message translates to:
  /// **'Поликлиника'**
  String get mapLegendPolyclinic;

  /// No description provided for @mapLegendDerma.
  ///
  /// In ru, this message translates to:
  /// **'Кожвендиспансер'**
  String get mapLegendDerma;

  /// No description provided for @mapLegendAids.
  ///
  /// In ru, this message translates to:
  /// **'Центр СПИД'**
  String get mapLegendAids;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @mapLocationGpsOff.
  ///
  /// In ru, this message translates to:
  /// **'Включите GPS на устройстве'**
  String get mapLocationGpsOff;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт с таким email не найден. Проверьте данные или зарегистрируйтесь.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In ru, this message translates to:
  /// **'Неверный пароль. Попробуйте ещё раз.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный формат email.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In ru, this message translates to:
  /// **'Этот аккаунт заблокирован. Обратитесь в поддержку.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In ru, this message translates to:
  /// **'Слишком много попыток. Попробуйте позже.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetworkFailed.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения к интернету.'**
  String get authErrorNetworkFailed;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт с таким email уже существует. Попробуйте войти.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль слишком простой. Используйте не менее 6 символов.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorDefault.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка входа. Попробуйте ещё раз.'**
  String get authErrorDefault;

  /// No description provided for @authRegisterErrorDefault.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка регистрации. Попробуйте ещё раз.'**
  String get authRegisterErrorDefault;

  /// No description provided for @authSessionExpired.
  ///
  /// In ru, this message translates to:
  /// **'Сессия устарела. Выйдите и войдите снова, затем повторите удаление.'**
  String get authSessionExpired;

  /// No description provided for @authGoogleCanceled.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение через Google отменено.'**
  String get authGoogleCanceled;

  /// No description provided for @authStatusLoggedOut.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь вышел'**
  String get authStatusLoggedOut;

  /// No description provided for @authStatusAccountDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт удалён напрямую'**
  String get authStatusAccountDeleted;

  /// No description provided for @authStatusAccountDeletedGoogle.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт удалён (через Google)'**
  String get authStatusAccountDeletedGoogle;

  /// No description provided for @authStatusError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get authStatusError;

  /// No description provided for @authStatusWarningReauth.
  ///
  /// In ru, this message translates to:
  /// **'Требуется повторная авторизация'**
  String get authStatusWarningReauth;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

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

  /// No description provided for @articlesWhatIsHivTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что такое ВИЧ'**
  String get articlesWhatIsHivTitle;

  /// No description provided for @articlesWhatIsHivSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Полный гид по вирусу: биология, стадии развития и лабораторные показатели.'**
  String get articlesWhatIsHivSubtitle;

  /// No description provided for @articlesWhatIsHivB0Heading.
  ///
  /// In ru, this message translates to:
  /// **'1. Биологическая природа вируса'**
  String get articlesWhatIsHivB0Heading;

  /// No description provided for @articlesWhatIsHivB0P0.
  ///
  /// In ru, this message translates to:
  /// **'ВИЧ (Вирус Иммунодефицита Человека) относится к семейству ретровирусов, роду лентивирусов (от лат. lentus — медленный). Название рода отражает суть болезни: она развивается годами, постепенно истощая ресурсы организма.'**
  String get articlesWhatIsHivB0P0;

  /// No description provided for @articlesWhatIsHivB0P1.
  ///
  /// In ru, this message translates to:
  /// **'Вирион (частица ВИЧ) представляет собой сферу, покрытую оболочкой. Внутри находятся:'**
  String get articlesWhatIsHivB0P1;

  /// No description provided for @articlesWhatIsHivB0Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Две нити РНК — генетический код вируса.'**
  String get articlesWhatIsHivB0Bl0;

  /// No description provided for @articlesWhatIsHivB0Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Ферменты: обратная транскриптаза, интеграза и протеаза. Они позволяют вирусу превращать свою РНК в ДНК и встраиваться в геном человека.'**
  String get articlesWhatIsHivB0Bl1;

  /// No description provided for @articlesWhatIsHivB0Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Гликопротеины (gp120 и gp41) — «шипы» на поверхности, помогающие вирусу прикрепляться к клеткам крови.'**
  String get articlesWhatIsHivB0Bl2;

  /// No description provided for @articlesWhatIsHivB1Heading.
  ///
  /// In ru, this message translates to:
  /// **'2. Механизм захвата иммунитета'**
  String get articlesWhatIsHivB1Heading;

  /// No description provided for @articlesWhatIsHivB1P0.
  ///
  /// In ru, this message translates to:
  /// **'Основная мишень ВИЧ — CD4-лимфоциты (Т-хелперы). Это «командиры» иммунной системы, которые дают команду другим клеткам начать борьбу с инфекцией.'**
  String get articlesWhatIsHivB1P0;

  /// No description provided for @articlesWhatIsHivB1P1.
  ///
  /// In ru, this message translates to:
  /// **'Процесс инфицирования клетки проходит в 7 этапов:'**
  String get articlesWhatIsHivB1P1;

  /// No description provided for @articlesWhatIsHivB1Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Слияние: вирус цепляется за рецептор CD4.'**
  String get articlesWhatIsHivB1Bl0;

  /// No description provided for @articlesWhatIsHivB1Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Проникновение: вирная оболочка сливается с мембраной клетки.'**
  String get articlesWhatIsHivB1Bl1;

  /// No description provided for @articlesWhatIsHivB1Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Обратная транскрипция: вирус превращает свою РНК в ДНК.'**
  String get articlesWhatIsHivB1Bl2;

  /// No description provided for @articlesWhatIsHivB1Bl3.
  ///
  /// In ru, this message translates to:
  /// **'Интеграция: вирусная ДНК «вклеивается» в человеческую ДНК — клетка становится фабрикой по производству вируса.'**
  String get articlesWhatIsHivB1Bl3;

  /// No description provided for @articlesWhatIsHivB1Bl4.
  ///
  /// In ru, this message translates to:
  /// **'Репликация: клетка производит длинные цепи вирусных белков.'**
  String get articlesWhatIsHivB1Bl4;

  /// No description provided for @articlesWhatIsHivB1Bl5.
  ///
  /// In ru, this message translates to:
  /// **'Сборка: новые частицы вируса собираются у края клетки.'**
  String get articlesWhatIsHivB1Bl5;

  /// No description provided for @articlesWhatIsHivB1Bl6.
  ///
  /// In ru, this message translates to:
  /// **'Почкование: вирусы выходят наружу, разрывая клетку, и заражают новые лимфоциты.'**
  String get articlesWhatIsHivB1Bl6;

  /// No description provided for @articlesWhatIsHivB2Heading.
  ///
  /// In ru, this message translates to:
  /// **'3. Стадии развития ВИЧ-инфекции'**
  String get articlesWhatIsHivB2Heading;

  /// No description provided for @articlesWhatIsHivB2P0.
  ///
  /// In ru, this message translates to:
  /// **'Без лечения заболевание проходит через четыре стадии:'**
  String get articlesWhatIsHivB2P0;

  /// No description provided for @articlesWhatIsHivB2Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Стадия I (острая инфекция, 2–4 недели): симптомы напоминают грипп. Человек наиболее заразен, уровень вируса максимален.'**
  String get articlesWhatIsHivB2Bl0;

  /// No description provided for @articlesWhatIsHivB2Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Стадия II (бессимптомный период, 2–15 лет): вирус размножается, иммунная система сдерживает его.'**
  String get articlesWhatIsHivB2Bl1;

  /// No description provided for @articlesWhatIsHivB2Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Стадия III (пре-СПИД): грибковые поражения, диарея, потеря веса, лихорадка.'**
  String get articlesWhatIsHivB2Bl2;

  /// No description provided for @articlesWhatIsHivB2Bl3.
  ///
  /// In ru, this message translates to:
  /// **'Стадия IV (СПИД): CD4-клеток менее 200 ед. Оппортунистические инфекции — пневмония, саркома Капоши, туберкулёз.'**
  String get articlesWhatIsHivB2Bl3;

  /// No description provided for @articlesWhatIsHivB3Heading.
  ///
  /// In ru, this message translates to:
  /// **'4. Типы вируса: ВИЧ-1 и ВИЧ-2'**
  String get articlesWhatIsHivB3Heading;

  /// No description provided for @articlesWhatIsHivB3Bl0.
  ///
  /// In ru, this message translates to:
  /// **'ВИЧ-1: самый распространённый тип (~95% случаев). Более агрессивен, быстрее прогрессирует.'**
  String get articlesWhatIsHivB3Bl0;

  /// No description provided for @articlesWhatIsHivB3Bl1.
  ///
  /// In ru, this message translates to:
  /// **'ВИЧ-2: встречается в основном в Западной Африке. Менее заразен, прогрессирует медленнее.'**
  String get articlesWhatIsHivB3Bl1;

  /// No description provided for @articlesWhatIsHivB4Heading.
  ///
  /// In ru, this message translates to:
  /// **'5. Лабораторные показатели'**
  String get articlesWhatIsHivB4Heading;

  /// No description provided for @articlesWhatIsHivB4Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Вирусная нагрузка (ВН): количество копий РНК вируса в 1 мл плазмы. Цель лечения — менее 50 копий («неопределяемая»).'**
  String get articlesWhatIsHivB4Bl0;

  /// No description provided for @articlesWhatIsHivB4Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Иммунный статус (CD4): количество Т-лимфоцитов в 1 мл крови. Цель — удерживать выше 500 единиц.'**
  String get articlesWhatIsHivB4Bl1;

  /// No description provided for @articlesWhatIsHivB5Heading.
  ///
  /// In ru, this message translates to:
  /// **'6. Почему вирус невозможно победить полностью?'**
  String get articlesWhatIsHivB5Heading;

  /// No description provided for @articlesWhatIsHivB5P0.
  ///
  /// In ru, this message translates to:
  /// **'Главная проблема — латентные резервуары. ВИЧ встраивается в ДНК «спящих» клеток. Современные препараты (АРТ) убивают активный вирус в крови, но не могут достать его из спящих клеток. Если прекратить терапию, вирус из резервуаров снова начнёт копировать себя.'**
  String get articlesWhatIsHivB5P0;

  /// No description provided for @articlesMythsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мифы и реальность'**
  String get articlesMythsTitle;

  /// No description provided for @articlesMythsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Разрушаем стигму: бытовые, медицинские и социальные заблуждения о ВИЧ.'**
  String get articlesMythsSubtitle;

  /// No description provided for @articlesMythsB0Heading.
  ///
  /// In ru, this message translates to:
  /// **'1. Бытовые мифы'**
  String get articlesMythsB0Heading;

  /// No description provided for @articlesMythsB0Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «ВИЧ передаётся через поцелуи и слюну».\nРеальность: концентрация вируса в слюне ничтожно мала. Заражение через слюну физически невозможно.'**
  String get articlesMythsB0Bl0;

  /// No description provided for @articlesMythsB0Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «Опасно пользоваться общим туалетом или посудой».\nРеальность: ВИЧ не передаётся через пот, слёзы, мочу или кожные контакты. Он гибнет при высыхании.'**
  String get articlesMythsB0Bl1;

  /// No description provided for @articlesMythsB0Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «Комары переносят ВИЧ».\nРеальность: комар впрыскивает слюну, а не кровь предыдущей жертвы. Вирус не размножается в организме насекомого.'**
  String get articlesMythsB0Bl2;

  /// No description provided for @articlesMythsB1Heading.
  ///
  /// In ru, this message translates to:
  /// **'2. Медицинские мифы'**
  String get articlesMythsB1Heading;

  /// No description provided for @articlesMythsB1Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «ВИЧ-диссидентство — вируса не существует».\nРеальность: ВИЧ — один из самых изученных вирусов. Отрицание вируса смертельно опасно.'**
  String get articlesMythsB1Bl0;

  /// No description provided for @articlesMythsB1Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «Если выглядишь здоровым — ВИЧ нет».\nРеальность: бессимптомный период может длиться 10+ лет.'**
  String get articlesMythsB1Bl1;

  /// No description provided for @articlesMythsB1Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «АРТ — это яд».\nРеальность: современные препараты имеют минимум побочных эффектов и позволяют дожить до естественной старости.'**
  String get articlesMythsB1Bl2;

  /// No description provided for @articlesMythsB2Heading.
  ///
  /// In ru, this message translates to:
  /// **'3. Социальные мифы'**
  String get articlesMythsB2Heading;

  /// No description provided for @articlesMythsB2Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «ВИЧ болеют только наркопотребители».\nРеальность: более 70% новых случаев — при обычных гетеросексуальных контактах.'**
  String get articlesMythsB2Bl0;

  /// No description provided for @articlesMythsB2Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «ВИЧ-положительные опасны для общества».\nРеальность: принцип Н=Н — человек на терапии не передаёт вирус партнёру.'**
  String get articlesMythsB2Bl1;

  /// No description provided for @articlesMythsB3Heading.
  ///
  /// In ru, this message translates to:
  /// **'4. Мифы о репродукции'**
  String get articlesMythsB3Heading;

  /// No description provided for @articlesMythsB3Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «У ВИЧ-положительной матери обязательно родится больной ребёнок».\nРеальность: при приёме терапии во время беременности риск снижается до менее 1%.'**
  String get articlesMythsB3Bl0;

  /// No description provided for @articlesMythsB3Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Миф: «ВИЧ передаётся по наследству».\nРеальность: ВИЧ — инфекция, а не генетическое заболевание.'**
  String get articlesMythsB3Bl1;

  /// No description provided for @articlesMythsB4Heading.
  ///
  /// In ru, this message translates to:
  /// **'5. Почему стигма убивает?'**
  String get articlesMythsB4Heading;

  /// No description provided for @articlesMythsB4P0.
  ///
  /// In ru, this message translates to:
  /// **'Стигма работает как барьер на трёх уровнях:'**
  String get articlesMythsB4P0;

  /// No description provided for @articlesMythsB4Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Психологический: человек боится сдавать тест — «положительный результат = социальная смерть».'**
  String get articlesMythsB4Bl0;

  /// No description provided for @articlesMythsB4Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Скрытая эпидемия: люди, не знающие своего статуса из-за страха, продолжают передавать вирус.'**
  String get articlesMythsB4Bl1;

  /// No description provided for @articlesMythsB4Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Самостигматизация: человек начинает считать себя «второсортным», что приводит к депрессии.'**
  String get articlesMythsB4Bl2;

  /// No description provided for @articlesMythsB5Heading.
  ///
  /// In ru, this message translates to:
  /// **'6. Как поддержать человека, открывшего вам свой статус?'**
  String get articlesMythsB5Heading;

  /// No description provided for @articlesMythsB5Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Не паникуйте — вы не заразитесь через объятия или общую кружку.'**
  String get articlesMythsB5Bl0;

  /// No description provided for @articlesMythsB5Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Спросите: «Как я могу тебя поддержать?» вместо советов.'**
  String get articlesMythsB5Bl1;

  /// No description provided for @articlesMythsB5Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Соблюдайте конфиденциальность — разглашение чужого диагноза без согласия незаконно.'**
  String get articlesMythsB5Bl2;

  /// No description provided for @articlesRecommendationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тестирование и защита'**
  String get articlesRecommendationsTitle;

  /// No description provided for @articlesRecommendationsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Стратегии профилактики, виды тестов и что делать при положительном результате.'**
  String get articlesRecommendationsSubtitle;

  /// No description provided for @articlesRecommendationsB0Heading.
  ///
  /// In ru, this message translates to:
  /// **'1. Стратегии профилактики'**
  String get articlesRecommendationsB0Heading;

  /// No description provided for @articlesRecommendationsB0Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Презервативы: ~98% эффективности. Используйте смазки только на водной или силиконовой основе.'**
  String get articlesRecommendationsB0Bl0;

  /// No description provided for @articlesRecommendationsB0Bl1.
  ///
  /// In ru, this message translates to:
  /// **'ДКП (PrEP): ежедневный приём препаратов снижает риск заражения более чем на 99%.'**
  String get articlesRecommendationsB0Bl1;

  /// No description provided for @articlesRecommendationsB0Bl2.
  ///
  /// In ru, this message translates to:
  /// **'ПКП (PEP): экстренная мера. Правило 72 часов — начать приём нужно как можно раньше. Курс — 28 дней.'**
  String get articlesRecommendationsB0Bl2;

  /// No description provided for @articlesRecommendationsB1Heading.
  ///
  /// In ru, this message translates to:
  /// **'2. Тестирование'**
  String get articlesRecommendationsB1Heading;

  /// No description provided for @articlesRecommendationsB1P0.
  ///
  /// In ru, this message translates to:
  /// **'Тест на ВИЧ — единственная возможность узнать статус. Симптомы слишком неспецифичны, чтобы на них полагаться.'**
  String get articlesRecommendationsB1P0;

  /// No description provided for @articlesRecommendationsB1Bl0.
  ///
  /// In ru, this message translates to:
  /// **'ИФА 4-го поколения (кровь из вены): самый точный. Ищет и антитела, и антиген p24.'**
  String get articlesRecommendationsB1Bl0;

  /// No description provided for @articlesRecommendationsB1Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Экспресс-тест (кровь из пальца или слюна): результат за 15–20 минут. Подходит для самотестирования.'**
  String get articlesRecommendationsB1Bl1;

  /// No description provided for @articlesRecommendationsB1Bl2.
  ///
  /// In ru, this message translates to:
  /// **'ПЦР: ищет РНК вируса. Определяет ВИЧ уже через 10–14 дней после контакта.'**
  String get articlesRecommendationsB1Bl2;

  /// No description provided for @articlesRecommendationsB2Heading.
  ///
  /// In ru, this message translates to:
  /// **'Период окна'**
  String get articlesRecommendationsB2Heading;

  /// No description provided for @articlesRecommendationsB2P0.
  ///
  /// In ru, this message translates to:
  /// **'Для тестов 4-го поколения — в среднем 2–4 недели. Для полной уверенности повторите тест через 3 месяца.'**
  String get articlesRecommendationsB2P0;

  /// No description provided for @articlesRecommendationsB3Heading.
  ///
  /// In ru, this message translates to:
  /// **'3. Положительный результат: что делать?'**
  String get articlesRecommendationsB3Heading;

  /// No description provided for @articlesRecommendationsB3P0.
  ///
  /// In ru, this message translates to:
  /// **'Положительный экспресс-тест — это ещё не окончательный диагноз. Это повод для дообследования.'**
  String get articlesRecommendationsB3P0;

  /// No description provided for @articlesRecommendationsB3Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждающий тест: иммунный блоттинг исключает ложноположительный результат.'**
  String get articlesRecommendationsB3Bl0;

  /// No description provided for @articlesRecommendationsB3Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Визит в Центр СПИДа: встать на учёт можно анонимно или конфиденциально.'**
  String get articlesRecommendationsB3Bl1;

  /// No description provided for @articlesRecommendationsB3Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Обследование: врач проверит иммунный статус, вирусную нагрузку, состояние печени и почек.'**
  String get articlesRecommendationsB3Bl2;

  /// No description provided for @articlesRecommendationsB3Bl3.
  ///
  /// In ru, this message translates to:
  /// **'Начало АРТ: принцип «Лечить всех» — таблетки выдаются сразу после диагноза.'**
  String get articlesRecommendationsB3Bl3;

  /// No description provided for @articlesRecommendationsB4Heading.
  ///
  /// In ru, this message translates to:
  /// **'4. Психологическая поддержка'**
  String get articlesRecommendationsB4Heading;

  /// No description provided for @articlesRecommendationsB4Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Равное консультирование: общение с людьми, живущими с ВИЧ. Помогут принять диагноз.'**
  String get articlesRecommendationsB4Bl0;

  /// No description provided for @articlesRecommendationsB4Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Группы взаимопомощи: поддержка без осуждения.'**
  String get articlesRecommendationsB4Bl1;

  /// No description provided for @articlesRecommendationsB4Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Юридическая помощь: дискриминация по диагнозу незаконна.'**
  String get articlesRecommendationsB4Bl2;

  /// No description provided for @articlesRecommendationsB5Heading.
  ///
  /// In ru, this message translates to:
  /// **'5. Образ жизни'**
  String get articlesRecommendationsB5Heading;

  /// No description provided for @articlesRecommendationsB5Bl0.
  ///
  /// In ru, this message translates to:
  /// **'Приверженность лечению: таблетки пить в одно и то же время. Пропуски ведут к резистентности.'**
  String get articlesRecommendationsB5Bl0;

  /// No description provided for @articlesRecommendationsB5Bl1.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинация: прививки от гриппа, пневмококка и гепатитов.'**
  String get articlesRecommendationsB5Bl1;

  /// No description provided for @articlesRecommendationsB5Bl2.
  ///
  /// In ru, this message translates to:
  /// **'Регулярные чекапы: анализы на вирусную нагрузку раз в 3–6 месяцев.'**
  String get articlesRecommendationsB5Bl2;
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

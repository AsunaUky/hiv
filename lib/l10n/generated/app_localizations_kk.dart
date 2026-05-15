// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get navMap => 'Карта';

  @override
  String get navTest => 'Тест';

  @override
  String get navInfo => 'Ақпарат';

  @override
  String get navProfile => 'Профиль';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileEdit => 'Профильді өзгерту';

  @override
  String get profileSignOut => 'Шығу';

  @override
  String get profileDeleteAccount => 'Аккаунтты жою';

  @override
  String get profileLanguage => 'Тіл';

  @override
  String get profileAccount => 'Аккаунт';

  @override
  String get profileGuest => 'Қонақ';

  @override
  String get profileGuestSubtitle =>
      'Барлық мүмкіндіктерді ашу үшін тіркеліңіз';

  @override
  String get authSignIn => 'Кіру';

  @override
  String get authRegister => 'Тіркелу';

  @override
  String get authCancel => 'Болдырмау';

  @override
  String get authConfirm => 'Растау';

  @override
  String get authSignOutTitle => 'Шығу';

  @override
  String get authSignOutConfirm => 'Аккаунттан шыққыңыз келе ме?';

  @override
  String get authDeleteTitle => 'Аккаунтты жою';

  @override
  String get authDeleteWarning => 'Бұл әрекетті кері қайтару мүмкін емес.';

  @override
  String get authDeleteConfirmBtn => 'Жою';

  @override
  String get authReAuthRequired => 'Қайта кіру қажет. Шығып, қайта кіріңіз.';

  @override
  String get commonSave => 'Сақтау';

  @override
  String get commonError => 'Қате орын алды';

  @override
  String get commonLoading => 'Жүктелуде...';

  @override
  String get editTitle => 'Профильді өзгерту';

  @override
  String get editNoGalleryAccess => 'Галереяға рұқсат жоқ';

  @override
  String get editNameLabel => 'Есім';

  @override
  String get editNamePlaceholder => 'Есіміңіз';

  @override
  String get editChangePasswordLabel => 'Құпия сөзді өзгерту';

  @override
  String get editCurrentPassword => 'Ағымдағы құпия сөз';

  @override
  String get editNewPassword => 'Жаңа құпия сөз';

  @override
  String get editConfirmPassword => 'Жаңа құпия сөзді қайталаңыз';

  @override
  String get editSuccess => 'Профиль жаңартылды';

  @override
  String get editErrorSave => 'Сақтау қатесі. Қайталап көріңіз.';

  @override
  String get editWrongPassword => 'Ағымдағы құпия сөз қате';

  @override
  String get editWeakPassword => 'Құпия сөз тым қарапайым';

  @override
  String get editRecentLogin => 'Шығып, қайта кіріңіз';

  @override
  String get infoTitle => 'Ақпарат';

  @override
  String get validatorEnterEmail => 'Email енгізіңіз';

  @override
  String get validatorInvalidEmail => 'Email дұрыс емес';

  @override
  String get validatorEnterPassword => 'Құпиясөзді енгізіңіз';

  @override
  String get validatorMinPassword => 'Кемінде 8 таңба';

  @override
  String get validatorPasswordNeedsLetter => 'Кемінде бір әріп қосыңыз';

  @override
  String get validatorPasswordNeedsDigit => 'Кемінде бір сан қосыңыз';

  @override
  String get validatorRepeatPassword => 'Құпиясөзді қайталаңыз';

  @override
  String get validatorPasswordMismatch => 'Құпиясөздер сәйкес келмейді';

  @override
  String get validatorEnterName => 'Атыңызды енгізіңіз';

  @override
  String get validatorNameTooShort => 'Аты тым қысқа';

  @override
  String get validatorNameTooLong => '20 таңбадан аспауы керек';

  @override
  String get validatorNameNoDigits => 'Атта сандар болмауы керек';

  @override
  String get validatorNameInvalidChars => 'Атта жарамсыз таңбалар бар';

  @override
  String get testTitle => 'Тәуекел бағалау тесті';

  @override
  String get testDescription =>
      '10 сұраққа жауап беріңіз — жүйе тәуекел деңгейін бағалап, жеке ұсыныс береді.';

  @override
  String get testPrivacyNote =>
      'Барлық жауаптар анонимді және құпия. Деректер сақталмайды.';

  @override
  String get testStartButton => 'Тест тапсыру';

  @override
  String get testFinishButton => 'Тестті аяқтау';

  @override
  String get testAllQuestionsAnswered => 'Барлық сұрақтарға жауап берілді!';

  @override
  String testHistoryTitle(int count) {
    return 'Өту тарихы ($count)';
  }

  @override
  String get testResultRetry => 'Қайта тапсыру';

  @override
  String get testRiskHigh => 'Жоғары қауіп';

  @override
  String get testRiskModerate => 'Орташа қауіп';

  @override
  String get testRiskMinimal => 'Төмен қауіп';

  @override
  String get mapTitle => 'Сенім пункттері';

  @override
  String get mapFindMe => 'Мені табу';

  @override
  String get mapLocationError => 'Орналасқан жерді анықтау мүмкін болмады';

  @override
  String get mapRouteButton => 'Бағыт құру';

  @override
  String get mapHoursLabel => 'Жұмыс уақыты';

  @override
  String get mapServicesLabel => 'Қызметтер тізімі';

  @override
  String get mapLegendPolyclinic => 'Емхана';

  @override
  String get mapLegendDerma => 'Тері-вен. диспансер';

  @override
  String get mapLegendAids => 'ЖИТС орталығы';

  @override
  String get close => 'Жабу';

  @override
  String get retry => 'Қайталау';

  @override
  String get mapLocationGpsOff => 'Құрылғыда GPS-ті қосыңыз';

  @override
  String get authErrorUserNotFound =>
      'Мұндай email-і бар аккаунт табылмады. Деректерді тексеріңіз немесе тіркеліңіз.';

  @override
  String get authErrorWrongPassword =>
      'Құпия сөз қате. Қайтадан байқап көріңіз.';

  @override
  String get authErrorInvalidEmail => 'Email форматы қате.';

  @override
  String get authErrorUserDisabled =>
      'Бұл аккаунт бұғатталған. Қолдау көрсету қызметіне хабарласыңыз.';

  @override
  String get authErrorTooManyRequests =>
      'Әрекет саны тым көп. Сәлден кейін қайта байқап көріңіз.';

  @override
  String get authErrorNetworkFailed => 'Интернет байланысы жоқ.';

  @override
  String get authErrorEmailInUse =>
      'Мұндай email-і бар аккаунт тіркелген. Жүйеге кіруге тырысыңыз.';

  @override
  String get authErrorWeakPassword =>
      'Құпия сөз тым оңай. Кемінде 6 таңбадан тұратын құпия сөз қолданыңыз.';

  @override
  String get authErrorDefault => 'Жүйеге кіру қатесі. Қайтадан байқап көріңіз.';

  @override
  String get authRegisterErrorDefault =>
      'Тіркелу қатесі. Қайтадан байқап көріңіз.';

  @override
  String get authSessionExpired =>
      'Сессия ескірді. Жүйеден шығып, қайта кіріңіз, содан кейін жоюды қайталаңыз.';

  @override
  String get authGoogleCanceled => 'Google арқылы растау тоқтатылды.';

  @override
  String get authStatusLoggedOut => 'Пайдаланушы жүйеден шықты';

  @override
  String get authStatusAccountDeleted => 'Аккаунт тікелей жойылды';

  @override
  String get authStatusAccountDeletedGoogle =>
      'Аккаунт жойылды (Google арқылы)';

  @override
  String get authStatusError => 'Қате';

  @override
  String get authStatusWarningReauth => 'Қайта авторизациядан өту қажет';
}

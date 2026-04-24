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
}

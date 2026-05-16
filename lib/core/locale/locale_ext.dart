import 'package:flutter/widgets.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}

extension AuthErrorTranslation on AppLocalizations {
  /// в локализованную строку. Вся логика перевода живёт в ARB-файлах.
  String authErrorFromCode(String code) => switch (code) {
    'user-not-found'         => authErrorUserNotFound,
    'invalid-credential'     => authErrorUserNotFound,
    'wrong-password'         => authErrorWrongPassword,
    'invalid-email'          => authErrorInvalidEmail,
    'user-disabled'          => authErrorUserDisabled,
    'too-many-requests'      => authErrorTooManyRequests,
    'network-request-failed' => authErrorNetworkFailed,
    'email-already-in-use'   => authErrorEmailInUse,
    'weak-password'          => authErrorWeakPassword,
    'auth-session-expired'   => authSessionExpired,
    'google-sign-in-cancelled' => authGoogleCanceled,
    _                        => authErrorDefault,
  };
}

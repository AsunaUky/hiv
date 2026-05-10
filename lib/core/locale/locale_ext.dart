import 'package:flutter/widgets.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}
import 'package:flutter/widgets.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

// это по сути можно и удалить, но мб я не буду пользоваться l10n напрямую, 
//а буду юзать этот экстеншн, чтобы не писать `AppLocalizations.of(context)` везде, а просто `context.locale`

extension LocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}
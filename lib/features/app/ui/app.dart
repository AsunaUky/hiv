import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/core/theme/app_theme.dart';
import 'package:hiv/data/repositories/auth_repository.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

/// Корневой виджет приложения.
///
/// Оборачивает всё в:
/// 1. [BlocProvider] — предоставляет [AppBloc] всем виджетам ниже.
/// 2. [MaterialApp.router] — настраивает тему, роутер и локализацию.
///
/// Локализация подключена через стандартный механизм Flutter (intl + .arb).
/// Сгенерированный класс [AppLocalizations] содержит:
/// - [AppLocalizations.localizationsDelegates] — список всех делегатов,
///   включая наш и встроенные (Material, Cupertino, Widgets).
/// - [AppLocalizations.supportedLocales] — список поддерживаемых языков,
///   который автоматически берётся из .arb файлов.
class HivApp extends StatelessWidget {
  const HivApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.create();

    return BlocProvider(
      create: (_) => AppBloc(authRepository: AuthRepository.instance),

      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}

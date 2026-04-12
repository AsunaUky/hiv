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
/// StatefulWidget вместо StatelessWidget — чтобы [GoRouter] создавался
/// ровно один раз в [State], а не при каждом вызове [build].
/// Иначе смена локали (easy_localization → setState) пересоздаёт роутер
/// и сбрасывает навигацию на [initialLocation].
class HivApp extends StatefulWidget {
  const HivApp({super.key});

  @override
  State<HivApp> createState() => _HivAppState();
}

class _HivAppState extends State<HivApp> {
  // FIX: создаётся один раз — не зависит от rebuild'а
  late final _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(authRepository: AuthRepository.instance),
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
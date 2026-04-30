import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiv/core/locale/locale_cubit.dart';
import 'package:hiv/core/theme/app_theme.dart';
import 'package:hiv/domain/repositories/auth_repository.dart';
import 'package:hiv/features/app/bloc/app_bloc.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

class HivApp extends StatefulWidget {
  const HivApp({super.key});

  @override
  State<HivApp> createState() => _HivAppState();
}

class _HivAppState extends State<HivApp> {
  late final _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc(authRepository: AuthRepository.instance)),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
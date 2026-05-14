import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';
import 'package:hiv/data/datasources/test_remote_datasource.dart';
import 'package:hiv/data/datasources/trust_points_datasource.dart';
import 'package:hiv/data/repositories/test_repository_impl.dart';
import 'package:hiv/data/repositories/trust_point_repository_impl.dart';
import 'package:hiv/features/map/bloc/trust_points_cubit.dart';
import 'package:hiv/features/test/bloc/test_cubit.dart';
import 'package:hiv/l10n/generated/app_localizations.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    RouteNames.main,
    RouteNames.test,
    RouteNames.info,
    RouteNames.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = _currentIndex(context);

    return MultiBlocProvider(
      providers: [
        // TrustPointsCubit живёт на уровне Shell — создаётся один раз
        // при монтировании HomeShell и переживает переключения между табами.
        // Кэш в TrustPointRepositoryImpl сохраняется, повторных сетевых
        // запросов при смене таба нет.
        BlocProvider<TrustPointsCubit>(
          create: (_) => TrustPointsCubit(
            TrustPointRepositoryImpl(
              TrustPointsRemoteDataSource(FirebaseFirestore.instance),
            ),
          ),
        ),
        BlocProvider<TestCubit>(
          create: (ctx) {
            return TestCubit(
              TestRepositoryImpl(
                TestRemoteDataSource(FirebaseFirestore.instance),
              ),
            ); // ..load(locale);
          },
        ),
      ],
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => context.go(_tabs[i]),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          backgroundColor: AppColors.surface,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              activeIcon: const Icon(Icons.map_rounded),
              label: l10n.navMap,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.quiz_outlined),
              activeIcon: const Icon(Icons.quiz_rounded),
              label: l10n.navTest,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info_outline_rounded),
              activeIcon: const Icon(Icons.info_rounded),
              label: l10n.navInfo,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';

/// Оболочка с нижней навигацией для всех вкладок приложения.
///
/// FIX [P2-01]: Индекс таба теперь вычисляется из текущего маршрута,
/// а не хранится в [State]. Это предотвращает сброс на первую вкладку
/// при смене локали (easy_localization вызывает rebuild всего дерева,
/// но маршрут при этом не меняется).
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  // Соответствие: индекс таба → путь маршрута.
  static const _tabs = [
    RouteNames.main,
    RouteNames.test,
    RouteNames.info,
    RouteNames.profile,
  ];

  /// Вычисляем активный таб из текущего пути — не из состояния.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    // go() — не push(), чтобы не накапливать историю вкладок.
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: AppColors.surface,
        elevation: 8,
        // FIX [P1-01]: метки теперь через tr(), не хардкод.
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map_rounded),
            label: tr('nav.map'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.quiz_outlined),
            activeIcon: const Icon(Icons.quiz_rounded),
            label: tr('nav.test'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline_rounded),
            activeIcon: const Icon(Icons.info_rounded),
            label: tr('nav.info'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: tr('nav.profile'),
          ),
        ],
      ),
    );
  }
}
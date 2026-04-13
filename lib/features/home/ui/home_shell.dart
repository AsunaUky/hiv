import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';

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
    // Localizations.localeOf() — настоящий InheritedWidget lookup.
    // context.locale (easy_localization) использует findAncestorStateOfType
    // и зависимости НЕ создаёт — виджет не перестраивается при смене языка.
    // ignore: unused_local_variable
    final _ = Localizations.localeOf(context);

    final currentIndex = _currentIndex(context);

    return Scaffold(
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
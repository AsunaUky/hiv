import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';
import 'package:hiv/core/theme/app_colors.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (i) => switch (i) {
          0 => context.go(RouteNames.main),
          1 => context.go(RouteNames.test),
          2 => context.go(RouteNames.info),
          _ => context.go(RouteNames.profile),
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed, // нужен при 4+ вкладках
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined),       label: 'Карта'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined),      label: 'Тест'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline),       label: 'Информация'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined),    label: 'Профиль'),
        ],
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(RouteNames.test))    return 1;
    if (location.startsWith(RouteNames.info))    return 2;
    if (location.startsWith(RouteNames.profile)) return 3;
    return 0;
  }
}
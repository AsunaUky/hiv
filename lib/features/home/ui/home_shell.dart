import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/core/router/route_names.dart';

// TODO-комментарий в коде для обозначения задач, которые нужно реализовать или доделать позже
// TODO: заменить на полноценный HomeShell с BottomNavigationBar
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (i) => i == 0
            ? context.go(RouteNames.main)
            : context.go(RouteNames.profile),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),    label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined),  label: 'Профиль'),
        ],
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(RouteNames.profile)) return 1;
    return 0;
  }
}
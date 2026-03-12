import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/ui/splash_screen.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/login/ui/register_screen.dart';
import '../../features/home/ui/home_shell.dart';
import '../../features/home/ui/main_tab.dart';
import '../../features/home/ui/profile_tab.dart';
// import '../../features/test/ui/test_screen.dart';
// import '../../features/test/ui/test_result_screen.dart';
// import '../../features/info/ui/article_screen.dart';
// import '../../features/profile/ui/edit_profile_screen.dart';
import 'route_names.dart';

/// Конфигурация навигации (GoRouter).
///
/// Структура маршрутов:
/// ```
/// /                → SplashScreen
/// /login           → LoginScreen
/// /register        → RegisterScreen
/// /home/main       → MainTab      ┐ внутри HomeShell
/// /home/profile    → ProfileTab   ┘ (ShellRoute + BottomNav)
/// /test            → TestScreen
/// /test-result     → TestResultScreen
/// /info/article    → ArticleScreen
/// /edit-profile    → EditProfileScreen
/// ```
class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: RouteNames.splash,
      routes: [

        // Splash
        GoRoute(
          name: RouteNames.splashName,
          path: RouteNames.splash,
          builder: (_, _) => const SplashScreen(),
        ),

        // Вход/регистрация
        GoRoute(
          name: RouteNames.loginName,
          path: RouteNames.login,
          builder: (_, _) => const LoginScreen(),
        ),
        GoRoute(
          name: RouteNames.registerName,
          path: RouteNames.register,
          builder: (_, _) => const RegisterScreen(),
        ),

        // Home (ShellRoute + BottomNav) 
        ShellRoute(
          builder: (_, _, child) => HomeShell(child: child),
          routes: [
            GoRoute(
              name: RouteNames.mainName,
              path: RouteNames.main,
              builder: (_, _) => const MainTab(),
            ),
            GoRoute(
              name: RouteNames.profileName,
              path: RouteNames.profile,
              builder: (_, _) => const ProfileTab(),
            ),
          ],
        ),

        // Тест 
        // GoRoute(
        //   name: RouteNames.testName,
        //   path: RouteNames.test,
        //   builder: (_, _) => const TestScreen(),
        // ),
        // GoRoute(
        //   name: RouteNames.testResultName,
        //   path: RouteNames.testResult,
        //   builder: (_, state) {
        //     final extra = state.extra as Map<String, dynamic>?;
        //     return TestResultScreen(
        //       score:           extra?['score']           as int?  ?? 0,
        //       total:           extra?['total']           as int?  ?? 0,
        //       riskLevel:       extra?['riskLevel'],
        //       recommendations: (extra?['recommendations'] as List?)
        //               ?.cast<String>() ?? const [],
        //     );
        //   },
        // ),

        // Статья
        // GoRoute(
        //   name: RouteNames.infoArticleName,
        //   path: RouteNames.infoArticle,
        //   builder: (_, state) {
        //     final extra = state.extra as Map<String, dynamic>?;
        //     return ArticleScreen(
        //       title:   extra?['title']   as String? ?? '',
        //       content: extra?['content'] as String? ?? '',
        //     );
        //   },
        // ),

        // Редактирование профиля 
        // GoRoute(
        //   name: RouteNames.editProfileName,
        //   path: RouteNames.editProfile,
        //   builder: (_, _) => const EditProfileScreen(),
        // ),

      ],

      // 404 
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(
            'Страница не найдена: ${state.uri}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
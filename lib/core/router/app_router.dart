import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiv/features/map/map_screen.dart';
import 'package:hiv/features/home/ui/profile/edit/edit_profile_screen.dart';
import 'package:hiv/features/home/ui/profile/profile_tab.dart';
import 'package:hiv/features/test/bloc/test_cubit.dart';
import 'package:hiv/features/test/ui/test_result_screen.dart';
import 'package:hiv/features/test/ui/test_screen.dart';
import 'package:hiv/domain/entities/article_entity.dart';
import 'package:hiv/features/info/ui/info_article_screen.dart';
import 'package:hiv/features/info/ui/info_list_screen.dart';

import '../../features/splash/ui/splash_screen.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/login/ui/register_screen.dart';
import '../../features/home/ui/home_shell.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: RouteNames.splash,
      routes: [
        GoRoute(
          name: RouteNames.splashName,
          path: RouteNames.splash,
          builder: (_, _) => const SplashScreen(),
        ),
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

        ShellRoute(
          builder: (_, _, child) => HomeShell(child: child),
          routes: [
            GoRoute(
              name: RouteNames.mainName,
              path: RouteNames.main,
              builder: (_, _) => const MapScreen(),
            ),
            GoRoute(
              name: RouteNames.testName,
              path: RouteNames.test,
              builder: (_, _) => const TestScreen(),
            ),
            // Список статей — внутри Shell (BottomNav виден)
            GoRoute(
              name: RouteNames.infoName,
              path: RouteNames.info,
              builder: (_, _) => const InfoListScreen(),
            ),
            GoRoute(
              name: RouteNames.profileName,
              path: RouteNames.profile,
              builder: (_, _) => const ProfileTab(),
            ),
          ],
        ),

        GoRoute(
          name: RouteNames.testResultName,
          path: RouteNames.testResult,
          builder: (_, state) {
            final completed = state.extra as TestCompleted;
            return TestResultScreen(completed: completed);
          },
        ),

        // Статья — вне Shell (BottomNav скрыт), данные через extra
        GoRoute(
          name: RouteNames.infoArticleName,
          path: RouteNames.infoArticle,
          builder: (_, state) {
            final article = state.extra as ArticleEntity;
            return InfoArticleScreen(article: article);
          },
        ),

        GoRoute(
          name: RouteNames.editProfileName,
          path: RouteNames.editProfile,
          builder: (_, _) => const EditProfileScreen(),
        ),
      ],

      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(
            'Страница не найдена: \${state.uri}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

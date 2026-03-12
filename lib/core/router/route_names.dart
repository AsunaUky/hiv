/// Все маршруты приложения в одном месте.
abstract final class RouteNames {
  // ── Пути ──────────────────────────────────────────────────────
  static const splash      = '/';
  static const login       = '/login';
  static const register    = '/register';
  static const home        = '/home';
  static const main        = '/home/main';
  static const profile     = '/home/profile';
  static const test        = '/test';
  static const testResult  = '/test-result';
  static const infoArticle = '/info/article';
  static const editProfile = '/edit-profile';

  // ── Имена (для context.goNamed) ───────────────────────────────
  static const splashName      = 'splash';
  static const loginName       = 'login';
  static const registerName    = 'register';
  static const mainName        = 'main';
  static const profileName     = 'profile';
  static const testName        = 'test';
  static const testResultName  = 'testResult';
  static const infoArticleName = 'infoArticle';
  static const editProfileName = 'editProfile';
}
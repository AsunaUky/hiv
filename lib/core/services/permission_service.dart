import 'package:permission_handler/permission_handler.dart';
import 'package:hiv/core/utils/logger.dart';

/// Сервис запроса разрешений при старте приложения.
///
/// Вызывается один раз из [SplashScreen.initState] или из [main()]
/// после инициализации Firebase.
class PermissionService {
  const PermissionService._();

  /// Запрашивает разрешение на геолокацию, необходимое для [MapScreen].
  ///
  /// Если пользователь уже отклонил навсегда — открывает настройки.
  /// Не бросает исключений: ошибки логируются и молча проглатываются,
  /// чтобы не блокировать запуск приложения.
  static Future<void> requestLocation() async {
    try {
      final status = await Permission.locationWhenInUse.status;

      if (status.isGranted) {
        AppLogger.info('PermissionService: геолокация уже разрешена');
        return;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning(
            'PermissionService: геолокация запрещена навсегда — открываем настройки');
        await openAppSettings();
        return;
      }

      final result = await Permission.locationWhenInUse.request();
      AppLogger.info('PermissionService: результат запроса геолокации — $result');
    } catch (e, s) {
      AppLogger.error(
        'PermissionService: ошибка запроса разрешения',
        error: e,
        stackTrace: s,
      );
    }
  }
}
import 'package:permission_handler/permission_handler.dart';
import 'package:hiv/core/utils/logger.dart';

/// Сервис запроса разрешений.
///
/// Вызывается один раз из [SplashScreen.initState].
class PermissionService {
  const PermissionService._();

  /// Запрашивает разрешение на геолокацию для [MapScreen].
  static Future<void> requestLocation() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) return;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }
      final result = await Permission.locationWhenInUse.request();
      AppLogger.info('PermissionService: геолокация -> $result');
    } catch (e, s) {
      AppLogger.error('PermissionService: ошибка геолокации', error: e, stackTrace: s);
    }
  }

  /// Запрашивает разрешение на доступ к галерее для выбора фото профиля.
  ///
  /// Android 13+ — [Permission.photos], старше — [Permission.storage].
  /// iOS — [Permission.photos].
  static Future<bool> requestGallery() async {
    try {
      final permission = Permission.photos;
      final status = await permission.status;

      if (status.isGranted || status.isLimited) {
        AppLogger.info('PermissionService: галерея уже разрешена');
        return true;
      }
      if (status.isPermanentlyDenied) {
        AppLogger.warning('PermissionService: галерея запрещена навсегда');
        await openAppSettings();
        return false;
      }

      final result = await permission.request();
      final granted = result.isGranted || result.isLimited;
      AppLogger.info('PermissionService: галерея -> $result');
      return granted;
    } catch (e, s) {
      AppLogger.error('PermissionService: ошибка галереи', error: e, stackTrace: s);
      return false;
    }
  }
}
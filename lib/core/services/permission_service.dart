import 'package:permission_handler/permission_handler.dart';
import 'package:hiv/core/utils/logger.dart';

/// Сервис запроса разрешений.
class PermissionService {
  const PermissionService._();

  // ── Геолокация ────────────────────────────────────────────────

  /// Запрашивает разрешение на геолокацию.
  /// Вызывать из SplashScreen.initState().
  static Future<void> requestLocation() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) return;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }
      final result = await Permission.locationWhenInUse.request();
      AppLogger.info('PermissionService: геолокация → $result');
    } catch (e, s) {
      AppLogger.error('PermissionService: ошибка геолокации', error: e, stackTrace: s);
    }
  }

  // ── Галерея ───────────────────────────────────────────────────

  /// Текущий статус доступа к галерее — без показа диалога.
  ///
  /// На Android 13+ image_picker использует системный Photo Picker
  /// и не требует явного пермишена. Поэтому мы проверяем только
  /// [isPermanentlyDenied] — только тогда нужно вести в настройки.
  static Future<PermissionStatus> galleryStatus() async {
    try {
      return await Permission.photos.status;
    } catch (_) {
      return PermissionStatus.granted; // если API недоступен — разрешаем
    }
  }

  /// Открывает системные настройки приложения.
  static Future<void> openSettings() => openAppSettings();
}
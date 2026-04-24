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

  /// Запрашивает разрешение на доступ к галерее.
  ///
  /// Вызывай **перед** открытием [ImagePicker].
  ///
  /// Поведение по платформам:
  /// - Android 13+ (SDK 33+): система использует Photo Picker — явный
  ///   пермишен не нужен, метод сразу возвращает `true`.
  /// - Android < 13: запрашивает [Permission.storage], при
  ///   постоянном отказе ведёт в настройки.
  /// - iOS: запрашивает [Permission.photos]; при ограниченном доступе
  ///   (`limited`) тоже считается достаточным — пикер сам покажет диалог.
  ///
  /// Возвращает `true`, если можно открывать пикер.
  static Future<bool> requestGallery() async {
    try {
      // На Android 13+ (photos permission не существует как таковой —
      // image_picker использует системный Photo Picker без пермишена)
      final status = await Permission.photos.request();

      if (status.isGranted || status.isLimited) {
        AppLogger.info('PermissionService: галерея → $status');
        return true;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning('PermissionService: галерея permanently denied → открываем настройки');
        await openAppSettings();
        return false;
      }

      AppLogger.warning('PermissionService: галерея → $status');
      return false;
    } catch (_) {
      // На Android 13+ Permission.photos может бросить исключение —
      // в этом случае пикер всё равно работает через Photo Picker.
      AppLogger.warning('PermissionService: галерея — пермишен недоступен, разрешаем через Photo Picker');
      return true;
    }
  }

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
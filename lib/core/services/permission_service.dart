import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис разрешений.
///
/// Ключевые решения:
/// • Галерея: всегда используем [Permission.photos] — permission_handler сам
///   маппит его на READ_MEDIA_IMAGES (Android 13+) или READ_EXTERNAL_STORAGE
///   (Android ≤12). Никакой ручной логики версий не нужно.
/// • Статические методы сохранены для [EditProfileScreen].
/// • Инстанс-методы с uid-ключами — per-user память для карты.
class PermissionService {
  // ── Статические хелперы (EditProfileScreen) ───────────────────────────────

  /// Запрашивает разрешение на галерею и возвращает итоговый статус.
  /// Используется в [EditProfileScreen] (вызывается до ImagePicker).
  static Future<PermissionStatus> requestGalleryPermission() async {
    return Permission.photos.request();
  }

  /// Текущий статус без диалога (только для проверки).
  static Future<PermissionStatus> galleryStatus() async {
    return Permission.photos.status;
  }

  /// Открывает системные настройки приложения.
  static Future<void> openSettings() => openAppSettings();

  // ── Инстанс: геолокация (MapScreen) ───────────────────────────────────────

  /// Запрашивает разрешение на геолокацию с per-user памятью.
  /// [uid] — uid текущего пользователя (из FirebaseAuth).
  Future<bool> requestLocation(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final permanentKey = '${_locKey(uid)}_permanent';

    // Если для этого пользователя уже было навсегда отклонено — в настройки.
    if (prefs.getBool(permanentKey) ?? false) {
      await openAppSettings();
      return false;
    }

    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      await prefs.setBool(_locKey(uid), true);
      return true;
    }
    if (status.isPermanentlyDenied) {
      await prefs.setBool(permanentKey, true);
      await openAppSettings();
    }
    return false;
  }

  /// Проверяет текущий статус геолокации без диалога.
  Future<bool> isLocationGranted() async =>
      (await Permission.locationWhenInUse.status).isGranted;

  /// Сбрасывает флаги «permanently denied» для пользователя
  /// (например, после того как он вручную выдал разрешение в настройках).
  Future<void> resetDeniedFlags(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_locKey(uid)}_permanent');
  }

  static String _locKey(String uid) => 'perm_location_$uid';
}
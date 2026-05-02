// lib/core/services/permission_service.dart

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис разрешений.
///
/// • Статические методы ([galleryStatus], [openSettings]) сохранены для
///   обратной совместимости с [EditProfileScreen].
/// • Инстанс-методы ([requestLocation], [requestGallery]) работают с per-user
///   памятью через SharedPreferences (ключ содержит uid).
class PermissionService {
  // ── Статические методы (EditProfileScreen) ────────────────────────────────

  /// Текущий статус разрешения галереи без запроса диалога.
  /// Используется в [EditProfileScreen].
  static Future<PermissionStatus> galleryStatus() async {
    final perm = await _resolveGalleryPermission();
    return perm.status;
  }

  /// Открывает системные настройки приложения.
  /// Используется в [EditProfileScreen].
  static Future<void> openSettings() => openAppSettings();

  // ── Инстанс: геолокация (MapScreen) ───────────────────────────────────────

  /// Запрашивает разрешение на геолокацию.
  ///
  /// [uid] — uid текущего пользователя. Запрос запоминается отдельно для
  /// каждого аккаунта, чтобы не пугать нового пользователя чужим «denied».
  /// Если было навсегда отклонено — открывает настройки. Возвращает `true`
  /// при успехе.
  Future<bool> requestLocation(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final permanentKey = '${_locKey(uid)}_permanent';

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

  // ── Инстанс: галерея (per-user, MapScreen / будущий EditProfile) ──────────

  /// Запрашивает разрешение на галерею с per-user памятью.
  Future<bool> requestGallery(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final permanentKey = '${_galKey(uid)}_permanent';

    if (prefs.getBool(permanentKey) ?? false) {
      await openAppSettings();
      return false;
    }

    final perm = await _resolveGalleryPermission();
    final status = await perm.request();

    if (status.isGranted || status.isLimited) {
      await prefs.setBool(_galKey(uid), true);
      return true;
    }
    if (status.isPermanentlyDenied) {
      await prefs.setBool(permanentKey, true);
      await openAppSettings();
    }
    return false;
  }

  /// Сбрасывает флаги «permanently denied» после ручной выдачи в настройках.
  Future<void> resetDeniedFlags(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_locKey(uid)}_permanent');
    await prefs.remove('${_galKey(uid)}_permanent');
  }

  // ── Приватные хелперы ──────────────────────────────────────────────────────

  static String _locKey(String uid) => 'perm_location_$uid';
  static String _galKey(String uid) => 'perm_gallery_$uid';

  /// Android 13+ и iOS: [Permission.photos].
  /// Android ≤12: [Permission.storage].
  static Future<Permission> _resolveGalleryPermission() async {
    // Если photos не в состоянии denied — платформа его поддерживает.
    final s = await Permission.photos.status;
    if (s != PermissionStatus.denied) return Permission.photos;
    if (await Permission.photos.shouldShowRequestRationale) {
      return Permission.photos;
    }
    return Permission.storage;
  }
}
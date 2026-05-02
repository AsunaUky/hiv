// lib/core/services/permission_service.dart

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис разрешений.
///
/// Зачем SharedPreferences поверх системных permission:
/// Система Android/iOS помнит разрешение на уровне приложения (не пользователя).
/// Если в приложении несколько аккаунтов — при смене пользователя мы хотим
/// показать наш объяснительный диалог (rationale) заново, а не опираться
/// на то, что система уже спросила другого пользователя.
///
/// Ключи: `perm_location_{uid}`, `perm_gallery_{uid}`.
class PermissionService {
  // ── Ключи SharedPreferences ────────────────────────────────────────────────

  static String _locationKey(String uid) => 'perm_location_$uid';
  static String _galleryKey(String uid) => 'perm_gallery_$uid';

  // ── Геолокация (запрашивается при нажатии «Найти меня») ───────────────────

  /// Запрашивает разрешение на геолокацию.
  ///
  /// Возвращает `true`, если разрешение получено.
  /// [uid] — id текущего пользователя (для per-user памяти).
  Future<bool> requestLocation(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    // Если для этого пользователя уже было навсегда отклонено — сразу в настройки.
    final wasPermanentlyDenied =
        prefs.getBool('${_locationKey(uid)}_permanent') ?? false;
    if (wasPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      await prefs.setBool(_locationKey(uid), true);
      return true;
    }

    if (status.isPermanentlyDenied) {
      await prefs.setBool('${_locationKey(uid)}_permanent', true);
      await openAppSettings();
    }

    return false;
  }

  /// Проверяет текущий статус без запроса диалога.
  Future<bool> isLocationGranted() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  // ── Галерея (запрашивается при смене аватарки) ────────────────────────────

  /// Запрашивает разрешение на доступ к галерее/фото.
  ///
  /// На Android 13+ использует [Permission.photos],
  /// на более ранних — [Permission.storage].
  Future<bool> requestGallery(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final wasPermanentlyDenied =
        prefs.getBool('${_galleryKey(uid)}_permanent') ?? false;
    if (wasPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    // Android 13+ / iOS используют photos, старый Android — storage.
    final permission = await _galleryPermission();
    final status = await permission.request();

    if (status.isGranted || status.isLimited) {
      await prefs.setBool(_galleryKey(uid), true);
      return true;
    }

    if (status.isPermanentlyDenied) {
      await prefs.setBool('${_galleryKey(uid)}_permanent', true);
      await openAppSettings();
    }

    return false;
  }

  Future<bool> isGalleryGranted() async {
    final permission = await _galleryPermission();
    final status = await permission.status;
    return status.isGranted || status.isLimited;
  }

  /// Сбрасывает флаги «permanently denied» для пользователя
  /// (например, после того как он вручную выдал разрешение в настройках).
  Future<void> resetDeniedFlags(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_locationKey(uid)}_permanent');
    await prefs.remove('${_galleryKey(uid)}_permanent');
  }

  // ---------------------------------------------------------------------------

  Future<Permission> _galleryPermission() async {
    // Permission.photos доступен на Android 13+ и iOS.
    // На Android 12 и ниже нужен Permission.storage.
    if (await Permission.photos.status != PermissionStatus.denied) {
      return Permission.photos;
    }
    return Permission.storage;
  }
}
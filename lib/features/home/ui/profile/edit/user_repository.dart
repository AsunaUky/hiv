import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hiv/core/utils/logger.dart';


/// Репозиторий для управления профилем пользователя.
class UserRepository {
  UserRepository._();
  static final UserRepository instance = UserRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get _user => _auth.currentUser;

  // ── Обновление имени ──────────────────────────────────────────

  Future<void> updateDisplayName(String name) async {
    try {
      await _user?.updateDisplayName(name.trim());
      await _user?.reload();
      AppLogger.info('UserRepository: имя обновлено');
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка обновления имени', error: e, stackTrace: s);
      rethrow;
    }
  }

  // ── Обновление фото ───────────────────────────────────────────

  Future<String> uploadPhoto(File file) async {
    try {
      final uid = _user!.uid;
      final ref = _storage.ref().child('avatars/$uid.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      await _user?.updatePhotoURL(url);
      await _user?.reload();
      AppLogger.info('UserRepository: фото обновлено');
      return url;
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка загрузки фото', error: e, stackTrace: s);
      rethrow;
    }
  }

  // ── Обновление email ──────────────────────────────────────────
  // Требует повторной аутентификации если сессия старая

  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      final user = _user!;
      // Повторная аутентификация
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail.trim());
      AppLogger.info('UserRepository: письмо подтверждения отправлено');
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка обновления email', error: e, stackTrace: s);
      rethrow;
    }
  }

  // ── Обновление пароля ─────────────────────────────────────────

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _user!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      AppLogger.info('UserRepository: пароль обновлён');
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка обновления пароля', error: e, stackTrace: s);
      rethrow;
    }
  }
}
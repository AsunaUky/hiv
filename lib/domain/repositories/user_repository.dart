import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiv/core/services/collection_names.dart';
import 'package:hiv/core/utils/logger.dart';


class UserRepository {
  UserRepository._();
  static final UserRepository instance = UserRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get _user => _auth.currentUser;

  DocumentReference<Map<String, dynamic>>? get _userDoc {
    final uid = _user?.uid;
    if (uid == null) return null;
    return _db.collection(CollectionNames.users).doc(uid);
  }

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

  // ── Обновление фото (только в Firestore) ──────────────────────

  /// Сохраняет фото как base64 в документе пользователя в Firestore.
  Future<String> uploadPhoto(File file) async {
    final doc = _userDoc;
    if (doc == null) throw StateError('UserRepository: пользователь не авторизован');

    try {
      final bytes = await file.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      await doc.set(
        {'photoUrl': base64Image},
        SetOptions(merge: true),
      );

      AppLogger.info('UserRepository: фото сохранено в Firestore');
      return base64Image;
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка загрузки фото', error: e, stackTrace: s);
      rethrow;
    }
  }

  // ── Обновление пароля ─────────────────────────────────────────

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _user;
      if (user == null) throw StateError('UserRepository: пользователь не авторизован');

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

  // ── Получение photoUrl из Firestore ───────────────────────────

  Future<String?> getPhotoUrl() async {
    try {
      final doc = await _userDoc?.get();
      return doc?.data()?['photoUrl'] as String?;
    } catch (e, s) {
      AppLogger.error('UserRepository: ошибка получения фото', error: e, stackTrace: s);
      return null;
    }
  }

  /// Стрим изменений профиля пользователя из Firestore.
  Stream<Map<String, dynamic>?> profileStream() {
    final doc = _userDoc;
    if (doc == null) return Stream.value(null);
    return doc.snapshots().map((snap) => snap.data());
  }
}
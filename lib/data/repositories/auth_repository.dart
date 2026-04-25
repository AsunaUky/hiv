import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiv/core/services/firebase_auth_service.dart';
import 'package:hiv/core/services/firestore_service.dart';
import 'package:hiv/data/models/user_model.dart';

import '../../core/utils/logger.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel get currentUser {
    final User? firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return UserModel.empty;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  bool get isLoggedIn => _authService.currentUser != null;

  Stream<UserModel> get userChanges {
    return _authService.userChanges.map((User? firebaseUser) {
      // ← userChanges
      if (firebaseUser == null) return UserModel.empty;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  // authStateChanges оставь как есть — он нужен для входа/выхода
  Stream<UserModel> get authStateChanges {
    return _authService.authStateChanges.map((User? firebaseUser) {
      if (firebaseUser == null) return UserModel.empty;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final UserCredential? credential = await _authService.signInWithGoogle();
      if (credential?.user == null) return UserModel.empty;

      final UserModel user = UserModel.fromFirebaseUser(credential!.user!);
      await _firestoreService.saveUser(user.uid, user.toJson());

      AppLogger.info('AuthRepository: вход — ${user.email}');
      return user;
    } catch (error, stackTrace) {
      AppLogger.error(
        'AuthRepository: ошибка входа',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Выход — делегируем в сервис (Firebase + Google).
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      AppLogger.info('AuthRepository: пользователь вышел');
    } catch (error, stackTrace) {
      AppLogger.error(
        'AuthRepository: ошибка выхода',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Удаление аккаунта — удаляем из Firebase Auth (и Google сессию).
  /// Бросает [FirebaseAuthException] с кодом requires-recent-login
  /// если нужна повторная аутентификация.
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      AppLogger.info('AuthRepository: аккаунт удалён');
    } catch (error, stackTrace) {
      AppLogger.error(
        'AuthRepository: ошибка удаления',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

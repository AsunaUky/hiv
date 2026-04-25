import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/logger.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Stream<User?> get userChanges => _auth.userChanges();

  // ── Email / Password ──────────────────────────────────────────

  /// Вход по email и паролю.
  ///
  /// Перехватывает [FirebaseAuthException] и пробрасывает
  /// [AuthException] с понятным текстом на русском языке.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.info('SignIn: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e, s) {
      AppLogger.error('SignIn: ошибка', error: e, stackTrace: s);
      throw AuthException(_mapSignInError(e.code));
    }
  }

  /// Маппинг кодов Firebase → понятные сообщения для пользователя.
  static String _mapSignInError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
        // invalid-credential = Firebase v10+ заменяет user-not-found
        // когда email не зарегистрирован
        return 'Аккаунт с таким email не найден. Проверьте данные или зарегистрируйтесь.';
      case 'wrong-password':
        return 'Неверный пароль. Попробуйте ещё раз.';
      case 'invalid-email':
        return 'Некорректный формат email.';
      case 'user-disabled':
        return 'Этот аккаунт заблокирован. Обратитесь в поддержку.';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже.';
      case 'network-request-failed':
        return 'Нет подключения к интернету.';
      default:
        return 'Ошибка входа. Попробуйте ещё раз.';
    }
  }

  /// Регистрация по email и паролю.
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.info('Register: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e, s) {
      AppLogger.error('Register: ошибка', error: e, stackTrace: s);
      throw AuthException(_mapRegisterError(e.code));
    }
  }

  static String _mapRegisterError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Аккаунт с таким email уже существует. Попробуйте войти.';
      case 'invalid-email':
        return 'Некорректный формат email.';
      case 'weak-password':
        return 'Пароль слишком простой. Используйте не менее 6 символов.';
      case 'network-request-failed':
        return 'Нет подключения к интернету.';
      default:
        return 'Ошибка регистрации. Попробуйте ещё раз.';
    }
  }

  Future<void> initialize({required String serverClientId}) async {
    if (_initialized) return;
    await _googleSignIn.initialize(serverClientId: serverClientId);
    _initialized = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final serverClientId = dotenv.env['SERVER_CLIENT_ID'];
    if (serverClientId == null) throw Exception('Server client is empty!');

    await initialize(serverClientId: serverClientId);

    // Сбрасываем предыдущую сессию Google ДО подписки на события,
    // иначе событие SignOut от disconnect() завершает completer раньше времени.
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}

    final completer = Completer<UserCredential?>();
    late final StreamSubscription<GoogleSignInAuthenticationEvent> subscription;

    // Подписываемся ПОСЛЕ disconnect — теперь не поймаем ложный SignOut.
    subscription = _googleSignIn.authenticationEvents.listen(
      (event) async {
        try {
          switch (event) {
            case GoogleSignInAuthenticationEventSignIn():
              final idToken = event.user.authentication.idToken;
              final credential = GoogleAuthProvider.credential(idToken: idToken);
              final userCredential =
                  await _auth.signInWithCredential(credential);
              AppLogger.info('Google Sign-In: ${userCredential.user?.email}');
              if (!completer.isCompleted) completer.complete(userCredential);

            case GoogleSignInAuthenticationEventSignOut():
              if (!completer.isCompleted) completer.complete(null);
          }
        } catch (error, stackTrace) {
          AppLogger.error(
            'Google Sign-In: ошибка',
            error: error,
            stackTrace: stackTrace,
          );
          if (!completer.isCompleted) completer.completeError(error);
        } finally {
          await subscription.cancel();
        }
      },
      onError: (Object error) {
        if (error is GoogleSignInException &&
            error.code == GoogleSignInExceptionCode.canceled) {
          if (!completer.isCompleted) completer.complete(null);
        } else {
          AppLogger.error('Google Sign-In: ошибка', error: error);
          if (!completer.isCompleted) completer.completeError(error);
        }
        subscription.cancel();
      },
    );

    _googleSignIn.authenticate();
    return completer.future;
  }

  /// Выход — сбрасываем Firebase и Google сессию.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut().catchError((_) {}),
      ]);
      AppLogger.info('Sign Out: пользователь вышел');
    } catch (error, stackTrace) {
      AppLogger.error('Sign Out: ошибка', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Удаление аккаунта.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _googleSignIn.signOut().catchError((_) {});
      await user.delete();
      AppLogger.info('Delete Account: аккаунт удалён');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Delete Account: ошибка', error: e);
      rethrow;
    }
  }
}

/// Исключение с человекочитаемым сообщением из [FirebaseAuthService].
///
/// Используй в AppBloc: `on AuthException catch (e) → emit(AuthFailure(e.message))`.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
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

  Future<void> initialize({required String serverClientId}) async {
    if (_initialized) return;
    await _googleSignIn.initialize(serverClientId: serverClientId);
    _initialized = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final serverClientId = dotenv.env['SERVER_CLIENT_ID'];
    if (serverClientId == null) throw Exception('Server client is empty!');

    await initialize(serverClientId: serverClientId);
    final completer = Completer<UserCredential?>();
    late final StreamSubscription<GoogleSignInAuthenticationEvent> subscription;

    subscription = _googleSignIn.authenticationEvents.listen(
      (event) async {
        try {
          switch (event) {
            case GoogleSignInAuthenticationEventSignIn():
              final idToken = event.user.authentication.idToken;
              final credential = GoogleAuthProvider.credential(idToken: idToken);
              final userCredential = await _auth.signInWithCredential(credential);
              AppLogger.info('Google Sign-In: ${userCredential.user?.email}');
              if (!completer.isCompleted) completer.complete(userCredential);

            case GoogleSignInAuthenticationEventSignOut():
              if (!completer.isCompleted) completer.complete(null);
          }
        } catch (error, stackTrace) {
          AppLogger.error('Google Sign-In: ошибка', error: error, stackTrace: stackTrace);
          if (!completer.isCompleted) completer.completeError(error);
        } finally {
          await subscription.cancel();
        }
      },
      onError: (Object error) {
        AppLogger.error('Google Sign-In: ошибка стрима', error: error);
        if (!completer.isCompleted) completer.completeError(error);
        subscription.cancel();
      },
    );

    _googleSignIn.authenticate();
    return completer.future;
  }

  /// Выход — сбрасываем и Firebase и Google сессию.
  Future<void> signOut() async {
    try {
      // Выходим из обоих параллельно; если Google не был активен — игнорируем
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

  /// Удаление аккаунта — сначала выходим из Google, затем удаляем Firebase-пользователя.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Выходим из Google перед удалением
      await _googleSignIn.signOut().catchError((_) {});
      await user.delete();
      AppLogger.info('Delete Account: аккаунт удалён');
    } on FirebaseAuthException catch (e) {
      // requires-recent-login — нужна повторная аутентификация
      AppLogger.error('Delete Account: ошибка', error: e);
      rethrow;
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required authRepository}) : super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGuestRequested>(_onGuest);
    on<AuthGoogleRequested>(_onGoogle);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final _auth = FirebaseAuth.instance;

  // Вход по email/пароль
  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapError(e.code)));
    }
  }

  // Регистрация
  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );
      await cred.user?.updateDisplayName(event.name.trim());
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapError(e.code)));
    }
  }

  // Гость
  Future<void> _onGuest(
    AuthGuestRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _auth.signInAnonymously();
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapError(e.code)));
    }
  }

  // Google (google_sign_in ^7.x)
  Future<void> _onGoogle(
  AuthGoogleRequested event,
  Emitter<AppState> emit,
) async {
  emit(const AuthLoading());
  try {
    final googleUser = await GoogleSignIn.instance.authenticate();

    // authentication — синхронный в v7
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    emit(const AuthSuccess());
  } on FirebaseAuthException catch (e) {
    emit(AuthFailure(_mapError(e.code)));
  } catch (_) {
    emit(const AuthInitial());
  }
}

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AppState> emit,
  ) async {
    await _auth.signOut();
    emit(const AuthInitial());
  }

  String _mapError(String code) => switch (code) {
        'user-not-found'         => 'Пользователь не найден',
        'wrong-password'         => 'Неверный пароль',
        'email-already-in-use'   => 'Email уже используется',
        'invalid-email'          => 'Некорректный email',
        'weak-password'          => 'Слишком простой пароль',
        'network-request-failed' => 'Нет подключения',
        _                        => 'Ошибка: $code', // ← покажет реальный код
      };
}
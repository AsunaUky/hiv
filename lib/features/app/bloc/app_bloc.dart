import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiv/data/repositories/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGuestRequested>(_onGuest);
    on<AuthGoogleRequested>(_onGoogle);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthDeleteRequested>(_onDelete);
  }

  final AuthRepository _authRepository;
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
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapError(e.code)));
    } catch (_) {
      emit(const AuthInitial());
    }
  }

  // Выход — через репозиторий (Firebase + Google)
  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (_) {
      // Даже если ошибка — всё равно сбрасываем состояние
    }
    emit(const AuthInitial());
  }

  // Удаление аккаунта — через репозиторий
  Future<void> _onDelete(
    AuthDeleteRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.deleteAccount();
      emit(const AuthInitial());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        emit(const AuthDeleteFailure(
          'Требуется повторный вход. Выйдите и войдите снова.',
        ));
      } else {
        emit(AuthFailure(_mapError(e.code)));
      }
    } catch (_) {
      emit(const AuthFailure('Не удалось удалить аккаунт. Попробуйте снова.'));
    }
  }

  String _mapError(String code) => switch (code) {
        'user-not-found'         => 'Пользователь не найден',
        'wrong-password'         => 'Неверный пароль',
        'email-already-in-use'   => 'Email уже используется',
        'invalid-email'          => 'Некорректный email',
        'weak-password'          => 'Слишком простой пароль',
        'network-request-failed' => 'Нет подключения',
        _                        => 'Ошибка: $code',
      };
}
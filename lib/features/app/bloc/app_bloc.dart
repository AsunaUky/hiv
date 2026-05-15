import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiv/core/services/firebase_auth_service.dart';
import 'package:hiv/domain/repositories/auth_repository.dart';

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
    } catch (_) {
      emit(const AuthFailure('Ошибка входа. Проверьте подключение и попробуйте снова.'));
    }
  }

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
    } catch (_) {
      emit(const AuthFailure('Ошибка регистрации. Проверьте подключение и попробуйте снова.'));
    }
  }

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
    } catch (_) {
      emit(const AuthFailure('Ошибка входа как гость. Попробуйте снова.'));
    }
  }

  Future<void> _onGoogle(
    AuthGoogleRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user.isEmpty) {
        emit(const AuthInitial());
      } else {
        emit(const AuthSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapError(e.code)));
    } catch (_) {
      emit(const AuthFailure('Ошибка входа через Google. Попробуйте снова.'));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (_) {}
    emit(const AuthInitial());
  }

  Future<void> _onDelete(
    AuthDeleteRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.deleteAccount();
      emit(const AuthInitial());
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        emit(const AuthDeleteFailure(
          'Сессия устарела. Выйдите и войдите снова, затем повторите удаление.',
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
        'invalid-credential'     => 'Неверный email или пароль',
        'email-already-in-use'   => 'Email уже используется',
        'invalid-email'          => 'Некорректный email',
        'weak-password'          => 'Слишком простой пароль',
        'network-request-failed' => 'Нет подключения к сети',
        'too-many-requests'      => 'Слишком много попыток. Попробуйте позже',
        'operation-not-allowed'  => 'Этот способ входа не включён',
        _                        => 'Ошибка: $code',
      };
}
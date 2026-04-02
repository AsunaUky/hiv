// ignore_for_file: always_use_package_imports
part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();
  @override
  List<Object> get props => [];
}

final class AuthInitial  extends AppState { const AuthInitial(); }
final class AuthLoading  extends AppState { const AuthLoading(); }
final class AuthSuccess  extends AppState { const AuthSuccess(); }

final class AuthFailure extends AppState {
  const AuthFailure(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

// Ошибка удаления — требуется повторный вход
final class AuthDeleteFailure extends AppState {
  const AuthDeleteFailure(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
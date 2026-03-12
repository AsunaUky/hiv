// ignore_for_file: always_use_package_imports
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
  final String name;
  final String email;
  final String password;
  @override
  List<Object> get props => [name, email, password];
}

final class AuthGuestRequested   extends AuthEvent { const AuthGuestRequested(); }
final class AuthGoogleRequested  extends AuthEvent { const AuthGoogleRequested(); }
final class AuthSignOutRequested extends AuthEvent { const AuthSignOutRequested(); }
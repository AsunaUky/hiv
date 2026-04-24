part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

final class AuthSignInRequested extends AppEvent {
  const AuthSignInRequested({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
}

final class AuthRegisterRequested extends AppEvent {
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

final class AuthGuestRequested   extends AppEvent { const AuthGuestRequested(); }
final class AuthGoogleRequested  extends AppEvent { const AuthGoogleRequested(); }
final class AuthSignOutRequested extends AppEvent { const AuthSignOutRequested(); }
final class AuthDeleteRequested  extends AppEvent { const AuthDeleteRequested(); }
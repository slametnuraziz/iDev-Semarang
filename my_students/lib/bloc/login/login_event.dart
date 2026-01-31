import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Event ketika user klik tombol login
class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

// Event ketika user logout
class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}

// Event untuk check apakah sudah login
class CheckLoginStatus extends LoginEvent {
  const CheckLoginStatus();
}

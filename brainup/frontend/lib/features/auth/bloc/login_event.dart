abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final String role;

  LoginSubmitted(
    this.email,
    this.password,
    this.role,
  );
}

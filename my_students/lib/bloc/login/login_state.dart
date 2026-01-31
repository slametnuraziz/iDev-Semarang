import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String username;
  final int? userId;

  const LoginSuccess({
    required this.username,
    this.userId,
  });

  @override
  List<Object?> get props => [
    username,
    userId ?? 0,
  ];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoginUnauthenticated extends LoginState {
  const LoginUnauthenticated();
}

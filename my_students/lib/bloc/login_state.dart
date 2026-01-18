import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// State awal
class LoginInitial extends LoginState {
  const LoginInitial();
}

// State ketika proses loading
class LoginLoading extends LoginState {
  const LoginLoading();
}

// State ketika login berhasil
class LoginSuccess extends LoginState {
  final String username;
  final String name;
  final String kelas;

  const LoginSuccess({
    required this.username,
    required this.name,
    required this.kelas,
  });

  @override
  List<Object?> get props => [
    username,
    name,
    kelas,
  ];
}

// State ktika login gagal
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});
}

// State ketika user belum login (untuk auto-check)
class LoginUnauthenticated extends LoginState {
  const LoginUnauthenticated();
}

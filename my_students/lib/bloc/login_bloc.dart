import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc
    extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    // Handle login button pressed
    on<LoginButtonPressed>(_onLoginButtonPressed);

    // Handle logout
    on<LogoutRequested>(_onLogoutRequested);

    // Handle check login status
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    // Emit loading state
    emit(const LoginLoading());

    // Simulasi network delay
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    // validasi username dan password
    if (event.username.isEmpty ||
        event.password.isEmpty) {
      emit(
        const LoginFailure(
          error:
              'Username dan Password tidak boleh kosong',
        ),
      );
      return;
    }

    // Check credentials (hardcoded untuk demo)
    if (event.username == 'admin' &&
        event.password == 'password') {
      // login berhasil
      emit(
        const LoginSuccess(
          username: 'admin',
          name: 'Slamet Nur Aziz',
          kelas: 'XI TKJ',
        ),
      );
    } else if (event.username == 'wahyu' &&
        event.password == '12345') {
      // Alternative login
      emit(
        const LoginSuccess(
          username: 'wahyu',
          name: 'Wahyu Amunudin',
          kelas: 'XI TKJ 4',
        ),
      );
    } else {
      // Login gagal
      emit(
        const LoginFailure(
          error: 'Username atau Password salah!',
        ),
      );
    }
  }

  // Handler untuk logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    // Simulasi proses logout (clear token, dll)
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    emit(const LoginUnauthenticated());
  }

  // Handler untuk check status login
  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<LoginState> emit,
  ) async {
    // Simulasi check token dari storage
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    emit(const LoginUnauthenticated());
  }
}

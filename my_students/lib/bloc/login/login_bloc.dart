import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc
    extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  static const String _loginUrl =
      'http://192.168.137.1:3000/api/auth/login';

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    if (event.username.isEmpty ||
        event.password.isEmpty) {
      emit(
        const LoginFailure(
          error:
              'Username dan Password wajib diisi',
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': event.username,
          'password': event.password,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          result['success'] == true) {
        final box = await Hive.openBox('authBox');
        await box.put(
          'token',
          result['data']['token'],
        );
        await box.put(
          'username',
          result['data']['username'],
        );
        await box.put(
          'user_id',
          result['data']['id'],
        );

        emit(
          LoginSuccess(
            username: result['data']['username'],
            userId: result['data']['id'],
          ),
        );
      } else {
        emit(
          LoginFailure(
            error:
                result['message'] ??
                'Login gagal',
          ),
        );
      }
    } catch (e) {
      emit(
        LoginFailure(
          error: 'Terjadi kesalahan: $e',
        ),
      );
    }
  }

  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<LoginState> emit,
  ) async {
    final box = await Hive.openBox('authBox');
    final token = box.get('token');
    final username = box.get('username');
    final userId = box.get('user_id');

    if (token != null && username != null) {
      emit(
        LoginSuccess(
          username: username,
          userId: userId,
        ),
      );
    } else {
      emit(const LoginUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final box = await Hive.openBox('authBox');
    await box.clear();
    emit(const LoginUnauthenticated());
  }
}

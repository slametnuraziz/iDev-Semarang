import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

import '../../../core/storage/hive_storage.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/api/api_config.dart';

class LoginBloc
    extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;

  LoginBloc(this.repo) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        final result = await repo.login(
          email: event.email,
          password: event.password,
          role: event.role,
        );

        final userId = result['data']['id']
            .toString();
        final token = result['token'];

        // 1. Simpan ke Hive
        await HiveStorage.saveToken(token);
        await HiveStorage.saveRole(event.role);
        await HiveStorage.saveUserId(userId);

        // 2. ✅ FIX: gunakan format ID unik agar tidak diblokir OneSignal
        final oneSignalUserId =
            'brainup_${event.role}_$userId';
        print(
          'OneSignal External ID: $oneSignalUserId',
        );
        await NotificationService.setExternalUserId(
          oneSignalUserId,
        );
        print('setExternalUserId selesai');

        // 3. Tunggu OneSignal sync + retry
        await Future.delayed(
          const Duration(seconds: 3),
        );

        String? subscriptionId =
            NotificationService.getPlayerId();
        print(
          'Subscription ID pertama: $subscriptionId',
        );

        int retry = 0;
        while ((subscriptionId == null ||
                subscriptionId.isEmpty ||
                subscriptionId.startsWith(
                  'local-',
                )) &&
            retry < 5) {
          await Future.delayed(
            const Duration(seconds: 2),
          );
          subscriptionId =
              NotificationService.getPlayerId();
          retry++;
          print(
            '🔄 Retry $retry - Subscription ID: $subscriptionId',
          );
        }

        print(
          '✅ Subscription ID final: $subscriptionId',
        );

        // 4. Kirim subscription ID ke backend
        if (subscriptionId != null &&
            subscriptionId.isNotEmpty &&
            !subscriptionId.startsWith(
              'local-',
            )) {
          final response = await http.put(
            Uri.parse(
              '${ApiConfig.baseUrl}/${event.role}/onesignal/$userId',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'subscription_id': subscriptionId,
            }),
          );
          print(
            '📤 Update OneSignal ID response: ${response.statusCode} ${response.body}',
          );
        } else {
          print(
            '⚠️ Subscription ID tidak valid, skip update',
          );
        }

        // 5. Set tag untuk segmentasi
        await NotificationService.setTags({
          'role': event.role,
          'user_id': userId,
        });

        emit(LoginSuccess(event.role));
      } catch (e) {
        print('❌ LoginBloc error: $e');
        emit(LoginFailure(e.toString()));
      }
    });
  }
}

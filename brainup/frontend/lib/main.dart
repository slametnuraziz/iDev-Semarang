import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/storage/hive_storage.dart';
import 'core/services/notification_service.dart';

// ✅ FIX: import deeplink_service.dart (tanpa 's')
import 'core/services/deeplink_service.dart';

import 'features/auth/bloc/login_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/pages/login_page.dart';
import 'features/siswa/bloc/siswa_absensi_bloc.dart';
import 'features/siswa/repository/siswa_repository.dart';
import 'features/guru/pages/guru_main_page.dart';
import 'features/siswa/pages/siswa_main_page.dart';
import 'features/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveStorage.init();

  await NotificationService.initialize();

  // ✅ Callback notif tap → DeepLinkService
  NotificationService
      .onNotificationOpened = (data) {
    DeepLinkService.handleFromNotification(data);
  };

  await DeepLinkService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LoginBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (_) =>
              SiswaAbsensiBloc(SiswaRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey:
            DeepLinkService.navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashPage(),
          '/login': (_) => const LoginPage(),
          '/guru-main': (_) =>
              const GuruMainPage(),
          '/siswa-main': (_) =>
              const SiswaMainPage(),
        },
      ),
    );
  }
}

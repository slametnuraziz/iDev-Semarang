import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/login/login_bloc.dart';
import 'bloc/login/login_event.dart';
import 'pages/login_page.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint(
      '${bloc.runtimeType} Event: $event',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// INIT HIVE
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoginBloc()
            ..add(const CheckLoginStatus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard Siswa',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const LoginPageBloc(),
      ),
    );
  }
}

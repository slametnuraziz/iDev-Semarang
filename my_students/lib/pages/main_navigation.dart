import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_state.dart';
import 'home.dart';
import 'login_page.dart';
import 'schedule_page.dart';
import 'teacher_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {
  int _currentIndex = 1; // home berada di tengah

  final List<Widget> _pages = const [
    TeacherPage(),
    HomePage(), // home di tengah
    SchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginPageBloc(),
            ),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(
            () => _currentIndex = index,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              label: 'Guru',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today_rounded,
              ),
              label: 'Jadwal',
            ),
          ],
        ),
      ),
    );
  }
}

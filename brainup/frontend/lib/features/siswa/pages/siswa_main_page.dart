import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import '../../../core/storage/hive_storage.dart';
import '../bloc/siswa_home_bloc.dart';
import '../bloc/siswa_home_event.dart';
import '../bloc/siswa_absensi_bloc.dart'; // ✅ TAMBAHKAN
import '../repository/siswa_repository.dart';
import 'siswa_home_page.dart';
import 'siswa_profile_page.dart';
import 'siswa_jadwal_page.dart';

class SiswaMainPage extends StatefulWidget {
  const SiswaMainPage({super.key});

  static _SiswaMainPageState? of(
    BuildContext context,
  ) => context
      .findAncestorStateOfType<
        _SiswaMainPageState
      >();

  @override
  State<SiswaMainPage> createState() =>
      _SiswaMainPageState();
}

class _SiswaMainPageState
    extends State<SiswaMainPage> {
  late int _index;
  late final SiswaHomeBloc _homeBloc;
  late final SiswaAbsensiBloc
  _absensiBloc; // ✅ TAMBAHKAN
  late final SiswaRepository
  _repository; // ✅ TAMBAHKAN

  final _pages = const [
    SiswaProfilePage(),
    SiswaHomePage(),
    SiswaJadwalPage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = HiveStorage.getNavIndex();

    // ✅ INISIALISASI REPOSITORY DAN BLOCS
    _repository = SiswaRepository();
    _homeBloc = SiswaHomeBloc(_repository)
      ..add(LoadSiswaJadwal());
    _absensiBloc = SiswaAbsensiBloc(_repository);
  }

  @override
  void dispose() {
    _homeBloc.close();
    _absensiBloc.close(); // ✅ TAMBAHKAN
    super.dispose();
  }

  void setTabIndex(int i) {
    setState(() => _index = i);
    HiveStorage.setNavIndex(i);

    if (i == 0) {
      _homeBloc.add(LoadSiswaProfile());
    } else if (i == 1 || i == 2) {
      _homeBloc.add(LoadSiswaJadwal());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(
          value: _absensiBloc,
        ), // ✅ TAMBAHKAN
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFF8FAFF),
        body: IndexedStack(
          index: _index,
          children: _pages,
        ),
        bottomNavigationBar: _buildModernNav(),
      ),
    );
  }

  Widget _buildModernNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        24,
        0,
        24,
        30,
      ),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6366F1,
            ).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                0,
                Icons.person_rounded,
                "Profile",
              ),
              _navItem(
                1,
                Icons.grid_view_rounded,
                "Home",
              ),
              _navItem(
                2,
                Icons.calendar_today_rounded,
                "Jadwal",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int i,
    IconData icon,
    String label,
  ) {
    bool isSelected = _index == i;
    return GestureDetector(
      onTap: () => setTabIndex(i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              width: isSelected ? 20 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 6),
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : Colors.grey[400],
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

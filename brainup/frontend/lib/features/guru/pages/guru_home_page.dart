import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/theme/app_theme.dart';
import '../bloc/guru_home_bloc.dart';
import '../bloc/guru_home_event.dart';
import '../bloc/guru_home_state.dart';
import 'guru_main_page.dart';

class GuruHomePage extends StatelessWidget {
  const GuruHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body:
          BlocBuilder<
            GuruHomeBloc,
            GuruHomeState
          >(
            builder: (context, state) {
              if (state is GuruHomeLoading) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                );
              }

              if (state is GuruHomeLoaded) {
                final jadwal = state.jadwal;
                return RefreshIndicator(
                  color: const Color(0xFF6366F1),
                  onRefresh: () async => context
                      .read<GuruHomeBloc>()
                      .add(LoadGuruJadwal()),
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(
                          20,
                          60,
                          20,
                          120,
                        ),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildWelcomeCard(),
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        "Menu Utama",
                      ),
                      const SizedBox(height: 16),
                      _buildMenuGrid(context),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          _buildSectionTitle(
                            "Jadwal Mengajar",
                          ),
                          if (jadwal.isNotEmpty)
                            GestureDetector(
                              onTap: () =>
                                  GuruMainPage.of(
                                    context,
                                  )?.setTabIndex(
                                    2,
                                  ),
                              child: const Text(
                                "Lihat Semua",
                                style: TextStyle(
                                  color: Color(
                                    0xFF6366F1,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (jadwal.isEmpty)
                        _buildEmptyState()
                      else
                        ...jadwal
                            .take(3)
                            .map(
                              (j) =>
                                  _buildJadwalCard(
                                    j,
                                  ),
                            ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "DASHBOARD GURU",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6366F1),
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Brainup Indonesia",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4451FE),
            Color(0xFF6366F1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6366F1,
            ).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Selamat Datang!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Gunakan aplikasi ini untuk memantau jadwal mengajar Anda di Brainup.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Row(
      children: [
        _menuItem(
          Icons.calendar_month_rounded,
          "Jadwal",
          () => GuruMainPage.of(
            context,
          )?.setTabIndex(2),
        ),
        const SizedBox(width: 16),
        _menuItem(
          Icons.person_rounded,
          "Profile",
          () => GuruMainPage.of(
            context,
          )?.setTabIndex(0),
        ),
      ],
    );
  }

  Widget _menuItem(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.04,
                ),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF6366F1,
                  ).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalCard(
    Map<String, dynamic> j,
  ) {
    final hari = j['hari'] ?? '-';
    final jumlahMinggu = j['jumlah_minggu'] ?? 1;
    final jamMulai = j['jam_mulai'] ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF6366F1),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  j['mata_pelajaran'] ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.repeat_rounded,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Setiap $hari • $jamMulai • $jumlahMinggu minggu",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 50,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          const Text(
            "Belum ada jadwal hari ini",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

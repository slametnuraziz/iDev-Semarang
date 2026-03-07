import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/siswa_home_bloc.dart';
import '../bloc/siswa_home_state.dart';
import 'siswa_main_page.dart';

class SiswaHomePage extends StatelessWidget {
  const SiswaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body:
          BlocBuilder<
            SiswaHomeBloc,
            SiswaHomeState
          >(
            builder: (context, state) {
              if (state is SiswaHomeLoading) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                );
              } else if (state
                  is SiswaHomeLoaded) {
                final jadwal = state.jadwal;

                return ListView(
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
                    // ✅ UBAH DARI jadwalHariIni.length JADI jadwal.length
                    _buildTotalJadwalCard(
                      jadwal.length,
                      context,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        _buildSectionTitle(
                          "Jadwal Mendatang",
                        ),
                        if (jadwal.isNotEmpty)
                          GestureDetector(
                            onTap: () =>
                                SiswaMainPage.of(
                                  context,
                                )?.setTabIndex(2),
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
                            (item) =>
                                _buildJadwalCard(
                                  item,
                                ),
                          ),
                  ],
                );
              } else if (state
                  is SiswaHomeError) {
                return Center(
                  child: Text(state.message),
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
          "DASHBOARD SISWA",
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
            "Pantau jadwal pelajaran dan kelola absensi Anda dengan mudah.",
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

  // ✅ RENAME METHOD DAN UBAH TEXT
  Widget _buildTotalJadwalCard(
    int count,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(
                0xFF6366F1,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: const Icon(
              Icons
                  .calendar_month_rounded, // ✅ GANTI ICON BIAR LEBIH COCOK
              color: Color(0xFF6366F1),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Jadwal", // ✅ UBAH TEXT
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$count Mata Pelajaran", // ✅ TETAP SAMA
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(
    Map<String, dynamic> item,
  ) {
    final hari = item['hari'] ?? '-';
    final jumlahMinggu =
        item['jumlah_minggu'] ?? 1;
    final jamMulai = item['jam_mulai'] ?? '-';

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
                  item['mata_pelajaran'] ?? '-',
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
            "Belum ada jadwal",
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

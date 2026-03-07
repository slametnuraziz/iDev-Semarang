import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bloc/siswa_home_bloc.dart';
import '../bloc/siswa_home_event.dart';
import '../bloc/siswa_home_state.dart';

import '../bloc/siswa_absensi_bloc.dart';
import '../bloc/siswa_absensi_event.dart';
import '../bloc/siswa_absensi_state.dart';

class SiswaJadwalPage extends StatelessWidget {
  const SiswaJadwalPage({super.key});

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
              }

              if (state is SiswaHomeError) {
                return _buildErrorState(
                  context,
                  state.message,
                );
              }

              if (state is SiswaHomeLoaded) {
                final jadwal = state.jadwal;

                if (jadwal.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: const Color(0xFF6366F1),
                  onRefresh: () async {
                    context
                        .read<SiswaHomeBloc>()
                        .add(LoadSiswaJadwal());
                  },
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
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        "Daftar Jadwal Pelajaran",
                      ),
                      const SizedBox(height: 16),
                      ...jadwal.map(
                        (item) =>
                            _buildJadwalCard(
                              context,
                              item,
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

  // ================= HEADER =================
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "JADWAL PELAJARAN",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6366F1),
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Semua Mata Pelajaran",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  // ================= CARD JADWAL =================
  Widget _buildJadwalCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['mata_pelajaran'] ??
                          '-',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['guru_nama'] ?? '-',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Setiap ${item['hari'] ?? '-'} • ${item['jam_mulai'] ?? '-'} - ${item['jam_selesai'] ?? '-'} • ${item['jumlah_minggu'] ?? 1} minggu",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // 🔥 Validasi ID jadwal
                final jadwalId =
                    int.tryParse(
                      item['id'].toString(),
                    ) ??
                    0;

                if (jadwalId == 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ID jadwal tidak valid',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // 🔥 GENERATE QR LEWAT BLOC
                context
                    .read<SiswaAbsensiBloc>()
                    .add(
                      GenerateQrSiswa(jadwalId),
                    );

                // 🔥 Tampilkan dialog dan reset state setelah ditutup
                _showQRDialog(
                  context,
                  item['mata_pelajaran'] ??
                      'QR Absensi',
                ).then((_) {
                  context
                      .read<SiswaAbsensiBloc>()
                      .add(ResetQrSiswa());
                });
              },
              icon: const Icon(
                Icons.qr_code_scanner,
              ),
              label: const Text(
                "Tampilkan QR Code",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF6366F1,
                ),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= QR DIALOG =================
  Future<void> _showQRDialog(
    BuildContext context,
    String title,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SiswaAbsensiBloc>(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<SiswaAbsensiBloc, SiswaAbsensiState>(
              builder: (context, state) {
                if (state
                    is AbsensiSiswaLoading) {
                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child:
                          CircularProgressIndicator(
                            color: Color(
                              0xFF6366F1,
                            ),
                          ),
                    ),
                  );
                }

                if (state
                    is AbsensiSiswaQrReady) {
                  return Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(
                            0xFF1E293B,
                          ),
                        ),
                        textAlign:
                            TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding:
                            const EdgeInsets.all(
                              16,
                            ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                          border: Border.all(
                            color: const Color(
                              0xFFE2E8F0,
                            ),
                            width: 2,
                          ),
                        ),
                        child: QrImageView(
                          data: state.qrToken,
                          size: 220,
                          backgroundColor:
                              Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tunjukkan QR ini ke guru',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(
                            0xFF64748B,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'QR berlaku selama 5 menit',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(
                            0xFF94A3B8,
                          ),
                          fontStyle:
                              FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop();
                          },
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              color: Color(
                                0xFF6366F1,
                              ),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is AbsensiSiswaError) {
                  return Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Gagal Generate QR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(
                            0xFF1E293B,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(
                            0xFF64748B,
                          ),
                        ),
                        textAlign:
                            TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red,
                            foregroundColor:
                                Colors.white,
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'Menyiapkan QR...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================= EMPTY =================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada jadwal',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ERROR =================
  Widget _buildErrorState(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<SiswaHomeBloc>().add(
                LoadSiswaJadwal(),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF6366F1,
              ),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8),
              ),
            ),
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
}

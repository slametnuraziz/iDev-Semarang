import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../bloc/guru_absensi_bloc.dart';
import '../bloc/guru_absensi_event.dart';
import '../bloc/guru_absensi_state.dart';
import '../repository/guru_repository.dart';

class GuruAbsensiPage extends StatelessWidget {
  final int jadwalId;
  final String mataPelajaran;

  const GuruAbsensiPage({
    super.key,
    required this.jadwalId,
    required this.mataPelajaran,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GuruAbsensiBloc(GuruRepository())
            ..add(LoadAbsensi(jadwalId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocConsumer<GuruAbsensiBloc, GuruAbsensiState>(
                  listener: (context, state) {
                    if (state
                        is AbsensiScanSuccess) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons
                                    .check_circle,
                                color:
                                    Colors.white,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  state.message,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor:
                              const Color(
                                0xFF10B981,
                              ),
                          behavior:
                              SnackBarBehavior
                                  .floating,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                          duration:
                              const Duration(
                                seconds: 2,
                              ),
                        ),
                      );
                    } else if (state
                        is AbsensiError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons
                                    .error_outline,
                                color:
                                    Colors.white,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  state.message
                                      .replaceAll(
                                        'Exception:',
                                        '',
                                      )
                                      .trim(),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor:
                              Colors.redAccent,
                          behavior:
                              SnackBarBehavior
                                  .floating,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                          duration:
                              const Duration(
                                seconds: 3,
                              ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AbsensiLoading) {
                      return const Center(
                        child:
                            CircularProgressIndicator(
                              color: Color(
                                0xFF6366F1,
                              ),
                            ),
                      );
                    }

                    if (state is AbsensiLoaded) {
                      final rekap = state.rekap;
                      if (rekap.isEmpty)
                        return _buildEmptyState();

                      final hadir = rekap
                          .where(
                            (s) =>
                                s['status'] ==
                                'hadir',
                          )
                          .length;
                      final total = rekap.length;

                      return Column(
                        children: [
                          _buildStatCard(
                            hadir,
                            total,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    20,
                                    100,
                                  ),
                              itemCount:
                                  rekap.length,
                              itemBuilder: (context, index) {
                                final s =
                                    rekap[index];
                                final isHadir =
                                    s['status'] ==
                                    'hadir';
                                return _buildSiswaCard(
                                  s,
                                  isHadir,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is AbsensiError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color:
                                  Colors.red[300],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              state.message
                                  .replaceAll(
                                    'Exception:',
                                    '',
                                  )
                                  .trim(),
                              textAlign: TextAlign
                                  .center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<
                                      GuruAbsensiBloc
                                    >()
                                    .add(
                                      LoadAbsensi(
                                        jadwalId,
                                      ),
                                    );
                              },
                              icon: const Icon(
                                Icons.refresh,
                              ),
                              label: const Text(
                                'Coba Lagi',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),

        // ===================================================
        // ✅ FLOATING ACTION BUTTON (UI TIDAK BERUBAH)
        // ===================================================
        floatingActionButton: Container(
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          child:
              BlocBuilder<
                GuruAbsensiBloc,
                GuruAbsensiState
              >(
                builder: (blocContext, state) {
                  return FloatingActionButton.extended(
                    onPressed: () async {
                      // ✅ SIMPAN BLOC SEBELUM ASYNC
                      final bloc = blocContext
                          .read<
                            GuruAbsensiBloc
                          >();

                      // ✅ SCAN QR (UI ASLI)
                      final qrToken =
                          await _scanQr(context);

                      // ✅ KIRIM EVENT TANPA context.read SETELAH await
                      if (qrToken != null) {
                        bloc.add(
                          ScanQrEvent(
                            qrToken,
                            jadwalId,
                          ),
                        );
                      }
                    },
                    backgroundColor: const Color(
                      0xFF6366F1,
                    ),
                    elevation: 4,
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Scan QR',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  // ================= UI ASLI (TIDAK DIUBAH) =================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(
                0xFF6366F1,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'ABSENSI KELAS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mataPelajaran,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(int hadir, int total) {
    return Container(
      margin: const EdgeInsets.all(20),
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
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.people_rounded,
            label: 'Total Siswa',
            value: total.toString(),
          ),
          _StatItem(
            icon: Icons.check_circle_rounded,
            label: 'Hadir',
            value: hadir.toString(),
          ),
          _StatItem(
            icon: Icons.cancel_rounded,
            label: 'Belum',
            value: (total - hadir).toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildSiswaCard(
    Map<String, dynamic> s,
    bool isHadir,
  ) {
    return ListTile(
      title: Text(s['nama'] ?? '-'),
      subtitle: Text(
        isHadir ? 'Hadir' : 'Belum hadir',
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('Belum ada data absensi'),
    );
  }

  Future<String?> _scanQr(
    BuildContext context,
  ) async {
    String? qrResult;
    MobileScannerController? controller;

    try {
      controller = MobileScannerController(
        detectionSpeed:
            DetectionSpeed.noDuplicates,
      );

      await showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          child: SizedBox(
            height: 300,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final raw = capture
                    .barcodes
                    .first
                    .rawValue;
                if (raw != null &&
                    qrResult == null) {
                  qrResult = raw;
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ),
        ),
      );
    } finally {
      await controller?.dispose();
    }

    return qrResult;
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScheduleDetailPage extends StatelessWidget {
  final Map<String, dynamic> schedule;

  const ScheduleDetailPage({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          schedule["mata_pelajaran"] ??
              "Detail Jadwal",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                0xFF6366F1,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF6366F1),
            ),
          ),
          onPressed: () =>
              Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF6366F1,
                    ).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    schedule["mata_pelajaran"] ??
                        "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                    ),
                    child: Text(
                      schedule["hari"] ?? "-",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Section
            _buildSectionTitle(
              "Informasi Jadwal",
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoTile(
                    icon: Icons.person_rounded,
                    title: "Guru Pengajar",
                    value:
                        schedule["nama_guru"] ??
                        "-",
                    color: const Color(
                      0xFF6366F1,
                    ),
                    isFirst: true,
                  ),
                  _infoTile(
                    icon:
                        Icons.access_time_rounded,
                    title: "Waktu",
                    value:
                        "${schedule["jam_mulai"] ?? "-"} - ${schedule["jam_selesai"] ?? "-"}",
                    color: const Color(
                      0xFF10B981,
                    ),
                  ),
                  _infoTile(
                    icon: Icons
                        .calendar_today_rounded,
                    title: "Hari",
                    value:
                        schedule["hari"] ?? "-",
                    color: const Color(
                      0xFFF59E0B,
                    ),
                  ),
                  _infoTile(
                    icon: Icons.class_rounded,
                    title: "Kelas",
                    value:
                        schedule["kelas"] ?? "-",
                    color: const Color(
                      0xFF8B5CF6,
                    ),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // QR Code Section
            _buildSectionTitle("QR Code Absensi"),
            const SizedBox(height: 16),

            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                            16,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                        border: Border.all(
                          color: const Color(
                            0xFF6366F1,
                          ).withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: QrImageView(
                        data:
                            "Jadwal:${schedule["mata_pelajaran"]},${schedule["nama_guru"]},${schedule["hari"]},${schedule["jam_mulai"]}-${schedule["jam_selesai"]}",
                        version: QrVersions.auto,
                        size: 220.0,
                        backgroundColor:
                            Colors.white,
                        eyeStyle:
                            const QrEyeStyle(
                              eyeShape: QrEyeShape
                                  .square,
                              color: Color(
                                0xFF6366F1,
                              ),
                            ),
                        dataModuleStyle:
                            const QrDataModuleStyle(
                              dataModuleShape:
                                  QrDataModuleShape
                                      .square,
                              color: Color(
                                0xFF1F2937,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF6366F1,
                        ).withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons
                                .info_outline_rounded,
                            size: 18,
                            color: Color(
                              0xFF6366F1,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Scan untuk absensi",
                            style: TextStyle(
                              color: const Color(
                                0xFF6366F1,
                              ).withOpacity(0.9),
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(
              2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

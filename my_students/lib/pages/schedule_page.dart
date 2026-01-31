import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'schedule_detail.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  final String apiUrl =
      "http://192.168.137.1:3000/api/jadwal";

  Future<List<Map<String, dynamic>>>
  fetchSchedules() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(
          response.body,
        );

        // Debug: Print response untuk melihat struktur
        debugPrint("API Response: $responseBody");
        debugPrint(
          "Response Type: ${responseBody.runtimeType}",
        );

        // Handle berbagai kemungkinan struktur response
        if (responseBody is List) {
          // Jika response langsung array: [{ }, { }]
          return List<Map<String, dynamic>>.from(
            responseBody,
          );
        } else if (responseBody is Map) {
          // Jika response wrapped dalam object: { "data": [...] }
          if (responseBody.containsKey('data')) {
            final data = responseBody['data'];
            if (data is List) {
              return List<
                Map<String, dynamic>
              >.from(data);
            }
          }
          // Jika response adalah single object: { "id": 1, ... }
          // Wrap dalam array
          return [
            Map<String, dynamic>.from(
              responseBody,
            ),
          ];
        }

        throw Exception(
          "Unexpected response format",
        );
      } else {
        throw Exception(
          "Failed to load schedules: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error fetching schedules: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Jadwal Pelajaran",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF6366F1,
                ).withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF6366F1),
                size: 20,
              ),
            ),
            onPressed: () {
              // Trigger rebuild to refresh data
              (context as Element)
                  .markNeedsBuild();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Memuat jadwal...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                            20,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons
                            .error_outline_rounded,
                        color:
                            Colors.red.shade400,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Terjadi Kesalahan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        (context as Element)
                            .markNeedsBuild();
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        "Coba Lagi",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                              0xFF6366F1,
                            ),
                        foregroundColor:
                            Colors.white,
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .calendar_today_rounded,
                      color: Colors.grey.shade400,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Tidak Ada Jadwal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Belum ada jadwal yang tersedia",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final schedules = snapshot.data!;

          // Group schedules by day
          final groupedSchedules =
              <
                String,
                List<Map<String, dynamic>>
              >{};
          for (var schedule in schedules) {
            final day =
                schedule["hari"] ?? "Lainnya";
            if (!groupedSchedules.containsKey(
              day,
            )) {
              groupedSchedules[day] = [];
            }
            groupedSchedules[day]!.add(schedule);
          }

          final days = [
            "Senin",
            "Selasa",
            "Rabu",
            "Kamis",
            "Jumat",
            "Sabtu",
            "Minggu",
          ];
          final sortedDays = days
              .where(
                (day) => groupedSchedules
                    .containsKey(day),
              )
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedDays.length,
            itemBuilder: (context, dayIndex) {
              final day = sortedDays[dayIndex];
              final daySchedules =
                  groupedSchedules[day]!;

              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (dayIndex > 0)
                    const SizedBox(height: 24),

                  // Day Header
                  Padding(
                    padding:
                        const EdgeInsets.only(
                          left: 4,
                          bottom: 12,
                        ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                          decoration: BoxDecoration(
                            gradient:
                                const LinearGradient(
                                  colors: [
                                    Color(
                                      0xFF6366F1,
                                    ),
                                    Color(
                                      0xFF8B5CF6,
                                    ),
                                  ],
                                ),
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                          child: Text(
                            day,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${daySchedules.length} Jadwal",
                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Schedule Cards
                  ...daySchedules.map(
                    (schedule) =>
                        _buildScheduleCard(
                          context,
                          schedule,
                        ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    Map<String, dynamic> schedule,
  ) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
    ];
    final color =
        colors[schedule["id"] % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ScheduleDetailPage(
                      schedule: schedule,
                    ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left Color Indicator
                Container(
                  width: 4,
                  height: 70,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule["mata_pelajaran"] ??
                            "-",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .person_outline_rounded,
                            size: 16,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              schedule["nama_guru"] ??
                                  "-",
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .access_time_rounded,
                            size: 16,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${schedule["jam_mulai"] ?? "-"} - ${schedule["jam_selesai"] ?? "-"}",
                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade700,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

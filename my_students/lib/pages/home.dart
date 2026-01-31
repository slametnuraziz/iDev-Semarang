import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_state.dart';
import '../bloc/login/login_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          final name = state.username;
          return _HomeContent(name: name);
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatefulWidget {
  final String name;
  const _HomeContent({required this.name});

  @override
  State<_HomeContent> createState() =>
      _HomeContentState();
}

class _HomeContentState
    extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  int jumlahGuru = 0;
  int jumlahMurid = 120;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    fetchJumlahGuru();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchJumlahGuru() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.137.1:3000/api/guru',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List guruList = data['data'];
        setState(() {
          jumlahGuru = guruList.length;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint(
          'Error fetch guru: ${response.body}',
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetch guru: $e');
    }
  }

  String get initial {
    final parts = widget.name.split(' ');
    return parts.length > 1
        ? (parts[0][0] + parts[1][0])
              .toUpperCase()
        : parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor:
                  Colors.indigo.shade100,
              child: Text(
                initial,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black54,
            ),
            onPressed: () {
              context.read<LoginBloc>().add(
                LogoutRequested(),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _headerCard(),
                    const SizedBox(height: 24),
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(
                            40,
                          ),
                          child:
                              CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      _statsRow(),
                      const SizedBox(height: 32),
                      _sectionTitle(
                        "Informasi Sekolah",
                      ),
                      const SizedBox(height: 16),
                      _schoolInfoSection(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFA855F7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6366F1,
            ).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.2,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white
                        .withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white
                      .withOpacity(0.3),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang! 👋",
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.9),
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.2,
              ),
              borderRadius: BorderRadius.circular(
                12,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(
                  0.3,
                ),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  _getCurrentDate(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            title: "Total Guru",
            value: jumlahGuru.toString(),
            icon: Icons.people_rounded,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InfoCard(
            title: "Total Murid",
            value: jumlahMurid.toString(),
            icon: Icons.school_rounded,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF10B981),
                Color(0xFF34D399),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _schoolInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoItem(
            icon: Icons.school_rounded,
            title: "Nama Sekolah",
            value: "SMK Nusa Bisa",
            isFirst: true,
          ),
          _infoItem(
            icon: Icons.location_on_rounded,
            title: "Alamat",
            value:
                "Jl. Pendidikan No.123, Semarang",
          ),
          _infoItem(
            icon: Icons.phone_rounded,
            title: "Telepon",
            value: "(024) 1234567",
          ),
          _infoItem(
            icon: Icons.language_rounded,
            title: "Website",
            value: "www.smknusabisa.sch.id",
          ),
          _infoItem(
            icon: Icons.visibility_rounded,
            title: "Visi",
            value:
                "Mencetak generasi unggul yang kompeten dan berkarakter.",
          ),
          _infoItem(
            icon: Icons.flag_rounded,
            title: "Misi",
            value:
                "• Meningkatkan kompetensi siswa\n• Mengembangkan soft skill siswa\n• Menumbuhkan karakter yang baik",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(
                    0xFF6366F1,
                  ).withOpacity(0.1),
                  const Color(
                    0xFF8B5CF6,
                  ).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
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
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.5,
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

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(
                14,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

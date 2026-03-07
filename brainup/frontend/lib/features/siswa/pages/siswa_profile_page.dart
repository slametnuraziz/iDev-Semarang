import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/hive_storage.dart';
import '../../../core/services/notification_service.dart';
import '../bloc/siswa_home_bloc.dart';
import '../bloc/siswa_home_state.dart';

class SiswaProfilePage extends StatelessWidget {
  const SiswaProfilePage({super.key});

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
                  is SiswaProfileLoaded) {
                final data = state.profile;
                return _buildProfileContent(
                  context,
                  data,
                );
              } else if (state
                  is SiswaHomeError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                  ),
                );
              }

              return const SizedBox();
            },
          ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildTopProfileSection(data),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              32,
              20,
              100,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  "Informasi Personal",
                ),
                const SizedBox(height: 16),
                _buildInfoTile(
                  Icons.email_rounded,
                  "Email",
                  data['email'],
                ),
                _buildInfoTile(
                  Icons.wc_rounded,
                  "Jenis Kelamin",
                  data['jenis_kelamin'],
                ),
                _buildInfoTile(
                  Icons.class_rounded,
                  "Kelas",
                  data['kelas'],
                ),
                _buildInfoTile(
                  Icons.school_rounded,
                  "Sekolah",
                  data['sekolah'],
                ),
                const SizedBox(height: 40),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProfileSection(
    Map<String, dynamic> data,
  ) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4451FE),
                Color(0xFF6366F1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        const Positioned(
          top: 60,
          child: Text(
            "Profil Siswa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 120,
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                24,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.05,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(
                    0xFFEEF2FF,
                  ),
                  child: Text(
                    (data['nama'] != null &&
                            data['nama']
                                .isNotEmpty)
                        ? data['nama'][0]
                              .toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4451FE),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data['nama'] ?? '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['email'] ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 300),
      ],
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    dynamic value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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

  Widget _buildLogoutButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            _showLogoutDialog(context),
        icon: const Icon(
          Icons.logout_rounded,
          size: 20,
        ),
        label: const Text(
          "Keluar dari Akun",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text(
          'Yakin ingin keluar dari aplikasi Brainup?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await NotificationService.logoutUser();
      await HiveStorage.clear();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (_) => false,
        );
      }
    }
  }
}

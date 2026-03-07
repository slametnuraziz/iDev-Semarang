import 'package:flutter/material.dart';
import '../../core/storage/hive_storage.dart';
import '../../core/services/deeplink_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1500,
      ),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
        );

    _fadeAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeIn,
          ),
        );

    _controller.forward();
    _checkSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    // Memberikan waktu animasi selesai agar tidak kaku
    await Future.delayed(
      const Duration(milliseconds: 2500),
    );

    if (!mounted) return;

    final isLogin = HiveStorage.isLoggedIn();
    final role = HiveStorage.getRole();

    if (isLogin) {
      if (role == 'guru') {
        Navigator.pushReplacementNamed(
          context,
          '/guru-main',
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/siswa-main',
        );
      }

      await Future.delayed(
        const Duration(milliseconds: 500),
      );
      if (mounted) {
        await DeepLinkService.handleInitialLinkAfterLogin(
          context,
          role ?? 'siswa',
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna navy gelap agar logo putih terlihat sangat menonjol (Elegan)
      backgroundColor: const Color(0xFF1A1F37),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1F37),
              Color(0xFF4451FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // Logo Icon dengan Glow Effect tipis
                Container(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white
                            .withOpacity(0.05),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Brand Name
                const Text(
                  'BrainUp',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),

                // Tagline
                Text(
                  'Upgrade Your Brain',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                        .withOpacity(0.6),
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 80),

                // Loading yang lebih kecil dan halus
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<
                          Color
                        >(
                          Colors.white
                              .withOpacity(0.5),
                        ),
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

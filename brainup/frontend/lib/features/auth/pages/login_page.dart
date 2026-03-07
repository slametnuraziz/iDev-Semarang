import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/theme/app_theme.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC =
      TextEditingController();
  final TextEditingController passC =
      TextEditingController();
  String role = 'siswa';
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(
              context,
              state.role == 'guru'
                  ? '/guru-main'
                  : '/siswa-main',
            );
          }
          if (state is LoginFailure) {
            _showErrorSnackbar(
              context,
              state.message,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Stack(
            children: [
              // 1. Background Ornaments
              _buildAnimatedBackground(),

              // 2. Main Content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                    child: Column(
                      children: [
                        // Header Section
                        _buildHeader(),
                        const SizedBox(
                          height: 40,
                        ),

                        // Form Glass Card
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                            children: [
                              _buildRoleToggle(),
                              const SizedBox(
                                height: 25,
                              ),
                              _buildInputField(
                                controller:
                                    emailC,
                                label:
                                    "Email Address",
                                icon: Icons
                                    .alternate_email_rounded,
                                isLoading:
                                    isLoading,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInputField(
                                controller: passC,
                                label: "Password",
                                icon: Icons
                                    .lock_person_rounded,
                                isPassword: true,
                                isLoading:
                                    isLoading,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              _buildSubmitButton(
                                isLoading,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (role == 'siswa')
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/register',
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "Belum punya akun? ",
                                style: TextStyle(
                                  color: Colors
                                      .grey[600],
                                  fontSize: 13,
                                ),
                                children: const [
                                  TextSpan(
                                    text:
                                        "Daftar Sekarang",
                                    style: TextStyle(
                                      color: Color(
                                        0xFF6366F1,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Container(color: const Color(0xFFF8FAFF)),
        Positioned(
          top: -100,
          right: -50,
          child: _circleBlur(
            const Color(
              0xFF6366F1,
            ).withOpacity(0.15),
            300,
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: _circleBlur(
            const Color(
              0xFFA855F7,
            ).withOpacity(0.15),
            250,
          ),
        ),
      ],
    );
  }

  Widget _circleBlur(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50,
          sigmaY: 50,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              30,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF6366F1,
                ).withOpacity(0.2),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            size: 50,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "BrainUp",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          "Unlock your potential today",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRoleToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _roleOption("Siswa", 'siswa'),
          _roleOption("Guru", 'guru'),
        ],
      ),
    );
  }

  Widget _roleOption(String title, String val) {
    bool isSelected = role == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => role = val),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 300,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              12,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword
              ? _obscurePassword
              : false,
          enabled: !isLoading,
          decoration: InputDecoration(
            hintText: "Enter your $label",
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 20,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                      () => _obscurePassword =
                          !_obscurePassword,
                    ),
                    color: Colors.grey[400],
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
              borderSide: BorderSide(
                color: Colors.grey[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
              borderSide: const BorderSide(
                color: Color(0xFF6366F1),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6366F1,
            ).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  void _handleLogin() {
    if (emailC.text.isEmpty ||
        passC.text.isEmpty) {
      _showErrorSnackbar(
        context,
        "Email dan password tidak boleh kosong",
      );
      return;
    }
    context.read<LoginBloc>().add(
      LoginSubmitted(
        emailC.text.trim(),
        passC.text.trim(),
        role,
      ),
    );
  }

  void _showErrorSnackbar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

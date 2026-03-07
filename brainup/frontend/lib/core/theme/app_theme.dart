import 'package:flutter/material.dart';

class AppTheme {
  // ================= COLORS =================
  static const Color primaryBlue = Color(
    0xFF3B82F6,
  );
  static const Color secondaryGreen = Color(
    0xFF10B981,
  );
  static const Color lightBlue = Color(
    0xFF93C5FD,
  );
  static const Color darkBlue = Color(0xFF1E40AF);

  static const Color gradientStart = Color(
    0xFF3B82F6,
  );
  static const Color gradientEnd = Color(
    0xFF10B981,
  );

  static const Color backgroundColor = Color(
    0xFFF8F9FE,
  );
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(
    0xFF1A1A2E,
  );
  static const Color textSecondary = Color(
    0xFF6B7280,
  );

  static const Color successGreen = Color(
    0xFF10B981,
  );
  static const Color warningOrange = Color(
    0xFFF59E0B,
  );
  static const Color errorRed = Color(0xFFEF4444);

  // ================= GRADIENTS =================
  static const LinearGradient primaryGradient =
      LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static const LinearGradient lightGradient =
      LinearGradient(
        colors: [lightBlue, Color(0xFFD0EAFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // ================= THEME DATA =================
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins',

      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryGreen,
        surface: cardColor,
        error: errorRed,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: textPrimary,
        ),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: primaryBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: lightBlue,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: lightBlue,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: errorRed,
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
        ),
        hintStyle: TextStyle(
          color: textSecondary.withOpacity(0.6),
        ),
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
    );
  }

  // ================= TEXT STYLES =================
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );
}

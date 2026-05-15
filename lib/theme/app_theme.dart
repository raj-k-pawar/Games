import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const Color primaryPurple = Color(0xFF6C3CE1);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryPink = Color(0xFFEC4899);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color primaryYellow = Color(0xFFFBBF24);
  static const Color primaryRed = Color(0xFFEF4444);
  static const Color primaryCyan = Color(0xFF06B6D4);

  // Background
  static const Color bgDark = Color(0xFF0F0A1E);
  static const Color bgCard = Color(0xFF1A1035);
  static const Color bgCardLight = Color(0xFF241848);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFAA9FCC);
  static const Color textLight = Color(0xFFD4CAFE);

  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF6C3CE1), Color(0xFF9B59F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFBE185D), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0F0A1E), Color(0xFF1A0F3A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Subject colors
  static const Color mathColor = Color(0xFF3B82F6);
  static const Color scienceColor = Color(0xFF22C55E);
  static const Color historyColor = Color(0xFFF97316);
  static const Color logicColor = Color(0xFF9B59F5);
  static const Color codingColor = Color(0xFF06B6D4);
  static const Color financeColor = Color(0xFFFBBF24);
  static const Color englishColor = Color(0xFFEC4899);
  static const Color geographyColor = Color(0xFF10B981);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        secondary: AppColors.primaryBlue,
        surface: AppColors.bgCard,
        background: AppColors.bgDark,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w900),
          displayMedium: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w800),
          displaySmall: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: AppColors.textWhite),
          bodyMedium: TextStyle(color: AppColors.textLight),
          bodySmall: TextStyle(color: AppColors.textGray),
        ),
      ),
    );
  }
}

class AppDecorations {
  static BoxDecoration cardDecoration({
    Color? color,
    List<Color>? gradientColors,
    double radius = 20,
    bool glow = false,
    Color glowColor = AppColors.primaryPurple,
  }) {
    return BoxDecoration(
      color: gradientColors == null ? (color ?? AppColors.bgCard) : null,
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: glow
          ? [
              BoxShadow(
                color: glowColor.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      border: Border.all(
        color: (gradientColors?.first ?? color ?? AppColors.primaryPurple).withOpacity(0.3),
        width: 1.5,
      ),
    );
  }
}

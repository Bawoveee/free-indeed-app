import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A5C);
  static const Color royalBlue = Color(0xFF2C5F8A);
  static const Color lightBlue = Color(0xFFE8F1FA);
  static const Color gold = Color(0xFFD4A843);
  static const Color lightGold = Color(0xFFFDF3DC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGrey = Color(0xFFE9ECEF);
  static const Color grey = Color(0xFF6C757D);
  static const Color darkGrey = Color(0xFF343A40);
  static const Color success = Color(0xFF2D9B6F);
  static const Color error = Color(0xFFE05252);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.navyBlue,
    height: 1.3,
  );

  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.navyBlue,
  );

  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.navyBlue,
  );

  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.navyBlue,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    height: 1.5,
  );

  static TextStyle scripture = GoogleFonts.playfairDisplay(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.navyBlue,
    fontStyle: FontStyle.italic,
    height: 1.7,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    letterSpacing: 0.2,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navyBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.navyBlue.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
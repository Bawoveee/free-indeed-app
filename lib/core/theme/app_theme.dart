import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary dark Bible feel
  static const Color darkBrown = Color(0xFF1A0F0A);
  static const Color mediumBrown = Color(0xFF2C1810);
  static const Color lightBrown = Color(0xFF3D2314);

  // Gold accent
  static const Color gold = Color(0xFFD4A843);
  static const Color lightGold = Color(0xFFEDD9A3);
  static const Color paleGold = Color(0xFFF5ECD8);

  // Parchment
  static const Color parchment = Color(0xFFF5ECD8);
  static const Color parchmentDark = Color(0xFFEDD9A3);

  // Text
  static const Color textLight = Color(0xFFF5E6C8);
  static const Color textMuted = Color(0xFF8B6914);

  // Semantic
  static const Color success = Color(0xFF2D9B6F);
  static const Color error = Color(0xFFE05252);

  // Keep these for compatibility
  static const Color navyBlue = Color(0xFF1A0F0A);
  static const Color royalBlue = Color(0xFF2C1810);
  static const Color lightBlue = Color(0xFFEDD9A3);
  static const Color white = Color(0xFFF5E6C8);
  static const Color offWhite = Color(0xFFF5ECD8);
  static const Color lightGrey = Color(0xFFEDD9A3);
  static const Color grey = Color(0xFF8B6914);
  static const Color darkGrey = Color(0xFF2C1810);
  static const Color background = Color(0xFFF5ECD8);
  static const Color cardBackground = Color(0xFFEDD9A3);
}

class AppTextStyles {
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkBrown,
    height: 1.3,
  );

  static TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  static TextStyle heading2 = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
  );

  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBrown,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBrown,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static TextStyle scripture = GoogleFonts.playfairDisplay(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    fontStyle: FontStyle.italic,
    height: 1.8,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    letterSpacing: 0.3,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkBrown,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.parchment,
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.darkBrown,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.parchmentDark,
        elevation: 2,
        shadowColor: AppColors.darkBrown.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
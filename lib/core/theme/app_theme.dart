import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          error: AppColors.statusDoctor,
        ),
        textTheme: _buildTextTheme(
          AppColors.textWhite,
          AppColors.textSecondaryDark,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textWhite),
          titleTextStyle: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        inputDecorationTheme: _inputTheme(
          AppColors.darkCard,
          AppColors.darkBorder,
          AppColors.primary,
          AppColors.textSecondaryDark,
        ),
        dividerColor: AppColors.darkBorder,
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryDark,
          secondary: AppColors.secondaryDark,
          surface: AppColors.lightSurface,
          error: AppColors.statusDoctor,
        ),
        textTheme: _buildTextTheme(
          AppColors.textDark,
          AppColors.textSecondaryLight,
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textDark),
          titleTextStyle: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        inputDecorationTheme: _inputTheme(
          AppColors.lightCard,
          AppColors.lightBorder,
          AppColors.primaryDark,
          AppColors.textSecondaryLight,
        ),
        dividerColor: AppColors.lightBorder,
      );

  static InputDecorationTheme _inputTheme(
    Color fill,
    Color border,
    Color focus,
    Color label,
  ) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focus, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: label, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: label, fontSize: 14),
      );

  static TextTheme _buildTextTheme(Color primary, Color secondary) =>
      TextTheme(
        displayLarge: GoogleFonts.poppins(
            fontSize: 32, fontWeight: FontWeight.w800, color: primary),
        displayMedium: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.w700, color: primary),
        headlineLarge: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.w700, color: primary),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.w600, color: primary),
        titleLarge: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: primary),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: primary),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w400, color: primary),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w400, color: secondary),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: primary),
        labelSmall: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w500, color: secondary),
      );
}

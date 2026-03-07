import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark Mode Backgrounds ───────────────────────────────────────────────
  static const Color darkBg = Color(0xFF0A0B1A);
  static const Color darkSurface = Color(0xFF12142A);
  static const Color darkCard = Color(0xFF1A1D38);
  static const Color darkCardAlt = Color(0xFF222540);
  static const Color darkBorder = Color(0x33FFFFFF);

  // ── Light Mode Backgrounds ──────────────────────────────────────────────
  static const Color lightBg = Color(0xFFF0EFF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFF5F4FD);
  static const Color lightBorder = Color(0xFFE0DDEF);

  // ── Primary — Purple ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7C5CBF);
  static const Color primaryLight = Color(0xFF9B7DD4);
  static const Color primaryDark = Color(0xFF5A3D9E);

  // ── Secondary — Cyan ────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF5BC4E8);
  static const Color secondaryDark = Color(0xFF3A8FBF);

  // ── Status ──────────────────────────────────────────────────────────────
  static const Color statusHealthy = Color(0xFF4CE8A0);
  static const Color statusMonitor = Color(0xFFE8D45B);
  static const Color statusDoctor = Color(0xFFE8825B);
  static const Color statusDanger = Color(0xFFE85B5B);

  // ── Gradients ───────────────────────────────────────────────────────────
  static const List<Color> gradientPurple = [Color(0xFF9B7DD4), Color(0xFF5A3D9E)];
  static const List<Color> gradientCyan = [Color(0xFF5BC4E8), Color(0xFF2C7EA8)];
  static const List<Color> gradientBlue = [Color(0xFF5BC4E8), Color(0xFF7C5CBF)];
  static const List<Color> gradientGreen = [Color(0xFF4CE8A0), Color(0xFF1A9E6A)];
  static const List<Color> gradientWarm = [Color(0xFFE8D45B), Color(0xFFE8825B)];
  static const List<Color> gradientCard = [Color(0xFF262944), Color(0xFF1A1D38)];

  // ── Glassmorphism ───────────────────────────────────────────────────────
  static const Color glassDark = Color(0x1AFFFFFF);
  static const Color glassLight = Color(0x99FFFFFF);
  static const Color glassBorderDark = Color(0x33FFFFFF);
  static const Color glassBorderLight = Color(0x80FFFFFF);

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textWhite70 = Color(0xB3FFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textSecondaryDark = Color(0xFF9899B3);
  static const Color textSecondaryLight = Color(0xFF6B6B8B);
}

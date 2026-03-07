import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/theme_provider.dart';
import '../../widgets/eye_logo.dart';
import '../dashboard/dashboard_screen.dart';
import '../medication/medication_screen.dart';
import '../eye_pressure/eye_pressure_screen.dart';
import '../education/education_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      DashboardScreen(
          onNavigateToTab: (i) => setState(() => _currentIndex = i)),
      const MedicationScreen(),
      const EyePressureScreen(),
      const EducationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      extendBody: true,
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: _buildAppBar(isDark, themeProvider),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _FloatingBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        isDark: isDark,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      bool isDark, ThemeProvider themeProvider) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      title: Row(
        children: [
          // Logo — no background box, colour adapts to theme
          GlaucoEyeLogo(
            width: 48,
            height: 28,
            eyeColor: isDark ? Colors.white : AppColors.primaryDark,
            bgColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          ),
          const SizedBox(width: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primaryLight, AppColors.secondary],
            ).createShader(bounds),
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Health status chip
        _HealthStatusChip(isDark: isDark),
        const SizedBox(width: 6),
        // Theme toggle
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCard
                : AppColors.lightCardAlt,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                key: ValueKey(isDark),
                color: isDark
                    ? AppColors.statusMonitor
                    : AppColors.primaryDark,
                size: 20,
              ),
            ),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          ),
        ),
      ],
    );
  }
}

class _HealthStatusChip extends StatelessWidget {
  final bool isDark;
  const _HealthStatusChip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.statusHealthy.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.statusHealthy.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.statusHealthy,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            AppStrings.statusHealthy,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.statusHealthy,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Floating Glass Bottom Navigation Bar ───────────────────────────────────

class _FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _FloatingBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  static const _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: AppStrings.navDashboard),
    _NavItem(icon: Icons.medication_rounded, label: AppStrings.navMedication),
    _NavItem(icon: Icons.water_drop_rounded, label: AppStrings.navPressure),
    _NavItem(icon: Icons.menu_book_rounded, label: AppStrings.navEducation),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xCC1A1D38)
                  : const Color(0xCCFFFFFF),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: List.generate(_items.length, (i) {
                final selected = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _items[i].icon,
                              size: 22,
                              color: selected
                                  ? AppColors.primaryLight
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _items[i].label,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: selected
                                  ? AppColors.primaryLight
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─── Shared helper accessible from all screens ──────────────────────────────
const double kBottomNavHeight = 100.0;

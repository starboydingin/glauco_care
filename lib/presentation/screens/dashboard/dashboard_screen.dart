import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/iop_provider.dart';
import '../../widgets/gradient_card.dart';
import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int)? onNavigateToTab;
  const DashboardScreen({super.key, this.onNavigateToTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iop = context.watch<IopProvider>();
    final isNormal = iop.latest.right <= 21 && iop.latest.left <= 21;
    final badgeColor =
        isNormal ? AppColors.statusHealthy : AppColors.statusDoctor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textWhite : AppColors.textDark;
    final textSec =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          kBottomNavHeight,
        ),
        children: [
          // ── Greeting ──────────────────────────────────────────────
          _Greeting(textPrimary: textPrimary, textSec: textSec),
          const SizedBox(height: 20),

          // ── IOP Gradient Card ──────────────────────────────────────
          GradientCard(
            colors: AppColors.gradientPurple,
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop_rounded,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.latestIOP,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        isNormal ? 'Normal' : 'Tinggi',
                        style: TextStyle(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _IOPValue(
                        label: AppStrings.rightEye,
                        value: iop.latest.right.toString(),
                        unit: 'mmHg'),
                    const SizedBox(width: 24),
                    Container(
                        width: 1, height: 48, color: Colors.white24),
                    const SizedBox(width: 24),
                    _IOPValue(
                        label: AppStrings.leftEye,
                        value: iop.latest.left.toString(),
                        unit: 'mmHg'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.normalRange,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Weekly Trend Chart ──────────────────────────────────────
          _ChartCard(
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
            records: iop.last7,
          ),
          const SizedBox(height: 16),

          // ── Stats Row ──────────────────────────────────────────────
          Row(children: [
            Expanded(
              child: _StatCard(
                isDark: isDark,
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.statusHealthy,
                label: AppStrings.medicationAdherence,
                value: '85%',
                subtitle: 'Minggu ini',
                gradientColors: AppColors.gradientGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                isDark: isDark,
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.secondary,
                label: 'Pemeriksaan',
                value: '15 Hari',
                subtitle: 'Lagi',
                gradientColors: AppColors.gradientCyan,
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Quick Actions ───────────────────────────────────────────
          Text(
            AppStrings.quickActions,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary),
          ),
          const SizedBox(height: 12),
          _QuickActionsGrid(
            isDark: isDark,
            onTab: widget.onNavigateToTab,
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  final Color textPrimary;
  final Color textSec;
  const _Greeting({required this.textPrimary, required this.textSec});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Selamat Pagi'
        : hour < 17
            ? 'Selamat Siang'
            : 'Selamat Malam';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Pengguna!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'id').format(now),
                style: TextStyle(fontSize: 13, color: textSec),
              ),
            ],
          ),
        ),

      ],
    );
  }
}

class _IOPValue extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _IOPValue(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final List<IopRecord> records;

  const _ChartCard({
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final rightSpots = records
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.right.toDouble()))
        .toList();
    final leftSpots = records
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.left.toDouble()))
        .toList();
    final maxX = (records.length - 1).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(AppStrings.weeklyTrend,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary)),
            const Spacer(),
            _ChartLegend(color: AppColors.primaryLight, label: 'Kanan'),
            const SizedBox(width: 12),
            _ChartLegend(color: AppColors.secondary, label: 'Kiri'),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: 10,
                maxY: 26,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 4,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= records.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(records[idx].date,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: textSec,
                                  fontWeight: FontWeight.w500)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 4,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(fontSize: 10, color: textSec),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildLine(rightSpots, AppColors.primaryLight,
                      AppColors.primary),
                  _buildLine(leftSpots, AppColors.secondary,
                      AppColors.secondaryDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLine(
      List<FlSpot> spots, Color color, Color dotBorder) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) =>
            FlDotCirclePainter(
          radius: 4,
          color: Colors.white,
          strokeWidth: 2,
          strokeColor: dotBorder,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textSecondaryDark)),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final List<Color> gradientColors;

  const _StatCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                )
              ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 12),
        Text(value,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        const SizedBox(height: 2),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondaryDark)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryDark)),
      ]),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final bool isDark;
  final void Function(int)? onTab;
  const _QuickActionsGrid({required this.isDark, this.onTab});

  static const _actions = [
    _Action(
        icon: Icons.water_drop_rounded,
        label: 'Catat\nTekanan',
        gradient: AppColors.gradientPurple,
        tabIndex: 3),
    _Action(
        icon: Icons.medication_rounded,
        label: 'Log\nObat',
        gradient: AppColors.gradientCyan,
        tabIndex: 1),
    _Action(
        icon: Icons.quiz_rounded,
        label: 'Asesmen\nGejala',
        gradient: AppColors.gradientGreen,
        tabIndex: 2),
    _Action(
        icon: Icons.menu_book_rounded,
        label: 'Edukasi\nMata',
        gradient: AppColors.gradientWarm,
        tabIndex: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _actions
          .map((a) => _QuickActionItem(action: a, onTab: onTab))
          .toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final _Action action;
  final void Function(int)? onTab;
  const _QuickActionItem({required this.action, this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTab?.call(action.tabIndex),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: action.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: action.gradient.first.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(action.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final int tabIndex;
  const _Action(
      {required this.icon,
      required this.label,
      required this.gradient,
      required this.tabIndex});
}

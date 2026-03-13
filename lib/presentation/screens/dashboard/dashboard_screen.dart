import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/iop_provider.dart';
import '../../../core/providers/medication_provider.dart';
import '../../widgets/gradient_card.dart';
import '../assessment/assessment_screen.dart';
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
    final medProvider = context.watch<MedicationProvider>();
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

          // ── Med Log Card ────────────────────────────────────────────
          _MedLogCard(
            med: medProvider,
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
            onViewAll: () => widget.onNavigateToTab?.call(1),
          ),
          const SizedBox(height: 16),

          // ── Self-Assessment CTA ──────────────────────────────────────
          _AssessmentCtaCard(
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
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

// ─── Med Log Card ────────────────────────────────────────────────────────────

class _MedLogCard extends StatelessWidget {
  final MedicationProvider med;
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onViewAll;

  const _MedLogCard({
    required this.med,
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final meds = med.medications;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1DE9B6), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.medication_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'Log Obat Hari Ini',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'Lihat Semua',
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ]),
        const SizedBox(height: 14),

        // Progress row
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: med.totalCount == 0
                    ? 0
                    : med.takenCount / med.totalCount,
                backgroundColor: isDark
                    ? AppColors.darkCardAlt
                    : AppColors.lightCardAlt,
                valueColor: const AlwaysStoppedAnimation(
                    AppColors.statusHealthy),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${med.takenCount}/${med.totalCount} obat',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textSec),
          ),
        ]),
        const SizedBox(height: 14),

        if (meds.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Belum ada jadwal obat hari ini.',
              style: TextStyle(fontSize: 13, color: textSec),
            ),
          )
        else
          ...meds.take(3).map((m) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: m.taken
                        ? AppColors.statusHealthy
                        : Colors.transparent,
                    border: Border.all(
                      color: m.taken
                          ? AppColors.statusHealthy
                          : (isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade400),
                      width: 2,
                    ),
                  ),
                  child: m.taken
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 13)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    m.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: m.taken ? textSec : textPrimary,
                      decoration: m.taken
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: textSec,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    m.time,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.secondary
                          : const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ]),
            );
          }),
        if (meds.length > 3) ...[
          const SizedBox(height: 2),
          Text(
            '+${meds.length - 3} obat lainnya',
            style: const TextStyle(
                fontSize: 12, color: AppColors.primary),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: med.takenCount == med.totalCount && med.totalCount > 0
                ? AppColors.statusHealthy.withValues(alpha: 0.10)
                : AppColors.statusMonitor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: med.takenCount == med.totalCount && med.totalCount > 0
                  ? AppColors.statusHealthy.withValues(alpha: 0.3)
                  : AppColors.statusMonitor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(children: [
            Icon(
              med.takenCount == med.totalCount && med.totalCount > 0
                  ? Icons.check_circle_rounded
                  : Icons.info_outline_rounded,
              size: 14,
              color: med.takenCount == med.totalCount && med.totalCount > 0
                  ? AppColors.statusHealthy
                  : AppColors.statusMonitor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                med.takenCount == med.totalCount && med.totalCount > 0
                    ? 'Semua obat hari ini sudah diminum!'
                    : 'Masih ada ${med.totalCount - med.takenCount} obat yang belum diminum.',
                style: TextStyle(
                  fontSize: 12,
                  color: med.takenCount == med.totalCount &&
                          med.totalCount > 0
                      ? AppColors.statusHealthy
                      : AppColors.statusMonitor,
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Assessment CTA Card ─────────────────────────────────────────────────────

class _AssessmentCtaCard extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;
  final Color textSec;

  const _AssessmentCtaCard({
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.gradientGreen,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.remove_red_eye_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Cek Kondisi Mata Hari Ini',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textPrimary),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text(
          'Yuk cek kondisi mata kamu hari ini dengan kuis singkat! Hanya butuh 1 menit kok 😊',
          style: TextStyle(fontSize: 13, color: textSec, height: 1.5),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const AssessmentScreen(
                        standalone: true,
                      )),
            );
          },
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.gradientGreen,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.statusHealthy.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Mulai Self-Assessment',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ]),
    );
  }
}

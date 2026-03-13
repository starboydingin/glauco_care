import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/iop_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../home/home_screen.dart';

class EyePressureScreen extends StatefulWidget {
  const EyePressureScreen({super.key});

  @override
  State<EyePressureScreen> createState() => _EyePressureScreenState();
}

class _EyePressureScreenState extends State<EyePressureScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  DateTime _selectedDate = DateTime.now();
  final _rightController = TextEditingController();
  final _leftController = TextEditingController();
  final _notesController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: DateFormat('dd MMM yyyy', 'id').format(_selectedDate),
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    _dateController.dispose();
    _rightController.dispose();
    _leftController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      final rightVal =
          double.tryParse(_rightController.text.trim())?.round() ?? 0;
      final leftVal =
          double.tryParse(_leftController.text.trim())?.round() ?? 0;
      final dateLabel = DateFormat('dd/MM', 'id').format(_selectedDate);

      context.read<IopProvider>().addRecord(
        IopRecord(date: dateLabel, right: rightVal, left: leftVal),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.statusHealthy,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Rekaman berhasil disimpan!',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ]),
        ),
      );
      _rightController.clear();
      _leftController.clear();
      _notesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = context.watch<IopProvider>().records;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textWhite : AppColors.textDark;
    final textSec =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor =
        isDark ? AppColors.darkCard : AppColors.lightCard;

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        padding:
            EdgeInsets.fromLTRB(20, 16, 20, kBottomNavHeight),
        children: [
          // ── Header ────────────────────────────────────────────────
          Text(AppStrings.pressureTitle,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary)),
          const SizedBox(height: 4),
          Text('Input hasil pemeriksaan dari dokter',
              style: TextStyle(fontSize: 13, color: textSec)),
          const SizedBox(height: 20),

          // ── Input Form Card ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
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
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.gradientPurple,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(AppStrings.addRecord,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary)),
                    ]),
                    const SizedBox(height: 18),

                    // Date picker
                    _FormLabel(
                        label: AppStrings.examDate, textSec: textSec),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  surface: isDark
                                      ? AppColors.darkSurface
                                      : Colors.white,
                                  onSurface: textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                          _dateController.text =
                              DateFormat('dd MMM yyyy', 'id').format(picked);
                        }
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today_rounded,
                            color: AppColors.primary, size: 18),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Right + Left eye row
                    Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FormLabel(
                                  label: 'Mata Kanan (mmHg)',
                                  textSec: textSec),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _rightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'e.g. 18',
                                  prefixIcon: Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: AppColors.primaryLight,
                                      size: 18),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Wajib diisi';
                                  }
                                  final val = double.tryParse(v);
                                  if (val == null || val < 0 || val > 80) {
                                    return 'Nilai tidak valid';
                                  }
                                  return null;
                                },
                              ),
                            ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FormLabel(
                                  label: 'Mata Kiri (mmHg)',
                                  textSec: textSec),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _leftController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'e.g. 17',
                                  prefixIcon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: AppColors.secondary,
                                      size: 18),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Wajib diisi';
                                  }
                                  final val = double.tryParse(v);
                                  if (val == null || val < 0 || val > 80) {
                                    return 'Nilai tidak valid';
                                  }
                                  return null;
                                },
                              ),
                            ]),
                      ),
                    ]),
                    const SizedBox(height: 14),

                    // Doctor notes
                    _FormLabel(
                        label: AppStrings.doctorNotes, textSec: textSec),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Tulis catatan dari dokter (opsional)...',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save button
                    GestureDetector(
                      onTap: _saveRecord,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.gradientPurple,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.save_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(AppStrings.saveRecord,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 24),

          // ── Pressure Trend Chart ──────────────────────────────────
          Text(AppStrings.pressureTrend,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
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
            child: Column(children: [
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 10,
                runSpacing: 4,
                children: [
                  _ChartLegend(
                      color: AppColors.primaryLight, label: 'Kanan'),
                  _ChartLegend(
                      color: AppColors.secondary, label: 'Kiri'),
                  // Normal range line
                  _ChartLegend(
                      color: AppColors.statusDoctor.withValues(alpha: 0.7),
                      label: 'Batas normal',
                      dashed: true),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: records.length.toDouble() - 1,
                    minY: 10,
                    maxY: 28,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 4,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
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
                                      fontSize: 9,
                                      color: textSec,
                                      fontWeight: FontWeight.w500)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 4,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}',
                            style: TextStyle(fontSize: 9, color: textSec),
                          ),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Right eye
                      _buildLine(
                          records
                              .asMap()
                              .entries
                              .map((e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.right.toDouble()))
                              .toList(),
                          AppColors.primaryLight,
                          AppColors.primary),
                      // Left eye
                      _buildLine(
                          records
                              .asMap()
                              .entries
                              .map((e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.left.toDouble()))
                              .toList(),
                          AppColors.secondary,
                          AppColors.secondaryDark),
                      // Normal upper limit reference line
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 21),
                          FlSpot(records.length.toDouble() - 1, 21),
                        ],
                        isCurved: false,
                        color: AppColors.statusDoctor
                            .withValues(alpha: 0.5),
                        barWidth: 1.5,
                        dotData: const FlDotData(show: false),
                        dashArray: [6, 4],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.statusMonitor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: const [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.statusMonitor, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Garis merah putus-putus = batas normal 21 mmHg',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.statusMonitor),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Records List ───────────────────────────────────────────
          Text('Riwayat Rekaman',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary)),
          const SizedBox(height: 12),
          ...records.reversed
              .take(5)
              .map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _RecordTile(
                      record: r,
                      isDark: isDark,
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textSec: textSec,
                    ),
                  )),
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
            color.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String label;
  final Color textSec;
  const _FormLabel({required this.label, required this.textSec});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textSec));
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;
  const _ChartLegend(
      {required this.color, required this.label, this.dashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 10, color: AppColors.textSecondaryDark)),
    ]);
  }
}

class _RecordTile extends StatelessWidget {
  final IopRecord record;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textSec;

  const _RecordTile({
    required this.record,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textSec,
  });

  @override
  Widget build(BuildContext context) {
    final isNormal = record.right <= 21 && record.left <= 21;
    final statusColor =
        isNormal ? AppColors.statusHealthy : AppColors.statusDoctor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(record.date,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(children: [
            _EyeValue(
                icon: Icons.remove_red_eye_rounded,
                color: AppColors.primaryLight,
                value: record.right),
            const SizedBox(width: 16),
            _EyeValue(
                icon: Icons.remove_red_eye_outlined,
                color: AppColors.secondary,
                value: record.left),
          ]),
        ),
        Icon(
          isNormal
              ? Icons.check_circle_rounded
              : Icons.warning_rounded,
          color: statusColor,
          size: 18,
        ),
      ]),
    );
  }
}

class _EyeValue extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  const _EyeValue(
      {required this.icon, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 4),
      Text('$value',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color)),
      const Text(' mmHg',
          style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondaryDark)),
    ]);
  }
}



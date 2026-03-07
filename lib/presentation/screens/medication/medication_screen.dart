import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

//  Data model 

class _MedItem {
  String name;
  String time; // "HH:mm"
  String note;
  bool taken = false;

  _MedItem({
    required this.name,
    required this.time,
    this.note = '',
  });
}

//  Screen 

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen>
    with SingleTickerProviderStateMixin {
  final List<_MedItem> _medications = [
    _MedItem(name: 'Timolol 0.5%', time: '08:00', note: 'Mata kiri & kanan'),
    _MedItem(name: 'Latanoprost 0.005%', time: '14:00', note: 'Mata kiri'),
    _MedItem(name: 'Timolol 0.5%', time: '20:00', note: 'Mata kiri & kanan'),
  ];

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int get _takenCount => _medications.where((m) => m.taken).length;
  int get _totalCount => _medications.length;
  int get _percentage =>
      _totalCount == 0 ? 0 : ((_takenCount / _totalCount) * 100).round();

  void _toggleMed(int index) {
    setState(() => _medications[index].taken = !_medications[index].taken);
  }

  Future<void> _showAddDialog() async {
    final nameCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final labelStyle = TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textWhite : AppColors.textDark,
          );
          final fieldColor = isDark
              ? AppColors.darkCardAlt
              : const Color(0xFFF5F5F5);

          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 8, 4),
            contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tambah Jadwal Obat Baru',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textWhite : AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : Colors.grey),
                  onPressed: () => Navigator.pop(ctx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Nama Obat
                Text('Nama Obat', style: labelStyle),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Timolol 0.5%',
                    hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey),
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                  ),
                ),
                const SizedBox(height: 16),

                // Waktu
                Text('Waktu', style: labelStyle),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.now(),
                    );
                    if (t != null) setDlgState(() => selectedTime = t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedTime == null
                              ? '--:--'
                              : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 15,
                            color: selectedTime == null
                                ? Colors.grey
                                : (isDark
                                    ? AppColors.textWhite
                                    : AppColors.textDark),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.access_time_rounded,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Catatan
                Text('Catatan (Opsional)', style: labelStyle),
                const SizedBox(height: 8),
                TextField(
                  controller: noteCtrl,
                  style: TextStyle(
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Mata kiri & kanan',
                    hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey),
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                  ),
                ),
                const SizedBox(height: 22),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1DE9B6), Color(0xFF1565C0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.trim().isNotEmpty &&
                            selectedTime != null) {
                          setState(() {
                            _medications.add(_MedItem(
                              name: nameCtrl.text.trim(),
                              time:
                                  '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                              note: noteCtrl.text.trim(),
                            ));
                            _medications
                                .sort((a, b) => a.time.compareTo(b.time));
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text(
                        'Tambah Jadwal',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textWhite : AppColors.textDark;
    final textSec =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final remaining = _totalCount - _takenCount;

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 16, 20, kBottomNavHeight),
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log Obat',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Catat penggunaan obat harian',
                    style: TextStyle(fontSize: 13, color: textSec),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showAddDialog,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1DE9B6), Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DE9B6).withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1DE9B6), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progress Hari Ini',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$_takenCount',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5, left: 3),
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '$_totalCount',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        remaining == 0
                            ? 'Semua obat sudah diminum!'
                            : '$remaining obat belum diminum',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(alignment: Alignment.center, children: [
                    CircularProgressIndicator(
                      value: _totalCount == 0
                          ? 0
                          : _takenCount / _totalCount,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 7,
                    ),
                    Text(
                      '$_percentage%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Jadwal Hari Ini title
          Text(
            'Jadwal Hari Ini',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textPrimary),
          ),
          const SizedBox(height: 12),

          if (_medications.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(children: [
                Icon(Icons.medication_outlined, size: 40, color: textSec),
                const SizedBox(height: 10),
                Text(
                  'Belum ada jadwal obat.',
                  style: TextStyle(
                      color: textSec, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ketuk + untuk menambahkan',
                  style: TextStyle(fontSize: 12, color: textSec),
                ),
              ]),
            )
          else
            ..._medications.asMap().entries.map((entry) {
              final idx = entry.key;
              final med = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MedTile(
                  med: med,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSec: textSec,
                  onToggle: () => _toggleMed(idx),
                  onDelete: () => setState(() => _medications.removeAt(idx)),
                ),
              );
            }),
        ],
      ),
    );
  }
}

//  Med Tile 

class _MedTile extends StatelessWidget {
  final _MedItem med;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _MedTile({
    required this.med,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSec,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const takenLightBg = Color(0xFFF0FBF5);
    const takenLightBorder = Color(0xFF81C784);
    const timeLightBg = Color(0xFFE3F2FD);
    const timeLightColor = Color(0xFF1565C0);

    final timeBg = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : (med.taken
            ? AppColors.statusHealthy.withValues(alpha: 0.12)
            : timeLightBg);
    final timeColor = isDark ? AppColors.secondary : timeLightColor;

    return Dismissible(
      key: ValueKey('${med.name}_${med.time}_${med.note}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 26),
      ),
      onDismissed: (_) => onDelete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: med.taken
              ? (isDark ? const Color(0xFF0D2916) : takenLightBg)
              : cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: med.taken
                ? (isDark
                    ? AppColors.statusHealthy.withValues(alpha: 0.4)
                    : takenLightBorder)
                : borderColor,
            width: 1.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Checkbox circle
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: med.taken
                      ? AppColors.statusHealthy
                      : Colors.transparent,
                  border: Border.all(
                    color: med.taken
                        ? AppColors.statusHealthy
                        : (isDark
                            ? AppColors.darkBorder
                            : Colors.grey.shade400),
                    width: 2,
                  ),
                  boxShadow: med.taken
                      ? [
                          BoxShadow(
                            color: AppColors.statusHealthy
                                .withValues(alpha: 0.35),
                            blurRadius: 8,
                          )
                        ]
                      : [],
                ),
                child: med.taken
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 17)
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // Name + note
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: med.taken ? textSec : textPrimary,
                      decoration: med.taken
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: textSec,
                      decorationThickness: 2,
                    ),
                  ),
                  if (med.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      med.note,
                      style: TextStyle(
                        fontSize: 12,
                        color: med.taken
                            ? AppColors.statusHealthy
                            : textSec,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Time chip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: timeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 12, color: timeColor),
                  const SizedBox(width: 4),
                  Text(
                    med.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: timeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

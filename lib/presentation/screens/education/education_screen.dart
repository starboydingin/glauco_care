import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../home/home_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  int _selectedCategory = 0;
  int? _expandedCard;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _categories = ['Semua', 'Penyakit', 'Obat', 'Tips'];

  static const List<_EduCard> _eduCards = [
    _EduCard(
      icon: Icons.remove_red_eye_rounded,
      title: 'Apa itu Glaukoma?',
      subtitle: 'Penyakit mata yang merusak saraf optik',
      category: 'Penyakit',
      gradient: AppColors.gradientPurple,
      content:
          'Glaukoma adalah penyakit mata kronis akibat kerusakan saraf optik, sering berkaitan dengan peningkatan tekanan intraokular. Gangguan terjadi karena hambatan aliran keluar cairan mata (aqueous humor). Tanpa penanganan, dapat menyebabkan penyempitan lapang pandang hingga kebutaan permanen. Glaukoma disebut “silent thief of sight” karena sering tidak bergejala di tahap awal.',
    ),
    _EduCard(
      icon: Icons.warning_amber_rounded,
      title: 'Faktor Risiko',
      subtitle: 'Siapa yang lebih berisiko terkena glaukoma?',
      category: 'Penyakit',
      gradient: AppColors.gradientWarm,
      content:
          'Faktor risiko glaukoma meliputi: usia >40 tahun, riwayat keluarga dengan glaukoma, tekanan intraokular tinggi (>21 mmHg), diabetes mellitus, hipertensi, penyakit kardiovaskular, penggunaan kortikosteroid jangka panjang, riwayat cedera mata, dan kelainan anatomi mata tertentu. Pemeriksaan mata berkala sangat dianjurkan bagi yang memiliki faktor risiko tersebut.',
    ),
    _EduCard(
      icon: Icons.sick_rounded,
      title: 'Gejala Glaukoma',
      subtitle: 'Kenali tanda-tanda awal glaukoma',
      category: 'Penyakit',
      gradient: [Color(0xFFE85B5B), Color(0xFFBF3030)],
      content:
          'Glaukoma kronis sering tidak bergejala di awal. Gejala yang dapat muncul: penglihatan kabur, penyempitan lapang pandang (tunnel vision), melihat lingkaran cahaya (halo) di sekitar lampu, mata nyeri atau berat, serta sakit kepala. Pada glaukoma sudut tertutup akut, gejala muncul mendadak dengan nyeri hebat, mata merah, dan mual — ini merupakan kegawatdaruratan medis.',
    ),
    _EduCard(
      icon: Icons.medication_rounded,
      title: 'Kepatuhan Penggunaan Obat',
      subtitle: 'Mengapa konsistensi minum obat sangat penting?',
      category: 'Obat',
      gradient: AppColors.gradientCyan,
      content:
          'Terapi glaukoma bertujuan menurunkan tekanan intraokular untuk mencegah kerusakan saraf optik lebih lanjut. Obat tetes mata bekerja dengan mengurangi produksi atau meningkatkan aliran keluar cairan mata. Penggunaan harus sesuai dosis, jadwal, dan dilakukan rutin setiap hari. Ketidakpatuhan dapat menyebabkan tekanan mata kembali meningkat dan mempercepat penurunan penglihatan.',
    ),
    _EduCard(
      icon: Icons.event_available_rounded,
      title: 'Pentingnya Kontrol Rutin',
      subtitle: 'Jadwal pemeriksaan mata yang dianjurkan',
      category: 'Tips',
      gradient: AppColors.gradientGreen,
      content:
          'Karena glaukoma sering berkembang tanpa gejala, pemeriksaan mata rutin sangat penting untuk deteksi dini. Pemeriksaan meliputi: tonometri (tekanan intraokular), penilaian saraf optik, pemeriksaan lapang pandang (perimetri), dan imaging struktur mata. Deteksi dini memungkinkan pengobatan lebih cepat dan mempertahankan kualitas penglihatan lebih lama.',
    ),
    _EduCard(
      icon: Icons.quiz_rounded,
      title: 'Apakah Glaukoma Bisa Disembuhkan?',
      subtitle: 'Pertanyaan yang sering ditanyakan',
      category: 'Tips',
      gradient: [Color(0xFF5A3D9E), Color(0xFF3D2870)],
      content:
          'Glaukoma tidak dapat disembuhkan sepenuhnya karena kerusakan saraf optik bersifat permanen. Namun, penyakit ini dapat dikontrol melalui: obat tetes mata rutin, pemeriksaan berkala, serta tindakan laser atau operasi bila diperlukan. Tujuan terapi adalah menurunkan tekanan intraokular, memperlambat progresivitas, dan mempertahankan fungsi penglihatan. Dengan pengobatan tepat dan kepatuhan pasien, penderita glaukoma tetap dapat menjalani aktivitas sehari-hari dengan baik.',
    ),
  ];

  static const List<_SideEffectCard> _sideEffects = [
    _SideEffectCard(
      name: 'Timolol',
      category: 'Beta-blocker topikal',
      gradient: AppColors.gradientPurple,
      icon: Icons.medication_liquid_rounded,
      effects: [
        _Effect(
            icon: Icons.water_drop_outlined,
            label: 'Iritasi / rasa tidak nyaman pada mata',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.local_fire_department_outlined,
            label: 'Sensasi terbakar ringan',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.local_drink_outlined,
            label: 'Mata kering',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.visibility_off_outlined,
            label: 'Penglihatan kabur sementara',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.favorite_border_rounded,
            label: 'Bradikardia / penurunan denyut jantung',
            severity: 'Perlu Perhatian'),
        _Effect(
            icon: Icons.air_rounded,
            label: 'Sesak napas (risiko asma / PPOK)',
            severity: 'Perlu Perhatian'),
        _Effect(
            icon: Icons.battery_0_bar_rounded,
            label: 'Kelelahan dan pusing',
            severity: 'Ringan'),
      ],
    ),
    _SideEffectCard(
      name: 'Latanoprost',
      category: 'Prostaglandin analog',
      gradient: AppColors.gradientCyan,
      icon: Icons.science_rounded,
      effects: [
        _Effect(
            icon: Icons.remove_red_eye_rounded,
            label: 'Mata merah (hiperemia konjungtiva)',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.local_fire_department_outlined,
            label: 'Sensasi terbakar / iritasi ringan',
            severity: 'Ringan'),
        _Effect(
            icon: Icons.spa_outlined,
            label: 'Pertumbuhan bulu mata lebih panjang',
            severity: 'Kosmetik'),
        _Effect(
            icon: Icons.palette_outlined,
            label: 'Perubahan warna iris (penggelapan)',
            severity: 'Permanen'),
        _Effect(
            icon: Icons.dark_mode_outlined,
            label: 'Penggelapan kulit kelopak mata',
            severity: 'Kosmetik'),
        _Effect(
            icon: Icons.warning_amber_rounded,
            label: 'Edema makula (jarang)',
            severity: 'Perlu Perhatian'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose();
    super.dispose();
  }

  List<_EduCard> get _filteredCards {
    final query = _searchController.text.toLowerCase();
    final byCategory = _selectedCategory == 0
        ? _eduCards
        : _eduCards
            .where((c) => c.category == _categories[_selectedCategory])
            .toList();
    if (query.isEmpty) return byCategory;
    return byCategory
        .where((c) =>
            c.title.toLowerCase().contains(query) ||
            c.subtitle.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(AppStrings.educationTitle,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary)),
          const SizedBox(height: 4),
          Text(AppStrings.educationSubtitle,
              style: TextStyle(fontSize: 13, color: textSec)),
          const SizedBox(height: 16),

          // ── Search Bar ────────────────────────────────────────────
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari topik...',
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.primary, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear_rounded,
                          size: 18),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),

          // ── Category Chips ─────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_categories.length, (i) {
                final selected = i == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: AppColors.gradientPurple,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: selected
                            ? null
                            : (isDark
                                ? AppColors.darkCard
                                : AppColors.lightCardAlt),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                        ),
                      ),
                      child: Text(
                        _categories[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected ? Colors.white : textSec,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Education Cards ────────────────────────────────────────
          ..._buildEduCards(
              isDark, cardColor, textPrimary, textSec),
          const SizedBox(height: 24),

          // ── Side Effects Section ───────────────────────────────────
          Row(children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                  color: AppColors.statusDoctor,
                  borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 10),
            Text('Efek Samping Obat',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary)),
          ]),
          const SizedBox(height: 6),
          Text(
            'Kenali efek samping yang mungkin terjadi dari obat glaukoma',
            style: TextStyle(fontSize: 12, color: textSec),
          ),
          const SizedBox(height: 14),
          ..._sideEffects
              .map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _SideEffectCardWidget(
                      data: s,
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

  List<Widget> _buildEduCards(bool isDark, Color cardColor,
      Color textPrimary, Color textSec) {
    final filtered = _filteredCards;
    if (filtered.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(children: [
              Icon(Icons.search_off_rounded,
                  size: 48,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              const SizedBox(height: 12),
              Text('Tidak ada hasil ditemukan',
                  style: TextStyle(fontSize: 14, color: textSec)),
            ]),
          ),
        ),
      ];
    }
    return List.generate(filtered.length, (i) {
      final card = filtered[i];
      final isExpanded = _expandedCard == i;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _EduCardWidget(
          card: card,
          isExpanded: isExpanded,
          isDark: isDark,
          cardColor: cardColor,
          textPrimary: textPrimary,
          textSec: textSec,
          onTap: () =>
              setState(() => _expandedCard = isExpanded ? null : i),
        ),
      );
    });
  }
}

// ─── Education Card Widget ───────────────────────────────────────────────────

class _EduCardWidget extends StatelessWidget {
  final _EduCard card;
  final bool isExpanded;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onTap;

  const _EduCardWidget({
    required this.card,
    required this.isExpanded,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textSec,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? AppColors.primary.withValues(alpha: 0.4)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                  )
                ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Card header  
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: card.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(card.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textPrimary)),
                      const SizedBox(height: 3),
                      Text(card.subtitle,
                          style: TextStyle(
                              fontSize: 12, color: textSec)),
                    ]),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary, size: 22),
              ),
            ]),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    const SizedBox(height: 8),
                    Text(card.content,
                        style: TextStyle(
                            fontSize: 13,
                            color: textSec,
                            height: 1.6)),
                  ]),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ]),
      ),
    );
  }
}

// ─── Side Effect Card Widget ─────────────────────────────────────────────────

class _SideEffectCardWidget extends StatelessWidget {
  final _SideEffectCard data;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textSec;

  const _SideEffectCardWidget({
    required this.data,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textSec,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                )
              ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header with gradient
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: data.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(children: [
            Icon(data.icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              Text(data.category,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70)),
            ]),
          ]),
        ),
        // Effects list
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: data.effects.map((e) {
              final severityColor = e.severity == 'Perlu Perhatian'
                  ? AppColors.statusDoctor
                  : e.severity == 'Permanen'
                      ? AppColors.statusDanger
                      : e.severity == 'Kosmetik'
                          ? AppColors.secondary
                          : AppColors.statusMonitor.withValues(alpha: 0.8);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(e.icon, color: severityColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(e.label,
                        style: TextStyle(
                            fontSize: 13, color: textPrimary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(e.severity,
                        style: TextStyle(
                            fontSize: 10,
                            color: severityColor,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
              );
            }).toList(),
          ),
        ),
        // Disclaimer
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Konsultasikan efek samping yang mengganggu ke dokter.',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    height: 1.4),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Data Classes ────────────────────────────────────────────────────────────

class _EduCard {
  final IconData icon;
  final String title;
  final String subtitle;
  final String category;
  final List<Color> gradient;
  final String content;
  const _EduCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.gradient,
    required this.content,
  });
}

class _SideEffectCard {
  final String name;
  final String category;
  final List<Color> gradient;
  final IconData icon;
  final List<_Effect> effects;
  const _SideEffectCard({
    required this.name,
    required this.category,
    required this.gradient,
    required this.icon,
    required this.effects,
  });
}

class _Effect {
  final IconData icon;
  final String label;
  final String severity;
  const _Effect(
      {required this.icon, required this.label, required this.severity});
}

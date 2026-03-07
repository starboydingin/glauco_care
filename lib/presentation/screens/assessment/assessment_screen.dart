import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../home/home_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final bool standalone;
  const AssessmentScreen({super.key, this.standalone = false});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  final List<int?> _answers = [
    null, null, null, null, null,
    null, null, null, null, null,
  ];
  bool _showResult = false;
  late bool _showLanding;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  static const List<_QuestionData> _questions = [
    _QuestionData(
      text: 'Bagaimana kondisi ketajaman penglihatanmu saat ini?',
      icon: Icons.visibility_rounded,
      options: [
        'Jelas seperti biasa',
        'Sedikit lebih kabur dari biasanya',
        'Cukup kabur dan mengganggu aktivitas',
        'Sangat kabur',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu merasakan tekanan atau rasa berat pada bola mata?',
      icon: Icons.healing_rounded,
      options: [
        'Tidak ada sama sekali',
        'Kadang terasa ringan',
        'Cukup terasa dan mengganggu',
        'Sangat terasa / nyeri',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu mengalami sakit kepala di sekitar mata atau dahi?',
      icon: Icons.sick_rounded,
      options: [
        'Tidak pernah',
        'Kadang terjadi',
        'Cukup sering terjadi',
        'Sangat sering atau berat',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu melihat lingkaran cahaya (halo) di sekitar lampu, terutama saat malam hari?',
      icon: Icons.light_mode_rounded,
      options: [
        'Tidak pernah melihat',
        'Kadang terlihat',
        'Cukup sering terlihat',
        'Hampir selalu terlihat',
      ],
    ),
    _QuestionData(
      text: 'Apakah penglihatan di bagian samping terasa berkurang atau menyempit?',
      icon: Icons.panorama_wide_angle_rounded,
      options: [
        'Tidak ada perubahan',
        'Sedikit berkurang',
        'Cukup terasa menyempit',
        'Sangat menyempit',
      ],
      note:
          'Gejala ini penting karena glaukoma sering menyebabkan penurunan penglihatan perifer secara perlahan.',
    ),
    _QuestionData(
      text: 'Apakah kamu mengalami mata merah tanpa sebab yang jelas?',
      icon: Icons.remove_red_eye_rounded,
      options: [
        'Tidak pernah',
        'Jarang terjadi',
        'Kadang terjadi',
        'Sering terjadi',
      ],
    ),
    _QuestionData(
      text: 'Apakah matamu terasa lebih sensitif terhadap cahaya terang?',
      icon: Icons.wb_sunny_rounded,
      options: [
        'Tidak sensitif',
        'Sedikit sensitif',
        'Cukup sensitif',
        'Sangat sensitif / silau',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu merasa penglihatan memburuk secara perlahan dalam beberapa minggu terakhir?',
      icon: Icons.trending_down_rounded,
      options: [
        'Tidak ada perubahan',
        'Sedikit memburuk',
        'Cukup memburuk',
        'Memburuk secara signifikan',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu mengalami kesulitan melihat dalam kondisi cahaya redup atau malam hari?',
      icon: Icons.nights_stay_rounded,
      options: [
        'Tidak ada kesulitan',
        'Sedikit lebih sulit',
        'Cukup sulit',
        'Sangat sulit',
      ],
    ),
    _QuestionData(
      text: 'Apakah kamu pernah merasakan nyeri mata yang disertai mual atau rasa tidak nyaman pada mata?',
      icon: Icons.sentiment_very_dissatisfied_rounded,
      options: [
        'Tidak pernah',
        'Pernah sekali atau dua kali',
        'Kadang terjadi',
        'Sering terjadi',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _showLanding = widget.standalone;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    setState(() => _answers[_currentQuestion] = answerIndex);
  }

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) return;

    if (_currentQuestion < 9) {
      _animController.forward(from: 0);
      setState(() => _currentQuestion++);
    } else {
      setState(() => _showResult = true);
    }
  }

  void _restart() {
    _animController.forward(from: 0);
    setState(() {
      _currentQuestion = 0;
      _answers.fillRange(0, 10, null);
      _showResult = false;
      _showLanding = widget.standalone;
    });
  }

  int get _totalScore =>
      _answers.fold(0, (sum, a) => sum + (a ?? 0));

  _ResultData get _result {
    final score = _totalScore;
    if (score <= 9) {
      return const _ResultData(
        title: 'Kondisi Stabil',
        subtitle:
            'Gejalamu saat ini tampak normal. Tetap jaga kepatuhan minum obat dan jadwal kontrol rutin.',
        icon: Icons.check_circle_rounded,
        colors: AppColors.gradientGreen,
        statusColor: AppColors.statusHealthy,
      );
    } else if (score <= 19) {
      return const _ResultData(
        title: 'Perlu Dipantau',
        subtitle:
            'Ada beberapa gejala yang perlu diperhatikan. Pantau kondisi matamu lebih sering dan pastikan obat digunakan teratur.',
        icon: Icons.watch_later_rounded,
        colors: AppColors.gradientWarm,
        statusColor: AppColors.statusMonitor,
      );
    } else {
      return const _ResultData(
        title: 'Disarankan Konsultasi Dokter',
        subtitle:
            'Gejalamu menunjukkan tanda yang sebaiknya diperiksa oleh dokter mata. Segera buat janji temu.',
        icon: Icons.local_hospital_rounded,
        colors: [Color(0xFFE85B5B), Color(0xFFBF3030)],
        statusColor: AppColors.statusDanger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textWhite : AppColors.textDark;
    final textSec =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    if (_showLanding) {
      return _LandingView(
        isDark: isDark,
        textPrimary: textPrimary,
        textSec: textSec,
        onStart: () => setState(() => _showLanding = false),
      );
    }

    if (widget.standalone) {
      // Wrapped in Scaffold so it can be pushed via Navigator
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: _showResult
              ? _ResultScreen(
                  result: _result,
                  answers: _answers,
                  questions: _questions,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSec: textSec,
                  onRestart: _restart,
                  standalone: true,
                )
              : _QuestionnaireView(
                  currentQuestion: _currentQuestion,
                  questions: _questions,
                  answers: _answers,
                  slideAnimation: _slideAnimation,
                  fadeAnimation: _fadeAnimation,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSec: textSec,
                  onSelect: _selectAnswer,
                  onNext: _nextQuestion,
                  standalone: true,
                ),
        ),
      );
    }

    return _showResult
        ? _ResultScreen(
            result: _result,
            answers: _answers,
            questions: _questions,
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
            onRestart: _restart,
            standalone: false,
          )
        : _QuestionnaireView(
            currentQuestion: _currentQuestion,
            questions: _questions,
            answers: _answers,
            slideAnimation: _slideAnimation,
            fadeAnimation: _fadeAnimation,
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
            onSelect: _selectAnswer,
            onNext: _nextQuestion,
            standalone: false,
          );
  }
}

// ─── Landing View ────────────────────────────────────────────────────────────

class _LandingView extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onStart;

  const _LandingView({
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? AppColors.textWhite : AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Self-Assessment',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero illustration area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.gradientPurple,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Icon(Icons.remove_red_eye_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Cek Kondisi Mata Hari Ini',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jawab 10 pertanyaan singkat untuk mengetahui kondisi matamu saat ini.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xCCFFFFFF),
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              const SizedBox(height: 28),

              Text(
                'Apa itu Self-Assessment?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                'Self-assessment membantu kamu memantau perubahan gejala yang mungkin berkaitan dengan glaukoma secara mandiri. Hasil penilaian tidak menggantikan diagnosis dokter.',
                style:
                    TextStyle(fontSize: 13, color: textSec, height: 1.6),
              ),
              const SizedBox(height: 20),

              _InfoRow(
                  icon: Icons.timer_rounded,
                  text: 'Hanya butuh ±1 menit',
                  isDark: isDark),
              const SizedBox(height: 10),
              _InfoRow(
                  icon: Icons.quiz_rounded,
                  text: '10 pertanyaan mudah',
                  isDark: isDark),
              const SizedBox(height: 10),
              _InfoRow(
                  icon: Icons.analytics_rounded,
                  text: 'Hasil langsung + rekomendasi',
                  isDark: isDark),

              const Spacer(),

              GestureDetector(
                onTap: onStart,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.gradientGreen,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.statusHealthy
                            .withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Mulai Self-Assessment',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  const _InfoRow(
      {required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryLight),
      ),
      const SizedBox(width: 12),
      Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textWhite : AppColors.textDark,
        ),
      ),
    ]);
  }
}

// ─── Questionnaire View ──────────────────────────────────────────────────────

class _QuestionnaireView extends StatelessWidget {
  final int currentQuestion;
  final List<_QuestionData> questions;
  final List<int?> answers;
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final bool standalone;

  const _QuestionnaireView({
    required this.currentQuestion,
    required this.questions,
    required this.answers,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.onSelect,
    required this.onNext,
    required this.standalone,
  });

  static const List<Color> _optColors = [
    AppColors.statusHealthy,
    AppColors.statusMonitor,
    AppColors.statusDoctor,
    AppColors.statusDanger,
  ];
  static const List<IconData> _optIcons = [
    Icons.sentiment_very_satisfied_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_very_dissatisfied_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    final selected = answers[currentQuestion];
    final canProceed = selected != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, standalone ? 20 : kBottomNavHeight),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppStrings.assessmentTitle,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary)),
        const SizedBox(height: 4),
        Text(AppStrings.assessmentSubtitle,
            style: TextStyle(fontSize: 13, color: textSec)),
        const SizedBox(height: 10),

        // ── Disclaimer ─────────────────────────────────────────────
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Self-assessment ini bertujuan untuk membantu pengguna mengenali perubahan gejala yang mungkin berkaitan dengan glaukoma. Hasil penilaian tidak menggantikan diagnosis dokter.',
                  style: TextStyle(
                      fontSize: 11, color: textSec, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Progress ───────────────────────────────────────────────
        Row(children: [
          Text(
            'Pertanyaan ${currentQuestion + 1}/10',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (currentQuestion + 1) / 10,
                backgroundColor: isDark
                    ? AppColors.darkCardAlt
                    : AppColors.lightCardAlt,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // ── Question Card ──────────────────────────────────────────
        SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.gradientPurple,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(q.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(q.text,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.4)),
                    if (q.note != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded,
                                color: Colors.white70, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(q.note!,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ]),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Answer Options ─────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            itemCount: q.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final color = _optColors[i];
              final icon = _optIcons[i];
              final label = q.options[i];
              final isSelected = selected == i;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.12)
                        : (isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? color
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 12,
                            )
                          ]
                        : [],
                  ),
                  child: Row(children: [
                    Icon(icon,
                        color: isSelected ? color : textSec,
                        size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(label,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected ? color : textPrimary)),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: color, size: 20),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // ── Next Button ────────────────────────────────────────────
        AnimatedOpacity(
          opacity: canProceed ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: canProceed ? onNext : null,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: canProceed
                    ? const LinearGradient(
                        colors: AppColors.gradientPurple,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: canProceed
                    ? null
                    : (isDark
                        ? AppColors.darkCardAlt
                        : AppColors.lightCardAlt),
                borderRadius: BorderRadius.circular(16),
                boxShadow: canProceed
                    ? [
                        BoxShadow(
                          color:
                              AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                currentQuestion < 9
                    ? AppStrings.nextQuestion
                    : AppStrings.seeResult,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: canProceed ? Colors.white : textSec),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Result Screen ───────────────────────────────────────────────────────────

class _ResultScreen extends StatelessWidget {
  final _ResultData result;
  final List<int?> answers;
  final List<_QuestionData> questions;
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onRestart;
  final bool standalone;

  const _ResultScreen({
    required this.result,
    required this.answers,
    required this.questions,
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.onRestart,
    required this.standalone,
  });

  int get _totalScore => answers.fold(0, (s, a) => s + (a ?? 0));

  static const List<List<String>> _recommendations = [
    // score ≤ 9: Stabil
    [
      'Tetap patuhi jadwal minum obat setiap hari.',
      'Jaga jadwal kontrol rutin ke dokter mata.',
      'Catat tekanan mata secara berkala di aplikasi ini.',
      'Terapkan pola hidup sehat: cukup tidur, kurangi kafein.',
    ],
    // score ≤ 19: Perlu Dipantau
    [
      'Catat setiap gejala yang kamu rasakan secara rutin.',
      'Pastikan obat tetes mata digunakan sesuai jadwal.',
      'Segera lapor ke dokter jika gejala memburuk.',
      'Hindari posisi membungkuk lama dan mengangkat beban berat.',
      'Periksa tekanan mata lebih sering dari biasanya.',
    ],
    // score ≥ 20: Konsultasi Dokter
    [
      'Segera buat janji temu dengan dokter mata.',
      'Jangan tunda konsultasi, gejala perlu dievaluasi segera.',
      'Bawa catatan gejala dan riwayat obat saat ke dokter.',
      'Jangan hentikan atau ubah dosis obat tanpa konfirmasi dokter.',
      'Hindari aktivitas yang meningkatkan tekanan bola mata.',
      'Minta dokter untuk evaluasi tekanan intraokular segera.',
    ],
  ];

  List<String> get _currentRecs {
    final s = _totalScore;
    if (s <= 9) return _recommendations[0];
    if (s <= 19) return _recommendations[1];
    return _recommendations[2];
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final score = _totalScore;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, standalone ? 32 : kBottomNavHeight),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppStrings.assessmentResult,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary)),
        const SizedBox(height: 4),
        Text('Berikut hasil asesmen gejalamu hari ini',
            style: TextStyle(fontSize: 13, color: textSec)),
        const SizedBox(height: 20),

        // ── Result Card ────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: result.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: result.colors.first.withValues(alpha: 0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: Icon(result.icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.subtitle,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xCCFFFFFF),
                          height: 1.5),
                    ),
                  ]),
            ),
          ]),
        ),
        const SizedBox(height: 20),

        // ── Recommendations ────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.tips_and_updates_rounded,
                      color: result.statusColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Rekomendasi Untukmu',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                ]),
                const SizedBox(height: 14),
                ..._currentRecs.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: result.statusColor
                                    .withValues(alpha: 0.15),
                              ),
                              child: Icon(Icons.check_rounded,
                                  size: 12, color: result.statusColor),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(rec,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: textSec,
                                      height: 1.5)),
                            ),
                          ]),
                    )),
              ]),
        ),
        const SizedBox(height: 16),

        // ── Score Summary ──────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.bar_chart_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Skor dari 10 Pertanyaan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: result.statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Total: $score / 30',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: result.statusColor),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
                ...List.generate(questions.length, (i) {
                  final ans = answers[i] ?? 0;
                  final maxAns = questions[i].options.length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLight),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questions[i].text,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: textSec,
                                    height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: maxAns == 0
                                          ? 0
                                          : ans / maxAns,
                                      backgroundColor: isDark
                                          ? AppColors.darkCardAlt
                                          : AppColors.lightCardAlt,
                                      valueColor:
                                          AlwaysStoppedAnimation(
                                              result.statusColor),
                                      minHeight: 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  questions[i].options[ans],
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: result.statusColor),
                                ),
                              ]),
                            ]),
                      ),
                    ]),
                  );
                }),
              ]),
        ),
        const SizedBox(height: 20),

        // ── Buttons ────────────────────────────────────────────────
        if (standalone) ...[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.gradientPurple,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Kembali ke Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: onRestart,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardAlt : AppColors.lightCardAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              AppStrings.restartAssessment,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Data Classes ────────────────────────────────────────────────────────────

class _QuestionData {
  final String text;
  final IconData icon;
  final List<String> options;
  final String? note;
  const _QuestionData({
    required this.text,
    required this.icon,
    required this.options,
    this.note,
  });
}



class _ResultData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Color statusColor;
  const _ResultData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.statusColor,
  });
}

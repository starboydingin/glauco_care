import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../home/home_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  final List<int?> _answers = [null, null, null, null];
  bool _showResult = false;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  static const List<_QuestionData> _questions = [
    _QuestionData(
      index: 0,
      icon: Icons.visibility_rounded,
    ),
    _QuestionData(
      index: 1,
      icon: Icons.healing_rounded,
    ),
    _QuestionData(
      index: 2,
      icon: Icons.sick_rounded,
    ),
    _QuestionData(
      index: 3,
      icon: Icons.light_mode_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
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

    if (_currentQuestion < 3) {
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
      _answers.fillRange(0, 4, null);
      _showResult = false;
    });
  }

  int get _totalScore =>
      _answers.fold(0, (sum, a) => sum + (a ?? 0));

  _ResultData get _result {
    final score = _totalScore;
    if (score <= 3) {
      return const _ResultData(
        title: 'Kondisi Stabil',
        subtitle:
            'Gejalamu saat ini tampak normal. Tetap jaga kepatuhan minum obat dan jadwal kontrol rutin.',
        icon: Icons.check_circle_rounded,
        colors: AppColors.gradientGreen,
        statusColor: AppColors.statusHealthy,
      );
    } else if (score <= 7) {
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

    return _showResult
        ? _ResultScreen(
            result: _result,
            isDark: isDark,
            textPrimary: textPrimary,
            textSec: textSec,
            onRestart: _restart,
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
          );
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
  });

  static const List<_AnswerOption> _options = [
    _AnswerOption(
        label: 'Tidak sama sekali',
        score: 0,
        color: AppColors.statusHealthy,
        icon: Icons.sentiment_very_satisfied_rounded),
    _AnswerOption(
        label: 'Sedikit',
        score: 1,
        color: AppColors.statusMonitor,
        icon: Icons.sentiment_satisfied_rounded),
    _AnswerOption(
        label: 'Cukup mengganggu',
        score: 2,
        color: AppColors.statusDoctor,
        icon: Icons.sentiment_dissatisfied_rounded),
    _AnswerOption(
        label: 'Sangat mengganggu',
        score: 3,
        color: AppColors.statusDanger,
        icon: Icons.sentiment_very_dissatisfied_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    final selected = answers[currentQuestion];
    final questionText = AppStrings.questions[q.index];
    final canProceed = selected != null;

    return Padding(
      padding:
          EdgeInsets.fromLTRB(20, 16, 20, kBottomNavHeight),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppStrings.assessmentTitle,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary)),
        const SizedBox(height: 4),
        Text(AppStrings.assessmentSubtitle,
            style: TextStyle(fontSize: 13, color: textSec)),
        const SizedBox(height: 20),

        // ── Progress ───────────────────────────────────────────────
        Row(children: [
          Text(
            'Pertanyaan ${currentQuestion + 1}/4',
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
                value: (currentQuestion + 1) / 4,
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
                    Text(questionText,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.4)),
                  ]),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Answer Options ─────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            itemCount: _options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final opt = _options[i];
              final isSelected = selected == i;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? opt.color.withValues(alpha: 0.12)
                        : (isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? opt.color
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: opt.color.withValues(alpha: 0.3),
                              blurRadius: 12,
                            )
                          ]
                        : [],
                  ),
                  child: Row(children: [
                    Icon(opt.icon,
                        color: isSelected ? opt.color : textSec,
                        size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(opt.label,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected ? opt.color : textPrimary)),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: opt.color, size: 20),
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
                currentQuestion < 3
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
  final bool isDark;
  final Color textPrimary;
  final Color textSec;
  final VoidCallback onRestart;

  const _ResultScreen({
    required this.result,
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, kBottomNavHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.assessmentResult,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary)),
          const SizedBox(height: 8),
          Text('Berikut hasil asesmen gejalamu hari ini',
              style: TextStyle(fontSize: 13, color: textSec),
              textAlign: TextAlign.center),
          const SizedBox(height: 40),

          // Result card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
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
                  blurRadius: 32,
                  offset: const Offset(0, 12),
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
                child: Icon(result.icon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                result.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                result.subtitle,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xCCFFFFFF),
                    height: 1.6),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
          const SizedBox(height: 32),

          // Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(children: [
              const Icon(Icons.tips_and_updates_rounded,
                  color: AppColors.statusMonitor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Catat hasil ini dan bagikan ke dokter saat kontrol berikutnya.',
                  style: TextStyle(fontSize: 13, color: textSec, height: 1.5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // Restart button
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
        ],
      ),
    );
  }
}

// ─── Data Classes ────────────────────────────────────────────────────────────

class _QuestionData {
  final int index;
  final IconData icon;
  const _QuestionData({required this.index, required this.icon});
}

class _AnswerOption {
  final String label;
  final int score;
  final Color color;
  final IconData icon;
  const _AnswerOption(
      {required this.label,
      required this.score,
      required this.color,
      required this.icon});
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

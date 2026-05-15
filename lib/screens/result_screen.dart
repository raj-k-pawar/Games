import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/question_model.dart';
import '../services/subject_data.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final GameResult result;
  final String subjectId;

  const ResultScreen({super.key, required this.result, required this.subjectId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _scoreController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scoreAnim = Tween<double>(begin: 0, end: widget.result.score.toDouble())
        .animate(CurvedAnimation(parent: _scoreController, curve: Curves.easeOut));

    if (widget.result.stars >= 2) {
      _confettiController.play();
    }
    _scoreController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final subject = SubjectData.getById(widget.subjectId);
    final gradColor = subject != null ? Color(subject.gradientColors.first) : AppColors.primaryPurple;
    final isGood = result.stars >= 2;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Result hero
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: subject != null
                              ? subject.gradientColors.map((c) => Color(c)).toList()
                              : [AppColors.primaryPurple, AppColors.primaryBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: gradColor.withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Result emoji
                          Text(
                            result.stars == 3
                                ? '🏆'
                                : result.stars == 2
                                    ? '🎉'
                                    : '💪',
                            style: const TextStyle(fontSize: 64),
                          ).animate().scale(
                                begin: const Offset(0, 0),
                                duration: 600.ms,
                                curve: Curves.elasticOut,
                              ),

                          const SizedBox(height: 8),

                          Text(
                            result.stars == 3
                                ? 'Perfect Score!'
                                : result.stars == 2
                                    ? 'Great Job!'
                                    : 'Good Effort!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3, end: 0),

                          const SizedBox(height: 16),

                          // Stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (i) {
                              final filled = i < result.stars;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  filled ? '⭐' : '☆',
                                  style: TextStyle(
                                    fontSize: filled ? 40 : 32,
                                    color: filled ? null : Colors.white.withOpacity(0.3),
                                  ),
                                ).animate(delay: Duration(milliseconds: 400 + i * 150)).scale(
                                      begin: const Offset(0, 0),
                                      duration: 400.ms,
                                      curve: Curves.elasticOut,
                                    ),
                              );
                            }),
                          ),

                          const SizedBox(height: 20),

                          // Score
                          AnimatedBuilder(
                            animation: _scoreAnim,
                            builder: (context, _) {
                              return Text(
                                '${_scoreAnim.value.round()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              );
                            },
                          ),
                          Text(
                            'out of ${result.maxScore} points',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 20),

                    // Stats row
                    Row(
                      children: [
                        _StatBox('✅', '${result.correctAnswers}/${result.totalQuestions}', 'Correct', AppColors.primaryGreen),
                        const SizedBox(width: 10),
                        _StatBox('🎯', '${(result.accuracy * 100).round()}%', 'Accuracy', AppColors.primaryBlue),
                        const SizedBox(width: 10),
                        _StatBox('⏱️', '${result.timeTaken}s', 'Time', AppColors.primaryOrange),
                      ],
                    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 20),

                    // Rewards earned
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppDecorations.cardDecoration(
                        color: AppColors.bgCard,
                        glow: isGood,
                        glowColor: AppColors.primaryYellow,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🎁 Rewards Earned',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _RewardItem('🪙', '+${result.coinsEarned}', 'Coins', AppColors.primaryYellow),
                              _RewardItem('⭐', '+${result.xpEarned}', 'XP', AppColors.primaryPurple),
                              if (result.gemsEarned > 0)
                                _RewardItem('💎', '+${result.gemsEarned}', 'Gems', AppColors.primaryCyan),
                            ],
                          ),
                        ],
                      ),
                    ).animate(delay: 600.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),

                    const SizedBox(height: 20),

                    // Accuracy bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Performance Breakdown 📊',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 16),
                          _ProgressRow('Correct Answers', result.correctAnswers / result.totalQuestions, AppColors.primaryGreen),
                          const SizedBox(height: 10),
                          _ProgressRow('Score Achievement', result.score / result.maxScore, gradColor),
                          const SizedBox(height: 10),
                          _ProgressRow('Speed Bonus', (1 - result.timeTaken / (result.totalQuestions * 30)).clamp(0.0, 1.0), AppColors.primaryOrange),
                        ],
                      ),
                    ).animate(delay: 700.ms).fadeIn(),

                    const SizedBox(height: 28),

                    // Action buttons
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: subject != null
                                    ? subject.gradientColors.map((c) => Color(c)).toList()
                                    : [AppColors.primaryPurple, AppColors.primaryBlue],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [BoxShadow(color: gradColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
                            ),
                            child: const Center(
                              child: Text('🔄 Play Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.bgCardLight, width: 2),
                            ),
                            child: const Center(
                              child: Text('🏠 Home', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w800, fontSize: 16)),
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primaryPurple,
                AppColors.primaryYellow,
                AppColors.primaryGreen,
                AppColors.primaryPink,
                AppColors.primaryCyan,
              ],
              numberOfParticles: 40,
              emissionFrequency: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatBox(this.emoji, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
            Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final String amount;
  final String label;
  final Color color;

  const _RewardItem(this.emoji, this.amount, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 6),
        Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 20)),
        Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProgressRow(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 13, fontWeight: FontWeight.w600)),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: AppColors.bgDark,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/game_provider.dart';
import '../providers/user_provider.dart';
import '../services/subject_data.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String subjectId;
  final String gameMode;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.subjectId,
    required this.gameMode,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _shakeController;
  late AnimationController _correctController;
  bool _showFeedback = false;
  bool _feedbackCorrect = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _correctController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().loadGame(
            subjectId: widget.subjectId,
            difficulty: widget.difficulty,
          );
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final gp = context.read<GameProvider>();
      if (gp.gameState == GameState.playing && !gp.answered) {
        gp.tickTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _correctController.dispose();
    super.dispose();
  }

  void _onAnswerTap(int index) async {
    final gp = context.read<GameProvider>();
    if (gp.answered) return;

    gp.submitAnswer(index);

    final isCorrect = index == gp.currentQuestion?.correctIndex;
    setState(() {
      _showFeedback = true;
      _feedbackCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctController.forward(from: 0);
    } else {
      _shakeController.forward(from: 0);
    }

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() => _showFeedback = false);

    if (gp.isLastQuestion) {
      _finishGame();
    } else {
      gp.nextQuestion();
      _shakeController.reset();
      _correctController.reset();
    }
  }

  void _finishGame() {
    _timer?.cancel();
    final gp = context.read<GameProvider>();
    final result = gp.buildResult(widget.subjectId, widget.gameMode);
    context.read<UserProvider>().applyGameResult(result);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result, subjectId: widget.subjectId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final subject = SubjectData.getById(widget.subjectId);
    final gradColor = subject != null ? Color(subject.gradientColors.first) : AppColors.primaryPurple;

    if (gp.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = gp.currentQuestion;
    if (q == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              _buildTopBar(gp, gradColor),

              // Timer bar
              _buildTimerBar(gp, gradColor),

              const SizedBox(height: 10),

              // Question card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Question
                      _buildQuestionCard(gp, q).animate(
                        key: ValueKey(gp.currentIndex),
                      ).fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),

                      const SizedBox(height: 20),

                      // Options
                      ...q.options.asMap().entries.map((entry) {
                        final i = entry.key;
                        final option = entry.value;
                        final isHidden = gp.hiddenOptions.contains(i);
                        if (isHidden) return const SizedBox(height: 10 + 66);

                        return _AnswerOption(
                          index: i,
                          text: option,
                          gameProvider: gp,
                          accentColor: gradColor,
                          onTap: () => _onAnswerTap(i),
                          shakeController: i == gp.selectedAnswer && !_feedbackCorrect
                              ? _shakeController
                              : null,
                        )
                            .animate(key: ValueKey('${gp.currentIndex}_$i'), delay: Duration(milliseconds: 100 + i * 80))
                            .fadeIn()
                            .slideX(begin: 0.2, end: 0);
                      }),

                      // Explanation
                      if (gp.answered && q.explanation.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _ExplanationCard(explanation: q.explanation, correct: _feedbackCorrect)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Lifelines + next button
              _buildBottomBar(gp, gradColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(GameProvider gp, Color gradColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => _QuitDialog(onQuit: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                }),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.close_rounded, color: AppColors.textGray, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                LinearPercentIndicator(
                  lineHeight: 10,
                  percent: gp.progress,
                  backgroundColor: AppColors.bgCard,
                  linearGradient: LinearGradient(colors: [gradColor.withOpacity(0.7), gradColor]),
                  barRadius: const Radius.circular(6),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                Text(
                  '${gp.currentIndex + 1} / ${gp.questions.length}',
                  style: const TextStyle(color: AppColors.textGray, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('${gp.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBar(GameProvider gp, Color gradColor) {
    final percent = gp.currentQuestion != null
        ? gp.timeLeft / gp.currentQuestion!.timeSeconds
        : 1.0;
    final timerColor = percent > 0.5
        ? AppColors.primaryGreen
        : percent > 0.25
            ? AppColors.primaryOrange
            : AppColors.primaryRed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: LinearPercentIndicator(
                lineHeight: 14,
                percent: percent.clamp(0.0, 1.0),
                backgroundColor: AppColors.bgCard,
                progressColor: timerColor,
                barRadius: const Radius.circular(8),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: timerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: timerColor.withOpacity(0.5), width: 1.5),
            ),
            child: Center(
              child: Text(
                '${gp.timeLeft}',
                style: TextStyle(
                  color: timerColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(GameProvider gp, dynamic q) {
    final diffColors = {
      'easy': AppColors.primaryGreen,
      'medium': AppColors.primaryOrange,
      'hard': AppColors.primaryRed,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: AppDecorations.cardDecoration(
        color: AppColors.bgCard,
        radius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (diffColors[widget.difficulty] ?? AppColors.primaryGreen).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.difficulty.toUpperCase(),
                  style: TextStyle(
                    color: diffColors[widget.difficulty] ?? AppColors.primaryGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+${q.points} pts',
                style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            q.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GameProvider gp, Color gradColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgCardLight, width: 1)),
      ),
      child: Row(
        children: [
          // Lifelines
          _LifelineButton(
            emoji: '⏭️',
            label: '${gp.skipLifelines}',
            tooltip: 'Skip',
            enabled: gp.skipLifelines > 0 && !gp.answered,
            onTap: () => gp.useSkip(),
          ),
          const SizedBox(width: 8),
          _LifelineButton(
            emoji: '5️⃣0️⃣',
            label: '${gp.fiftyFiftyLifelines}',
            tooltip: '50:50',
            enabled: gp.fiftyFiftyLifelines > 0 && !gp.answered,
            onTap: () => gp.useFiftyFifty(),
          ),
          const SizedBox(width: 8),
          _LifelineButton(
            emoji: '⏱️',
            label: '${gp.extraTimeLifelines}',
            tooltip: '+15s',
            enabled: gp.extraTimeLifelines > 0 && !gp.answered,
            onTap: () => gp.useExtraTime(),
          ),

          const Spacer(),

          // Next / Finish
          if (gp.answered)
            GestureDetector(
              onTap: gp.isLastQuestion ? _finishGame : () {
                gp.nextQuestion();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [gradColor.withOpacity(0.8), gradColor]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: gradColor.withOpacity(0.4), blurRadius: 15)],
                ),
                child: Row(
                  children: [
                    Text(
                      gp.isLastQuestion ? 'Finish! 🏁' : 'Next →',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ],
                ),
              ).animate().scale(begin: const Offset(0.8, 0.8), duration: 300.ms, curve: Curves.elasticOut),
            ),
        ],
      ),
    );
  }
}

// ── Answer Option ────────────────────────────────────────────────────────────

class _AnswerOption extends StatelessWidget {
  final int index;
  final String text;
  final GameProvider gameProvider;
  final Color accentColor;
  final VoidCallback onTap;
  final AnimationController? shakeController;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.gameProvider,
    required this.accentColor,
    required this.onTap,
    this.shakeController,
  });

  @override
  Widget build(BuildContext context) {
    final gp = gameProvider;
    final isSelected = gp.selectedAnswer == index;
    final isCorrect = index == gp.currentQuestion?.correctIndex;
    final showResult = gp.answered;

    Color borderColor = AppColors.bgCardLight;
    Color bgColor = AppColors.bgCard;
    Widget? trailingIcon;

    if (showResult) {
      if (isCorrect) {
        borderColor = AppColors.primaryGreen;
        bgColor = AppColors.primaryGreen.withOpacity(0.15);
        trailingIcon = const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 24);
      } else if (isSelected) {
        borderColor = AppColors.primaryRed;
        bgColor = AppColors.primaryRed.withOpacity(0.15);
        trailingIcon = const Icon(Icons.cancel_rounded, color: AppColors.primaryRed, size: 24);
      }
    } else if (isSelected) {
      borderColor = accentColor;
      bgColor = accentColor.withOpacity(0.15);
    }

    final labels = ['A', 'B', 'C', 'D'];

    Widget child = GestureDetector(
      onTap: showResult ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: showResult && isCorrect
                    ? AppColors.primaryGreen.withOpacity(0.3)
                    : showResult && isSelected
                        ? AppColors.primaryRed.withOpacity(0.3)
                        : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );

    if (shakeController != null) {
      return AnimatedBuilder(
        animation: shakeController!,
        builder: (context, child) {
          final offset = shakeController!.value < 0.5
              ? Offset(8 * shakeController!.value * 4, 0)
              : Offset(-8 * (1 - shakeController!.value) * 4, 0);
          return Transform.translate(offset: offset, child: child);
        },
        child: child,
      );
    }

    return child;
  }
}

// ── Explanation Card ─────────────────────────────────────────────────────────

class _ExplanationCard extends StatelessWidget {
  final String explanation;
  final bool correct;

  const _ExplanationCard({required this.explanation, required this.correct});

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.primaryGreen : AppColors.primaryOrange;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(correct ? '💡' : '📖', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct ? 'Great job!' : 'Learn this!',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Lifeline Button ──────────────────────────────────────────────────────────

class _LifelineButton extends StatelessWidget {
  final String emoji;
  final String label;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  const _LifelineButton({
    required this.emoji,
    required this.label,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Tooltip(
        message: tooltip,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled ? 1.0 : 0.4,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.bgCardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: enabled ? AppColors.primaryPurple.withOpacity(0.5) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quit Dialog ──────────────────────────────────────────────────────────────

class _QuitDialog extends StatelessWidget {
  final VoidCallback onQuit;
  const _QuitDialog({required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😢', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'Quit Game?',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your progress will be lost!',
              style: TextStyle(color: AppColors.textGray),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.bgCardLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('Keep Playing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onQuit();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryRed.withOpacity(0.5), width: 1.5),
                      ),
                      child: const Center(
                        child: Text('Quit', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

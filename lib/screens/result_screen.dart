import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final GameResult? result;
  const ResultScreen({super.key, this.result});
  @override State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _scoreCtrl;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));
    _scoreCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    final score = widget.result?.score.toDouble() ?? 0;
    _scoreAnim = Tween<double>(begin: 0, end: score)
        .animate(CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOut));
    if ((widget.result?.stars ?? 0) >= 2) _confetti.play();
    _scoreCtrl.forward();
  }

  @override void dispose() { _confetti.dispose(); _scoreCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    if (r == null) return const Scaffold(body: Center(child: Text('No result')));
    final subject = SubjectService.byId(r.subjectId);
    final gradColor = subject != null ? Color(subject.gradColors[0]) : AppColors.primary;

    return Scaffold(body: Stack(children: [
      Container(decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [

          // Hero result card
          Container(width: double.infinity, padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: subject != null
                ? LinearGradient(colors: subject.gradColors.map<Color>((c)=>Color(c)).toList(), begin: Alignment.topLeft, end: Alignment.bottomRight)
                : AppColors.purpleGrad,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: gradColor.withOpacity(0.5), blurRadius: 30, offset: const Offset(0,10))]),
            child: Column(children: [
              Text(r.stars==3?'🏆':r.stars==2?'🎉':'💪', style: const TextStyle(fontSize: 64))
                .animate().scale(begin: const Offset(0,0), duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 8),
              Text(r.stars==3?'Perfect Score!':r.stars==2?'Great Job!':'Good Effort!',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))
                .animate(delay: 300.ms).fadeIn().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 16),
              // Stars
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
                Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(i < r.stars ? '⭐' : '☆',
                    style: TextStyle(fontSize: i<r.stars?40:32, color: i<r.stars?null:Colors.white.withOpacity(0.3)))
                  .animate(delay: Duration(milliseconds: 400+i*150)).scale(begin: const Offset(0,0), duration: 400.ms, curve: Curves.elasticOut)))),
              const SizedBox(height: 20),
              // Animated score
              AnimatedBuilder(animation: _scoreAnim,
                builder: (_, __) => Text('${_scoreAnim.value.round()}',
                  style: const TextStyle(color: Colors.white, fontSize: 58, fontWeight: FontWeight.w900, height: 1))),
              Text('out of ${r.maxScore} points', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
            ])).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 18),

          // Stats row
          Row(children: [
            _StatBox('✅', '${r.correctAnswers}/${r.totalQuestions}', 'Correct', AppColors.green),
            const SizedBox(width: 10),
            _StatBox('🎯', '${(r.accuracy*100).round()}%', 'Accuracy', AppColors.blue),
            const SizedBox(width: 10),
            _StatBox('⏱️', '${r.timeTaken}s', 'Time', AppColors.orange),
          ]).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          // Rewards card
          Container(padding: const EdgeInsets.all(20),
            decoration: AppDeco.card(color: AppColors.bgCard, glow: r.stars>=2, glowColor: AppColors.yellow),
            child: Column(children: [
              const Text('🎁 Rewards Earned', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _RewardItem('🪙', '+${r.coinsEarned}', 'Coins',  AppColors.yellow),
                _RewardItem('⭐', '+${r.xpEarned}',   'XP',     AppColors.primary),
                if (r.gemsEarned > 0) _RewardItem('💎', '+${r.gemsEarned}', 'Gems', AppColors.cyan),
              ]),
            ])).animate(delay: 600.ms).fadeIn().scale(begin: const Offset(0.9,0.9)),

          const SizedBox(height: 16),

          // Performance bars
          Container(padding: const EdgeInsets.all(20),
            decoration: AppDeco.card(color: AppColors.bgCard),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Performance 📊', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 14),
              _PBar('Correct Answers', r.correctAnswers/r.totalQuestions, AppColors.green),
              const SizedBox(height: 10),
              _PBar('Score Achievement', r.maxScore>0?r.score/r.maxScore:0, gradColor),
              const SizedBox(height: 10),
              _PBar('Speed Bonus', (1-(r.timeTaken/(r.totalQuestions*30))).clamp(0.0,1.0), AppColors.orange),
            ])).animate(delay: 700.ms).fadeIn(),

          const SizedBox(height: 24),

          // Buttons
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(height: 58, decoration: BoxDecoration(
              gradient: subject!=null?LinearGradient(colors:subject.gradColors.map<Color>((c)=>Color(c)).toList()):AppColors.purpleGrad,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: gradColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0,6))]),
              child: const Center(child: Text('🔄 Play Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)))))
            .animate(delay: 800.ms).fadeIn().slideY(begin: 0.3, end: 0),
          const SizedBox(height: 12),
          GestureDetector(onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_)=>false),
            child: Container(height: 52,
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.bgCardL, width: 2)),
              child: const Center(child: Text('🏠 Home', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w800, fontSize: 16)))))
            .animate(delay: 850.ms).fadeIn(),
          const SizedBox(height: 20),
        ])))),

      // Confetti
      Align(alignment: Alignment.topCenter, child: ConfettiWidget(
        confettiController: _confetti, blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false, numberOfParticles: 40, emissionFrequency: 0.05,
        colors: const [AppColors.primary, AppColors.yellow, AppColors.green, AppColors.pink, AppColors.cyan])),
    ]));
  }
}

class _StatBox extends StatelessWidget {
  final String emoji, value, label; final Color color;
  const _StatBox(this.emoji, this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.3), width: 1.5)),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 17)),
      Text(label, style: const TextStyle(color: AppColors.textG, fontSize: 12)),
    ])));
}

class _RewardItem extends StatelessWidget {
  final String emoji, amount, label; final Color color;
  const _RewardItem(this.emoji, this.amount, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(emoji, style: const TextStyle(fontSize: 30)),
    const SizedBox(height: 6),
    Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 20)),
    Text(label, style: const TextStyle(color: AppColors.textG, fontSize: 12)),
  ]);
}

class _PBar extends StatelessWidget {
  final String label; final double value; final Color color;
  const _PBar(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppColors.textG, fontSize: 12, fontWeight: FontWeight.w600)),
      Text('${(value*100).round()}%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
    ]),
    const SizedBox(height: 5),
    ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(
      value: value.clamp(0.0,1.0), backgroundColor: AppColors.bgDark,
      valueColor: AlwaysStoppedAnimation(color), minHeight: 8)),
  ]);
}

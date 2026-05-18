import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String subjectId, difficulty;
  final int count;
  const GameScreen({super.key, required this.subjectId, required this.difficulty, this.count = 25});
  @override State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _shakeCtrl, _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _feedbackCorrect = false;
  int _animIdx = -1;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _slideAnim = Tween<Offset>(begin: const Offset(1,0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().loadGame(subjectId: widget.subjectId, difficulty: widget.difficulty, count: widget.count);
      _startTimer();
      _slideCtrl.forward(from: 0);
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      context.read<GameProvider>().tickTimer();
    });
  }

  @override void dispose() { _timer?.cancel(); _shakeCtrl.dispose(); _slideCtrl.dispose(); super.dispose(); }

  void _onAnswer(int idx) {
    final gp = context.read<GameProvider>();
    if (gp.answered) return;
    gp.submitAnswer(idx);
    final correct = idx == gp.currentQuestion?.correctIndex;
    setState(() => _feedbackCorrect = correct);
    if (!correct) _shakeCtrl.forward(from: 0);
  }

  void _onNext() {
    final gp = context.read<GameProvider>();
    if (!gp.answered) return;
    if (gp.isLastQuestion) { _finish(); return; }
    _slideCtrl.reverse().then((_) {
      if (!mounted) return;
      gp.nextQuestion();
      _shakeCtrl.reset();
      setState(() {});
      _slideCtrl.forward(from: 0);
    });
  }

  void _finish() {
    _timer?.cancel();
    final gp = context.read<GameProvider>();
    final result = gp.buildResult(widget.subjectId);
    context.read<AppProvider>().applyResult(result);
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_,__,___) => ResultScreen(result: result),
      transitionsBuilder: (_,a,__,c) => FadeTransition(opacity: a, child: c),
      transitionDuration: const Duration(milliseconds: 400)));
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final subject = SubjectService.byId(widget.subjectId);
    final gradColor = subject!=null ? Color(subject.gradColors[0]) : AppColors.primary;
    if (gp.questions.isEmpty) return const Scaffold(backgroundColor: AppColors.bgDark,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    final q = gp.currentQuestion;
    if (q == null) return const SizedBox.shrink();
    if (_animIdx != gp.currentIndex) _animIdx = gp.currentIndex;

    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        _topBar(gp, gradColor),
        _timerBar(gp, gradColor),
        const SizedBox(height: 10),
        Expanded(child: SlideTransition(position: _slideAnim, child: FadeTransition(opacity: _fadeAnim,
          child: SingleChildScrollView(key: ValueKey(gp.currentIndex), padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              // Question card
              _QCard(question: q, difficulty: widget.difficulty),
              const SizedBox(height: 18),
              // Options
              ...q.options.asMap().entries.map((e) {
                if (gp.hiddenOptions.contains(e.key)) return const SizedBox(height: 74);
                return _OptionTile(key: ValueKey('${gp.currentIndex}_${e.key}'),
                  index: e.key, text: e.value, gp: gp, accent: gradColor,
                  onTap: () => _onAnswer(e.key),
                  shakeCtrl: e.key==gp.selectedAnswer && !_feedbackCorrect ? _shakeCtrl : null,
                ).animate(delay: Duration(milliseconds: 50+e.key*60)).fadeIn(duration: 250.ms).slideX(begin: 0.15, end: 0);
              }),
              // Explanation
              if (gp.answered && q.explanation.isNotEmpty) ...[
                const SizedBox(height: 14),
                _Explanation(text: q.explanation, correct: _feedbackCorrect).animate().fadeIn(duration: 350.ms).slideY(begin: 0.2, end: 0),
              ],
              const SizedBox(height: 20),
            ]))))),
        _bottomBar(gp, gradColor),
      ]))));
  }

  Widget _topBar(GameProvider gp, Color c) => Padding(padding: const EdgeInsets.fromLTRB(20,12,20,0),
    child: Row(children: [
      GestureDetector(onTap: () => _showQuit(), child: Container(width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.close_rounded, color: AppColors.textG, size: 20))),
      const SizedBox(width: 12),
      Expanded(child: Column(children: [
        LinearPercentIndicator(lineHeight: 10, percent: gp.progress, backgroundColor: AppColors.bgCard,
          linearGradient: LinearGradient(colors: [c.withOpacity(0.7), c]),
          barRadius: const Radius.circular(6), padding: EdgeInsets.zero),
        const SizedBox(height: 4),
        Text('${gp.currentIndex+1} / ${gp.questions.length}', style: const TextStyle(color: AppColors.textG, fontSize: 11, fontWeight: FontWeight.w700)),
      ])),
      const SizedBox(width: 12),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(gradient: AppColors.purpleGrad, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Text('⭐', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text('${gp.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        ])),
    ]));

  Widget _timerBar(GameProvider gp, Color c) {
    final q = gp.currentQuestion;
    final pct = q != null ? (gp.timeLeft / q.timeSeconds).clamp(0.0, 1.0) : 1.0;
    final tc = pct > 0.5 ? AppColors.green : pct > 0.25 ? AppColors.orange : AppColors.red;
    return Padding(padding: const EdgeInsets.fromLTRB(20,12,20,0), child: Row(children: [
      Expanded(child: LinearPercentIndicator(lineHeight: 14, percent: pct, backgroundColor: AppColors.bgCard,
        progressColor: tc, barRadius: const Radius.circular(8), padding: EdgeInsets.zero)),
      const SizedBox(width: 10),
      AnimatedContainer(duration: const Duration(milliseconds: 200), width: 44, height: 44,
        decoration: BoxDecoration(color: tc.withOpacity(0.2), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tc.withOpacity(0.5), width: 1.5)),
        child: Center(child: Text('${gp.timeLeft}', style: TextStyle(color: tc, fontWeight: FontWeight.w900, fontSize: 18)))),
    ]));
  }

  Widget _bottomBar(GameProvider gp, Color c) => Container(
    padding: const EdgeInsets.fromLTRB(20,12,20,20),
    decoration: BoxDecoration(color: AppColors.bgCard, border: Border(top: BorderSide(color: AppColors.bgCardL, width: 1))),
    child: Row(children: [
      _LL('⏭️', '${gp.skips}',      'Skip',  gp.skips>0&&!gp.answered,  ()=>gp.useSkip()),
      const SizedBox(width: 8),
      _LL('50', '${gp.fiftyFifty}', '50:50', gp.fiftyFifty>0&&!gp.answered, ()=>gp.useFiftyFifty()),
      const SizedBox(width: 8),
      _LL('⏱️', '${gp.extraTime}', '+15s',  gp.extraTime>0&&!gp.answered, ()=>gp.useExtraTime()),
      const Spacer(),
      AnimatedSwitcher(duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: gp.answered
          ? GestureDetector(key: const ValueKey('next'), onTap: _onNext,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [c.withOpacity(0.85), c]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: c.withOpacity(0.45), blurRadius: 18, offset: const Offset(0,4))]),
              child: Text(gp.isLastQuestion?'Finish 🏁':'Next →',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17))))
          : const SizedBox.shrink(key: ValueKey('empty'))),
    ]));

  Widget _LL(String emoji, String count, String tip, bool enabled, VoidCallback onTap) =>
    GestureDetector(onTap: enabled ? onTap : null,
      child: AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: enabled?1.0:0.35,
        child: Tooltip(message: tip, child: Container(width: 54, height: 54,
          decoration: BoxDecoration(color: AppColors.bgCardL, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: enabled?AppColors.primary.withOpacity(0.5):Colors.transparent, width: 1.5)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(emoji, style: TextStyle(fontSize: emoji.length>2?12:18)),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
          ])))));

  void _showQuit() => showDialog(context: context, builder: (_) => Dialog(
    backgroundColor: AppColors.bgCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('😢', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      const Text('Quit Game?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      const Text('Progress will be lost!', style: TextStyle(color: AppColors.textG)),
      const SizedBox(height: 24),
      Row(children: [
        Expanded(child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(height: 50,
          decoration: BoxDecoration(color: AppColors.bgCardL, borderRadius: BorderRadius.circular(14)),
          child: const Center(child: Text('Keep Playing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))))),
        const SizedBox(width: 12),
        Expanded(child: GestureDetector(onTap: () { Navigator.pop(context); Navigator.popUntil(context, ModalRoute.withName('/home')); },
          child: Container(height: 50,
            decoration: BoxDecoration(color: AppColors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.red.withOpacity(0.5), width: 1.5)),
            child: const Center(child: Text('Quit', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w800)))))),
      ]),
    ]))));
}

class _QCard extends StatelessWidget {
  final dynamic question; final String difficulty;
  const _QCard({required this.question, required this.difficulty});
  @override
  Widget build(BuildContext context) {
    final dc = difficulty=='easy'?AppColors.green:difficulty=='medium'?AppColors.orange:AppColors.red;
    return Container(width: double.infinity, padding: const EdgeInsets.all(22),
      decoration: AppDeco.card(color: AppColors.bgCard, r: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: dc.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Text(difficulty.toUpperCase(), style: TextStyle(color: dc, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))),
          const SizedBox(width: 8),
          Text('+${question.points} pts', style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w700, fontSize: 12)),
        ]),
        const SizedBox(height: 14),
        Text(question.question, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.4)),
      ]));
  }
}

class _OptionTile extends StatelessWidget {
  final int index; final String text; final GameProvider gp;
  final Color accent; final VoidCallback onTap; final AnimationController? shakeCtrl;
  const _OptionTile({super.key, required this.index, required this.text, required this.gp,
    required this.accent, required this.onTap, this.shakeCtrl});
  @override
  Widget build(BuildContext context) {
    final sel = gp.selectedAnswer == index;
    final correct = index == gp.currentQuestion?.correctIndex;
    final show = gp.answered;
    Color borderC = AppColors.bgCardL, bgC = AppColors.bgCard;
    Widget? icon;
    if (show) {
      if (correct) { borderC = AppColors.green; bgC = AppColors.green.withOpacity(0.15); icon = const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 24); }
      else if (sel) { borderC = AppColors.red; bgC = AppColors.red.withOpacity(0.15); icon = const Icon(Icons.cancel_rounded, color: AppColors.red, size: 24); }
    } else if (sel) { borderC = accent; bgC = accent.withOpacity(0.15); }
    const labels = ['A','B','C','D'];
    Widget tile = GestureDetector(onTap: show?null:onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: bgC, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderC, width: 2)),
        child: Row(children: [
          Container(width: 34, height: 34,
            decoration: BoxDecoration(color: show&&correct?AppColors.green.withOpacity(0.3):show&&sel?AppColors.red.withOpacity(0.3):AppColors.bgCardL, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(labels[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)))),
          const SizedBox(width: 14),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
          if (icon != null) icon,
        ])));
    if (shakeCtrl != null) return AnimatedBuilder(animation: shakeCtrl!,
      builder: (_, child) => Transform.translate(
        offset: Offset(shakeCtrl!.value < 0.5 ? 8*shakeCtrl!.value*4 : -8*(1-shakeCtrl!.value)*4, 0), child: child),
      child: tile);
    return tile;
  }
}

class _Explanation extends StatelessWidget {
  final String text; final bool correct;
  const _Explanation({required this.text, required this.correct});
  @override
  Widget build(BuildContext context) {
    final c = correct ? AppColors.green : AppColors.orange;
    return Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withOpacity(0.3), width: 1.5)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(correct?'💡':'📖', style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(correct?'Correct!':'Learn this!', style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(color: AppColors.textL, fontSize: 12, height: 1.4)),
        ])),
      ]));
  }
}

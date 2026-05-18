import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class GameSelectScreen extends StatefulWidget {
  final String subjectId;
  const GameSelectScreen({super.key, required this.subjectId});
  @override State<GameSelectScreen> createState() => _GameSelectScreenState();
}

class _GameSelectScreenState extends State<GameSelectScreen> {
  String _difficulty = 'easy';
  int _count = 25;

  @override
  Widget build(BuildContext context) {
    final subject = SubjectService.byId(widget.subjectId);
    if (subject == null) return const Scaffold(body: Center(child: Text('Subject not found')));
    final gradColor = Color(subject.gradColors[0]);
    final app = context.watch<AppProvider>();
    final prog = app.child?.progress[subject.id];

    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 14),
          Text('${subject.emoji} ${subject.name}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        ])),

        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Hero card
          Container(width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: subject.gradColors.map<Color>((c)=>Color(c)).toList(), begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: gradColor.withOpacity(0.5), blurRadius: 25, offset: const Offset(0,8))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(subject.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(subject.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
              Text(subject.description, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
              if (prog != null) ...[
                const SizedBox(height: 12),
                Row(children: [
                  _InfoChip('🎮 ${prog.gamesPlayed}'), const SizedBox(width: 8),
                  _InfoChip('⭐ ${prog.totalStars}'),  const SizedBox(width: 8),
                  _InfoChip('🏆 ${prog.highScore} best'),
                ]),
              ],
            ])).animate().fadeIn().scale(begin: const Offset(0.95,0.95)),
          const SizedBox(height: 24),

          // Difficulty
          const Text('Difficulty 🎯', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: [
            _DiffBtn('😊', 'Easy',   'easy',   AppColors.greenGrad,  _difficulty, (d) => setState(()=>_difficulty=d)),
            const SizedBox(width: 10),
            _DiffBtn('🤔', 'Medium', 'medium', AppColors.orangeGrad, _difficulty, (d) => setState(()=>_difficulty=d)),
            const SizedBox(width: 10),
            _DiffBtn('😤', 'Hard',   'hard',   AppColors.pinkGrad,   _difficulty, (d) => setState(()=>_difficulty=d)),
          ]).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 16),

          // Difficulty info
          _DiffInfo(difficulty: _difficulty).animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 20),

          // Question count selector
          const Text('Questions 📋', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: [
            _CountBtn(25, _count, (c) => setState(()=>_count=c)),
            const SizedBox(width: 10),
            _CountBtn(10, _count, (c) => setState(()=>_count=c)),
            const SizedBox(width: 10),
            _CountBtn(50, _count, (c) => setState(()=>_count=c)),
          ]).animate(delay: 350.ms).fadeIn(),
          const SizedBox(height: 28),

          // Start button
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/game', arguments: {'subjectId': widget.subjectId, 'difficulty': _difficulty, 'count': _count}),
            child: Container(height: 62, decoration: BoxDecoration(
              gradient: LinearGradient(colors: subject.gradColors.map<Color>((c)=>Color(c)).toList()),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: gradColor.withOpacity(0.5), blurRadius: 25, offset: const Offset(0,8))]),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('🚀', style: TextStyle(fontSize: 22)),
                SizedBox(width: 10),
                Text('Start Game!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              ])).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0)),
        ]))),
      ])));
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)));
}

class _DiffBtn extends StatelessWidget {
  final String emoji, label, value; final LinearGradient grad;
  final String selected; final Function(String) onTap;
  const _DiffBtn(this.emoji, this.label, this.value, this.grad, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) {
    final sel = value == selected;
    return Expanded(child: GestureDetector(onTap: () => onTap(value),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), height: 74,
        decoration: BoxDecoration(gradient: sel?grad:null, color: sel?null:AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel?Colors.transparent:AppColors.bgCardL, width: 2),
          boxShadow: sel?[BoxShadow(color: grad.colors.first.withOpacity(0.4), blurRadius: 14, offset: const Offset(0,4))]:null),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: sel?Colors.white:AppColors.textG, fontWeight: FontWeight.w800, fontSize: 13)),
        ]))));
  }
}

class _CountBtn extends StatelessWidget {
  final int count, selected; final Function(int) onTap;
  const _CountBtn(this.count, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) {
    final sel = count == selected;
    return Expanded(child: GestureDetector(onTap: () => onTap(count),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), height: 56,
        decoration: BoxDecoration(gradient: sel?AppColors.purpleGrad:null, color: sel?null:AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: sel?Colors.transparent:AppColors.bgCardL, width: 2)),
        child: Center(child: Text('$count Qs',
          style: TextStyle(color: sel?Colors.white:AppColors.textG, fontWeight: FontWeight.w800, fontSize: 15))))));
  }
}

class _DiffInfo extends StatelessWidget {
  final String difficulty;
  const _DiffInfo({required this.difficulty});
  @override
  Widget build(BuildContext context) {
    final info = {
      'easy':   {'text':'25 questions • 25 sec each • 10 pts each — Perfect for Grade 5-6', 'color':AppColors.green},
      'medium': {'text':'25 questions • 30 sec each • 20 pts each — Ideal for Grade 7-8',   'color':AppColors.orange},
      'hard':   {'text':'25 questions • 35 sec each • 30 pts each — Challenge for Grade 9-10','color':AppColors.red},
    };
    final d = info[difficulty]!;
    return AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Container(
      key: ValueKey(difficulty), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: (d['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (d['color'] as Color).withOpacity(0.3), width: 1)),
      child: Text(d['text'] as String, style: TextStyle(color: d['color'] as Color, fontWeight: FontWeight.w600, fontSize: 12))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final child = context.watch<AppProvider>().child;
    final modes = [
      {'emoji':'⚔️','title':'1v1 Quick Battle','desc':'Challenge a friend to a 10-question duel!','color':AppColors.red,'tag':'LIVE'},
      {'emoji':'👥','title':'Team Tournament','desc':'Join a team and compete together','color':AppColors.blue,'tag':'SOON'},
      {'emoji':'🏅','title':'Weekly Championship','desc':'Compete globally every weekend','color':AppColors.yellow,'tag':'SOON'},
      {'emoji':'📚','title':'Subject Championship','desc':'Best player in each subject','color':AppColors.green,'tag':'SOON'},
    ];
    return Scaffold(body: Container(decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 14),
          const Text('⚔️ Battle Arena', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 20),

        // Your Quizzo ID card
        if (child != null) Container(padding: const EdgeInsets.all(18),
          decoration: AppDeco.card(grad: [const Color(0xFF6C3CE1), const Color(0xFF9B59F5)], glow: true),
          child: Row(children: [
            const Text('🆔', style: TextStyle(fontSize: 32)), const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your Quizzo ID', style: TextStyle(color: Color(0xFFD4CAFE), fontSize: 12, fontWeight: FontWeight.w600)),
              Text(child.quizzoId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 3)),
              const Text('Share this ID to receive challenges!', style: TextStyle(color: Color(0xFFD4CAFE), fontSize: 11)),
            ])),
          ])).animate().fadeIn(),
        const SizedBox(height: 20),

        // Search friend
        Container(padding: const EdgeInsets.all(18), decoration: AppDeco.card(color: AppColors.bgCard),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Find a Friend 🔍', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Container(
              decoration: BoxDecoration(color: AppColors.bgCardL, borderRadius: BorderRadius.circular(12)),
              child: const TextField(style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Enter Quizzo ID...', hintStyle: TextStyle(color: AppColors.textG),
                  border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textG))))),
            const SizedBox(width: 10),
            Container(width: 48, height: 48, decoration: BoxDecoration(gradient: AppColors.purpleGrad, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.send_rounded, color: Colors.white, size: 20))),
          ]),
        ])).animate(delay: 100.ms).fadeIn(),
        const SizedBox(height: 20),

        const Text('Battle Modes 🎮', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),

        ...modes.asMap().entries.map((e) {
          final m = e.value; final c = m['color'] as Color; final tag = m['tag'] as String;
          final isLive = tag == 'LIVE';
          return GestureDetector(
            onTap: isLive ? () => _startBattle(context) : null,
            child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(18),
              decoration: AppDeco.card(color: AppColors.bgCard, glow: isLive, glowColor: c),
              child: Row(children: [
                Text(m['emoji'] as String, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(m['desc'] as String, style: const TextStyle(color: AppColors.textG, fontSize: 12)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: c.withOpacity(isLive?0.3:0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text(tag, style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 10))),
              ])).animate(delay: Duration(milliseconds: 200+e.key*80)).fadeIn().slideX(begin: 0.2, end: 0));
        }),

        const SizedBox(height: 20),
        // Safety note
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.green.withOpacity(0.3), width: 1)),
          child: const Row(children: [
            Text('🛡️', style: TextStyle(fontSize: 20)), SizedBox(width: 10),
            Expanded(child: Text('All battles are safe! No open chat. Only predefined messages allowed. Parents can disable multiplayer anytime.',
              style: TextStyle(color: AppColors.green, fontSize: 12, height: 1.4))),
          ])),
      ])))));
  }

  void _startBattle(BuildContext context) {
    showDialog(context: context, builder: (_) => Dialog(
      backgroundColor: AppColors.bgCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('⚔️', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('Start 1v1 Battle?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Choose a subject to battle in:', style: TextStyle(color: AppColors.textG)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
          children: SubjectService.subjects.take(6).map((s) => GestureDetector(
            onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/game', arguments: {'subjectId': s.id, 'difficulty': 'easy'}); },
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Color(s.gradColors[0]).withOpacity(0.2), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(s.gradColors[0]).withOpacity(0.5), width: 1.5)),
              child: Text('${s.emoji} ${s.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))))).toList()),
        const SizedBox(height: 16),
        GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w700))),
      ]))));
  }
}

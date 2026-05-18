import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final child = context.watch<AppProvider>().child;
    return Scaffold(body: Container(decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 14),
          const Text('🏆 Global Leaderboard', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        ])),
        const SizedBox(height: 16),
        const Expanded(child: Center(child: Text('Full leaderboard coming soon!', style: TextStyle(color: AppColors.textG)))),
      ]))));
  }
}

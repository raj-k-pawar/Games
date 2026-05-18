import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});
  @override State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final parent = app.parent;
    final child = app.child;

    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Row(children: [
          GestureDetector(onTap: () {
            app.switchToChild();
            Navigator.pushReplacementNamed(context, '/home');
          }, child: Container(width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('👨‍👩‍👧 Parent Dashboard', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            Text('Welcome, ${parent?.name ?? "Parent"}!', style: const TextStyle(color: AppColors.textG, fontSize: 12)),
          ])),
          GestureDetector(onTap: () async { await app.logoutParent(); if (context.mounted) Navigator.pushReplacementNamed(context, '/onboarding'); },
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: AppColors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.red.withOpacity(0.4), width: 1)),
              child: const Text('Logout', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 12)))),
        ])),
        const SizedBox(height: 14),
        // Child card
        if (child != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(padding: const EdgeInsets.all(16),
            decoration: AppDeco.card(grad: [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)], glow: true, glowColor: AppColors.blue),
            child: Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: Center(child: Text(AvatarService.emoji(child.avatarId), style: const TextStyle(fontSize: 32)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(child.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                Text('Level ${child.level} • ${child.streak} day streak 🔥', style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12)),
                const SizedBox(height: 6),
                LinearPercentIndicator(lineHeight: 8, percent: child.xpPct,
                  backgroundColor: Colors.white.withOpacity(0.2), progressColor: Colors.white,
                  barRadius: const Radius.circular(6), padding: EdgeInsets.zero),
              ])),
            ]))),
        const SizedBox(height: 14),
        // Tabs
        Container(margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
          child: TabBar(controller: _tab,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(gradient: AppColors.blueGrad, borderRadius: BorderRadius.circular(14)),
            labelColor: Colors.white, unselectedLabelColor: AppColors.textG,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            dividerColor: Colors.transparent,
            tabs: const [Tab(text:'📊 Progress'), Tab(text:'⏰ Screen Time'), Tab(text:'⚙️ Settings')])),
        const SizedBox(height: 14),
        Expanded(child: TabBarView(controller: _tab, children: [
          _ProgressTab(child: child),
          _ScreenTimeTab(),
          _SettingsTab(),
        ])),
      ]))));
  }
}

class _ProgressTab extends StatelessWidget {
  final dynamic child;
  const _ProgressTab({required this.child});
  @override
  Widget build(BuildContext context) {
    if (child == null) return const Center(child: Text('No child profile', style: TextStyle(color: AppColors.textG)));
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Overall stats
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
        children: [
          _PStatCard('🧠', 'XP Earned', '${child.xp}', AppColors.primary),
          _PStatCard('🪙', 'Coins', '${child.coins}', AppColors.yellow),
          _PStatCard('🎯', 'Accuracy', '${(child.accuracy*100).round()}%', AppColors.green),
          _PStatCard('❓', 'Questions', '${child.totalAnswered}', AppColors.blue),
        ]),
      const SizedBox(height: 20),
      const Text('Subject Performance 📚', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      if ((child.progress as Map).isEmpty)
        Container(padding: const EdgeInsets.all(24), decoration: AppDeco.card(color: AppColors.bgCard),
          child: const Center(child: Column(children: [
            Text('🎮', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Text('No games played yet!', style: TextStyle(color: AppColors.textG, fontSize: 14, fontWeight: FontWeight.w700)),
          ])))
      else ...SubjectService.subjects.map((s) {
        final prog = child.progress[s.id];
        if (prog == null) return const SizedBox.shrink();
        final c = Color(s.gradColors[0]);
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
          decoration: AppDeco.card(color: AppColors.bgCard),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(s.emoji, style: const TextStyle(fontSize: 22)), const SizedBox(width: 10),
              Expanded(child: Text(s.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [const Text('⭐', style: TextStyle(fontSize: 12)), const SizedBox(width: 3), Text('${prog.totalStars}', style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 12))])),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _Mini('🎮', '${prog.gamesPlayed}', 'Games'),
              _Mini('🏆', '${prog.highScore}', 'Best'),
              _Mini('✅', '${prog.totalCorrect}', 'Correct'),
            ]),
            const SizedBox(height: 10),
            LinearPercentIndicator(lineHeight: 8, percent: (prog.gamesPlayed/20).clamp(0.0,1.0),
              backgroundColor: AppColors.bgDark, progressColor: c,
              barRadius: const Radius.circular(6), padding: EdgeInsets.zero),
          ])).animate(delay: const Duration(milliseconds: 100)).fadeIn().slideX(begin: 0.2, end: 0);
      }),
      const SizedBox(height: 20),
    ]));
  }
}

class _PStatCard extends StatelessWidget {
  final String emoji, label, value; final Color color;
  const _PStatCard(this.emoji, this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14),
    decoration: AppDeco.card(color: AppColors.bgCard),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
        Text(label, style: const TextStyle(color: AppColors.textG, fontSize: 11)),
      ]),
    ]));
}

class _Mini extends StatelessWidget {
  final String e, v, l;
  const _Mini(this.e, this.v, this.l);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(e, style: const TextStyle(fontSize: 18)),
    Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
    Text(l, style: const TextStyle(color: AppColors.textG, fontSize: 10)),
  ]);
}

class _ScreenTimeTab extends StatefulWidget {
  @override State<_ScreenTimeTab> createState() => _ScreenTimeTabState();
}

class _ScreenTimeTabState extends State<_ScreenTimeTab> {
  double _limit = 60;
  bool _breakReminder = true, _focusMode = false;
  TimeOfDay _bedtime = const TimeOfDay(hour: 21, minute: 0);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
    Container(padding: const EdgeInsets.all(20), decoration: AppDeco.card(color: AppColors.bgCard), child: Column(children: [
      const Row(children: [Text('⏰', style: TextStyle(fontSize: 22)), SizedBox(width: 10), Text('Daily Time Limit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))]),
      const SizedBox(height: 14),
      Center(child: Text('${_limit.round()} min', style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900, fontSize: 36))),
      Slider(value: _limit, min: 15, max: 180, divisions: 11, activeColor: AppColors.blue, inactiveColor: AppColors.bgCardL, onChanged: (v) => setState(() => _limit=v)),
      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('15 min', style: TextStyle(color: AppColors.textG, fontSize: 12)),
        Text('3 hours', style: TextStyle(color: AppColors.textG, fontSize: 12)),
      ]),
    ])).animate().fadeIn().slideY(begin: 0.2, end: 0),
    const SizedBox(height: 12),
    _Toggle('🔔', 'Break Reminders', 'Remind every 20 minutes to rest', _breakReminder, AppColors.green, (v) => setState(()=>_breakReminder=v)),
    const SizedBox(height: 10),
    _Toggle('🎯', 'Focus Mode', 'Hide shop & cosmetics during play', _focusMode, AppColors.orange, (v) => setState(()=>_focusMode=v)),
    const SizedBox(height: 12),
    // Bedtime
    Container(padding: const EdgeInsets.all(16), decoration: AppDeco.card(color: AppColors.bgCard),
      child: Row(children: [
        const Text('🌙', style: TextStyle(fontSize: 22)), const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Bedtime Lock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
          Text('App locks after ${_bedtime.format(context)}', style: const TextStyle(color: AppColors.textG, fontSize: 12)),
        ])),
        GestureDetector(onTap: () async {
          final t = await showTimePicker(context: context, initialTime: _bedtime,
            builder: (ctx, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)), child: child!));
          if (t != null) setState(() => _bedtime = t);
        }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(gradient: AppColors.purpleGrad, borderRadius: BorderRadius.circular(12)),
          child: Text(_bedtime.format(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))),
      ])).animate(delay: 200.ms).fadeIn(),
    const SizedBox(height: 12),
    // This week usage
    Container(padding: const EdgeInsets.all(20), decoration: AppDeco.card(color: AppColors.bgCard),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("This Week's Usage 📅", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 14),
        ...[['Mon',0.6,'36m'],['Tue',0.8,'48m'],['Wed',0.4,'24m'],['Thu',1.0,'60m'],['Fri',0.7,'42m'],['Sat',0.5,'30m'],['Sun',0.2,'12m']].map((d) =>
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
            SizedBox(width: 36, child: Text(d[0] as String, style: const TextStyle(color: AppColors.textG, fontSize: 12, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(
              value: d[1] as double, backgroundColor: AppColors.bgDark,
              valueColor: AlwaysStoppedAnimation((d[1] as double)>=1.0?AppColors.red:AppColors.blue), minHeight: 10))),
            const SizedBox(width: 8),
            SizedBox(width: 36, child: Text(d[2] as String, style: const TextStyle(color: AppColors.textL, fontSize: 12))),
          ]))),
      ])).animate(delay: 250.ms).fadeIn(),
    const SizedBox(height: 20),
  ]));
}

class _Toggle extends StatelessWidget {
  final String emoji, title, subtitle; final bool value; final Color color; final ValueChanged<bool> onChanged;
  const _Toggle(this.emoji, this.title, this.subtitle, this.value, this.color, this.onChanged);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16),
    decoration: AppDeco.card(color: AppColors.bgCard),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)), const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
        Text(subtitle, style: const TextStyle(color: AppColors.textG, fontSize: 12)),
      ])),
      Switch(value: value, onChanged: onChanged, activeColor: color),
    ]));
}

class _SettingsTab extends StatefulWidget {
  @override State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  bool _safeMode=true, _leaderboard=true, _multiplayer=true, _weeklyReport=true;
  String _age = '8-12';
  String _difficulty = 'auto';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Age Group', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
    const SizedBox(height: 10),
    Row(children: ['5-7','8-12','13-15'].map((a) => Expanded(child: GestureDetector(onTap: () => setState(()=>_age=a),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(gradient: a==_age?AppColors.purpleGrad:null, color: a!=_age?AppColors.bgCard:null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: a==_age?Colors.transparent:AppColors.bgCardL, width: 2)),
        child: Center(child: Text(a, style: TextStyle(color: a==_age?Colors.white:AppColors.textG, fontWeight: FontWeight.w800, fontSize: 14)))))).toList()),
    const SizedBox(height: 18),
    const Text('Difficulty', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
    const SizedBox(height: 10),
    Row(children: ['auto','easy','medium','hard'].map((d) => Expanded(child: GestureDetector(onTap: () => setState(()=>_difficulty=d),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(gradient: d==_difficulty?AppColors.blueGrad:null, color: d!=_difficulty?AppColors.bgCard:null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: d==_difficulty?Colors.transparent:AppColors.bgCardL, width: 2)),
        child: Center(child: Text(d[0].toUpperCase()+d.substring(1), style: TextStyle(color: d==_difficulty?Colors.white:AppColors.textG, fontWeight: FontWeight.w800, fontSize: 11)))))).toList()),
    const SizedBox(height: 18),
    const Text('Safety & Features', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
    const SizedBox(height: 10),
    _Toggle('🛡️','Safe Mode','Filter all content for child safety',_safeMode,AppColors.green,(v)=>setState(()=>_safeMode=v)),
    const SizedBox(height: 8),
    _Toggle('🏆','Show Leaderboard','Allow child to see rankings',_leaderboard,AppColors.yellow,(v)=>setState(()=>_leaderboard=v)),
    const SizedBox(height: 8),
    _Toggle('⚔️','Multiplayer/Battle','Allow competing with friends',_multiplayer,AppColors.blue,(v)=>setState(()=>_multiplayer=v)),
    const SizedBox(height: 8),
    _Toggle('📧','Weekly Reports','Receive learning summaries',_weeklyReport,AppColors.cyan,(v)=>setState(()=>_weeklyReport=v)),
    const SizedBox(height: 20),
    GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Settings saved!'), backgroundColor: AppColors.green, behavior: SnackBarBehavior.floating)),
      child: Container(height: 54, decoration: BoxDecoration(gradient: AppColors.blueGrad, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.blue.withOpacity(0.4), blurRadius: 20, offset: const Offset(0,6))]),
        child: const Center(child: Text('💾 Save Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))))),
    const SizedBox(height: 20),
  ]));
}

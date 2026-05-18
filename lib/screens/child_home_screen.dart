import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});
  @override State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: const [_HomeTab(), _LeaderboardTab(), _ProfileTab()]),
      bottomNavigationBar: _NavBar(selected: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final child = app.child;
    if (child == null) return const SizedBox.shrink();
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top bar
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$greeting! ☀️', style: const TextStyle(color: AppColors.textG, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(child.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              ])),
              // Streak
              GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(gradient: AppColors.orangeGrad, borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  const Text('🔥', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text('${child.streak}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                ]))),
              const SizedBox(width: 10),
              // Avatar
              GestureDetector(onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Container(width: 46, height: 46,
                  decoration: BoxDecoration(gradient: AppColors.purpleGrad, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12)]),
                  child: Center(child: Text(AvatarService.emoji(child.avatarId), style: const TextStyle(fontSize: 24))))),
            ]),
            const SizedBox(height: 18),

            // Currency chips
            Row(children: [
              _Chip('🪙', child.coins, AppColors.yellow),
              const SizedBox(width: 8),
              _Chip('💎', child.gems, AppColors.cyan),
              const SizedBox(width: 8),
              _Chip('⭐', child.xp, AppColors.primary, label: 'XP'),
            ]).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),

            // XP bar
            _XPBar(child: child).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 20),

            // Daily challenge banner
            _DailyBanner().animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: 22),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Choose a Subject 📚', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
              GestureDetector(onTap: () => Navigator.pushNamed(context, '/challenge'),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(gradient: AppColors.pinkGrad, borderRadius: BorderRadius.circular(12)),
                  child: const Text('⚔️ Battle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)))),
            ]).animate(delay: 400.ms).fadeIn(),
            const SizedBox(height: 14),
          ],
        ))),

        // Subject grid
        SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              final s = SubjectService.subjects[i];
              return _SubjectCard(subject: s, index: i)
                .animate(delay: Duration(milliseconds: 500+i*50))
                .fadeIn().scale(begin: const Offset(0.85,0.85), end: const Offset(1,1));
            }, childCount: SubjectService.subjects.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.05),
          )),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ])),
    );
  }
}

class _Chip extends StatelessWidget {
  final String emoji; final int value; final Color color; final String? label;
  const _Chip(this.emoji, this.value, this.color, {this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3), width: 1.5)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 15)),
      const SizedBox(width: 5),
      Text(label!=null?'${_fmt(value)} $label':_fmt(value),
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
    ]));
  static String _fmt(int n) => n >= 1000 ? '${(n/1000).toStringAsFixed(1)}k' : '$n';
}

class _XPBar extends StatelessWidget {
  final dynamic child;
  const _XPBar({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: AppDeco.card(color: AppColors.bgCard),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Level ${child.level}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
        Text('${child.xp} / ${child.xpForNext} XP', style: const TextStyle(color: AppColors.textG, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 10),
      LinearPercentIndicator(lineHeight: 12, percent: child.xpPct, backgroundColor: AppColors.bgDark,
        linearGradient: AppColors.purpleGrad, barRadius: const Radius.circular(8), padding: EdgeInsets.zero),
      const SizedBox(height: 5),
      Text('${child.xpForNext - child.xp} XP to Level ${child.level+1} 🚀',
        style: const TextStyle(color: AppColors.textG, fontSize: 11, fontWeight: FontWeight.w600)),
    ]));
}

class _DailyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pushNamed(context, '/game_select', arguments: 'mathematics'),
    child: Container(padding: const EdgeInsets.all(18),
      decoration: AppDeco.card(grad: [const Color(0xFF7C3AED), const Color(0xFF9B59F5)], glow: true),
      child: Row(children: [
        const Text('⚡', style: TextStyle(fontSize: 38)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Daily Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
          const Text("Complete today's challenge for bonus rewards!", style: TextStyle(color: Color(0xFFD4CAFE), fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: [
            _Tag('🪙 +100'), const SizedBox(width: 8), _Tag('💎 +3'), const SizedBox(width: 8), _Tag('⭐ +50 XP'),
          ]),
        ])),
        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
      ])));
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)));
}

class _SubjectCard extends StatelessWidget {
  final dynamic subject; final int index;
  const _SubjectCard({required this.subject, required this.index});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final prog = app.child?.progress[subject.id];
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/game_select', arguments: subject.id),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: subject.gradColors.map<Color>((c) => Color(c as int)).toList(), begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Color(subject.gradColors[0] as int).withOpacity(0.4), blurRadius: 14, offset: const Offset(0,4))]),
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(subject.emoji, style: const TextStyle(fontSize: 30)),
            if (prog != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Text('⭐', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 3),
                Text('${prog.totalStars}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ])),
          ]),
          const Spacer(),
          Text(subject.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
          Text(subject.description, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
          if (prog != null) ...[
            const SizedBox(height: 7),
            LinearPercentIndicator(lineHeight: 5, percent: (prog.gamesPlayed/20).clamp(0.0,1.0),
              backgroundColor: Colors.white.withOpacity(0.2), progressColor: Colors.white,
              barRadius: const Radius.circular(4), padding: EdgeInsets.zero),
          ],
        ]))));
  }
}

// ─── Leaderboard Tab ──────────────────────────────────────────────────────────
class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();
  @override
  Widget build(BuildContext context) {
    final child = context.watch<AppProvider>().child;
    final players = [
      {'name':'Arjun K','xp':4200,'emoji':'🦁','level':9},
      {'name':'Priya S','xp':3800,'emoji':'🦄','level':8},
      {'name':'Rohan M','xp':3200,'emoji':'🐉','level':7},
      if (child!=null) {'name':child.name,'xp':child.xp,'emoji':AvatarService.emoji(child.avatarId),'level':child.level,'isMe':true},
      {'name':'Aisha P','xp':2400,'emoji':'🦋','level':5},
      {'name':'Dev R','xp':1900,'emoji':'🐺','level':4},
      {'name':'Sara T','xp':1500,'emoji':'🐼','level':3},
    ]..sort((a,b)=>(b['xp'] as int).compareTo(a['xp'] as int));

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,12), child: Row(children: [
          const Text('🏆 Leaderboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
            child: const Text('This Week', style: TextStyle(color: AppColors.textG, fontSize: 12, fontWeight: FontWeight.w700))),
        ])),
        // Podium
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _Podium(players: players.take(3).toList())),
        const SizedBox(height: 12),
        // List
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: players.length > 3 ? players.length - 3 : 0,
          itemBuilder: (ctx, i) {
            final p = players[i+3];
            final isMe = p['isMe'] == true;
            return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: isMe?AppColors.primary.withOpacity(0.2):AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isMe?AppColors.primary:Colors.transparent, width: 1.5)),
              child: Row(children: [
                Text('#${i+4}', style: const TextStyle(color: AppColors.textG, fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(width: 12),
                Text(p['emoji'] as String, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(child: Text('${p['name']}${isMe?' (You)':''}',
                  style: TextStyle(color: isMe?AppColors.primary:Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${p['xp']} XP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                  Text('Lv ${p['level']}', style: const TextStyle(color: AppColors.textG, fontSize: 11)),
                ]),
              ])).animate(delay: Duration(milliseconds: i*60)).fadeIn().slideX(begin: 0.2, end: 0);
          })),
      ])));
  }
}

class _Podium extends StatelessWidget {
  final List<Map<String,dynamic>> players;
  const _Podium({required this.players});
  @override
  Widget build(BuildContext context) {
    if (players.length < 3) return const SizedBox.shrink();
    return Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
      _PodiumItem(p: players[1], rank: 2, h: 85),
      const SizedBox(width: 8),
      _PodiumItem(p: players[0], rank: 1, h: 115),
      const SizedBox(width: 8),
      _PodiumItem(p: players[2], rank: 3, h: 65),
    ]);
  }
}

class _PodiumItem extends StatelessWidget {
  final Map<String,dynamic> p; final int rank; final double h;
  const _PodiumItem({required this.p, required this.rank, required this.h});
  @override
  Widget build(BuildContext context) {
    final color = rank==1?AppColors.yellow:rank==2?AppColors.textG:const Color(0xFFCD7F32);
    return Expanded(child: Column(children: [
      Text(p['emoji'] as String, style: const TextStyle(fontSize: 28)),
      const SizedBox(height: 4),
      Text(p['name'] as String, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
      Text('${p['xp']} XP', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10)),
      const SizedBox(height: 4),
      Container(height: h, decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.6), color.withOpacity(0.3)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Center(child: Text(rank==1?'🥇':rank==2?'🥈':'🥉', style: const TextStyle(fontSize: 26)))),
    ]));
  }
}

// ─── Profile Tab ──────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  static const _badges = [
    {'id':'explorer','emoji':'🗺️','name':'Explorer','desc':'Play 3 subjects'},
    {'id':'week_streak','emoji':'🔥','name':'7-Day Streak','desc':'Play 7 days in a row'},
    {'id':'century','emoji':'💯','name':'Century','desc':'Answer 100 questions'},
    {'id':'level_5','emoji':'🏆','name':'Level 5','desc':'Reach level 5'},
    {'id':'rich','emoji':'💰','name':'Rich','desc':'Earn 1000 coins'},
    {'id':'star_collector','emoji':'⭐','name':'Star Collector','desc':'Get 3 stars on a game'},
  ];
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final child = app.child!;
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('👤 Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),

        // Profile hero
        Container(padding: const EdgeInsets.all(20),
          decoration: AppDeco.card(grad: [const Color(0xFF6C3CE1), const Color(0xFF9B59F5)], glow: true),
          child: Row(children: [
            Container(width: 70, height: 70,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Center(child: Text(AvatarService.emoji(child.avatarId), style: const TextStyle(fontSize: 38)))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(child.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              Text('Level ${child.level} Hero', style: const TextStyle(color: Color(0xFFD4CAFE), fontSize: 13)),
              const SizedBox(height: 6),
              Text('ID: ${child.quizzoId}', style: const TextStyle(color: Color(0xFFD4CAFE), fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(children: [
                _StatPill('🔥', '${child.streak}d streak'),
                const SizedBox(width: 8),
                _StatPill('🎯', '${(child.accuracy*100).round()}% acc'),
              ]),
            ])),
          ])),
        const SizedBox(height: 16),

        // Quick actions
        Row(children: [
          Expanded(child: _ActionBtn('🛒 Shop', AppColors.orangeGrad, () => Navigator.pushNamed(context, '/shop'))),
          const SizedBox(width: 12),
          Expanded(child: _ActionBtn('👨‍👩‍👧 Parents', AppColors.blueGrad, () => Navigator.pushNamed(context, '/parent_login'))),
        ]),
        const SizedBox(height: 16),

        // Stats grid
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
          children: [
            _StatCard('🪙','Coins','${child.coins}',AppColors.yellow),
            _StatCard('💎','Gems','${child.gems}',AppColors.cyan),
            _StatCard('❓','Questions','${child.totalAnswered}',AppColors.blue),
            _StatCard('✅','Correct','${child.totalCorrect}',AppColors.green),
          ]),
        const SizedBox(height: 20),

        const Text('🏅 Badges', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
          children: _badges.map((b) {
            final earned = child.badges.contains(b['id']);
            return Container(
              decoration: BoxDecoration(color: earned?AppColors.primary.withOpacity(0.2):AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: earned?AppColors.primary:AppColors.bgCardL, width: 1.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(b['emoji']!, style: TextStyle(fontSize: 26, color: earned?null:const Color(0x44FFFFFF))),
                const SizedBox(height: 4),
                Text(b['name']!, textAlign: TextAlign.center,
                  style: TextStyle(color: earned?Colors.white:AppColors.textG, fontSize: 10, fontWeight: FontWeight.w700)),
              ]));
          }).toList()),
        const SizedBox(height: 20),

        // Sign out
        GestureDetector(onTap: () async {
          await context.read<AppProvider>().logoutChild();
          if (context.mounted) Navigator.pushReplacementNamed(context, '/onboarding');
        }, child: Container(height: 50,
          decoration: BoxDecoration(color: AppColors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.red.withOpacity(0.4), width: 1.5)),
          child: const Center(child: Text('🚪 Sign Out', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w800, fontSize: 15))))),
      ]))));
  }
}

class _StatPill extends StatelessWidget {
  final String e, label;
  const _StatPill(this.e, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(e, style: const TextStyle(fontSize: 12)), const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    ]));
}

class _ActionBtn extends StatelessWidget {
  final String label; final LinearGradient grad; final VoidCallback onTap;
  const _ActionBtn(this.label, this.grad, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(height: 50,
    decoration: BoxDecoration(gradient: grad, borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: grad.colors.first.withOpacity(0.3), blurRadius: 12)]),
    child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)))));
}

class _StatCard extends StatelessWidget {
  final String emoji, label, value; final Color color;
  const _StatCard(this.emoji, this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14),
    decoration: AppDeco.card(color: AppColors.bgCard),
    child: Row(children: [
      Container(width: 42, height: 42,
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
        Text(label, style: const TextStyle(color: AppColors.textG, fontSize: 11)),
      ]),
    ]));
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final int selected; final Function(int) onTap;
  const _NavBar({required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: AppColors.bgCard, border: Border(top: BorderSide(color: AppColors.bgCardL, width: 1)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0,-5))]),
    child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _NavItem(icon: '🏠', label: 'Home',  index: 0, sel: selected, onTap: onTap),
        _NavItem(icon: '🏆', label: 'Ranks', index: 1, sel: selected, onTap: onTap),
        _NavItem(icon: '👤', label: 'Profile',index: 2, sel: selected, onTap: onTap),
      ]))));
}

class _NavItem extends StatelessWidget {
  final String icon, label; final int index, sel; final Function(int) onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.sel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final active = index == sel;
    return GestureDetector(onTap: () => onTap(index), behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(color: active?AppColors.primary.withOpacity(0.2):Colors.transparent, borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(icon, style: TextStyle(fontSize: active?26:22)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: active?AppColors.primary:AppColors.textG, fontSize: 11, fontWeight: FontWeight.w700)),
        ])));
  }
}

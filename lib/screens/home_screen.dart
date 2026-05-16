import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../services/subject_data.dart';
import '../models/question_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: const [
              _HomeTab(),
              _LeaderboardTab(),
              _ProfileTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgCardLight, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: '🏠', label: 'Home', index: 0, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
              _NavItem(icon: '🏆', label: 'Ranks', index: 1, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
              _NavItem(icon: '👤', label: 'Profile', index: 2, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: const TextStyle(
                            color: AppColors.textGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    // Avatar + streak
                    Row(
                      children: [
                        // Streak badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '${user.streak}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.purpleGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withOpacity(0.4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _avatarEmoji(user.avatarId),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Currency row
                Row(
                  children: [
                    _CurrencyChip(emoji: '🪙', value: user.coins, color: AppColors.primaryYellow),
                    const SizedBox(width: 10),
                    _CurrencyChip(emoji: '💎', value: user.gems, color: AppColors.primaryCyan),
                    const SizedBox(width: 10),
                    _CurrencyChip(emoji: '⭐', value: user.xp, color: AppColors.primaryPurple, label: 'XP'),
                  ],
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                // XP progress bar
                _XPCard(user: user).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Daily challenge banner
                _DailyChallengeBanner()
                    .animate(delay: 300.ms)
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                const Text(
                  'Choose a Subject 📚',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Subject grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final subject = SubjectData.subjects[i];
                return _SubjectCard(subject: subject, index: i)
                    .animate(delay: Duration(milliseconds: 500 + i * 60))
                    .fadeIn()
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
              },
              childCount: SubjectData.subjects.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning! ☀️';
    if (hour < 17) return 'Good Afternoon! 🌤️';
    return 'Good Evening! 🌙';
  }

  String _avatarEmoji(String avatarId) {
    const map = {
      'avatar_1': '🦊', 'avatar_2': '🐼', 'avatar_3': '🦁',
      'avatar_4': '🐸', 'avatar_5': '🐯', 'avatar_6': '🦄',
      'avatar_7': '🐺', 'avatar_8': '🦋', 'avatar_9': '🐉',
      'avatar_10': '🦅', 'avatar_11': '🐬', 'avatar_12': '🦊',
    };
    return map[avatarId] ?? '🦊';
  }
}

class _CurrencyChip extends StatelessWidget {
  final String emoji;
  final int value;
  final Color color;
  final String? label;

  const _CurrencyChip({
    required this.emoji,
    required this.value,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 5),
          Text(
            label != null ? '${_formatNum(value)} $label' : _formatNum(value),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _XPCard extends StatelessWidget {
  final dynamic user;
  const _XPCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.cardDecoration(
        gradientColors: [const Color(0xFF1A1035), const Color(0xFF241848)],
        glow: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level ${user.level}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                '${user.xp} / ${user.xpForNextLevel} XP',
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 12,
            percent: user.xpProgress.clamp(0.0, 1.0),
            backgroundColor: AppColors.bgDark,
            linearGradient: AppColors.purpleGradient,
            barRadius: const Radius.circular(8),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 6),
          Text(
            '${user.xpForNextLevel - user.xp} XP to Level ${user.level + 1} 🚀',
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyChallengeBanner extends StatelessWidget {
  const _DailyChallengeBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to subject selection with daily challenge
        Navigator.pushNamed(context, '/subjects');
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppDecorations.cardDecoration(
          gradientColors: [const Color(0xFF7C3AED), const Color(0xFF9B59F5)],
          glow: true,
          glowColor: AppColors.primaryPurple,
        ),
        child: Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Challenge',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Complete today\'s challenge for bonus rewards!',
                    style: TextStyle(
                      color: Color(0xFFD4CAFE),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _RewardTag(emoji: '🪙', value: '+50'),
                      const SizedBox(width: 8),
                      _RewardTag(emoji: '💎', value: '+2'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

class _RewardTag extends StatelessWidget {
  final String emoji;
  final String value;
  const _RewardTag({required this.emoji, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final int index;

  const _SubjectCard({required this.subject, required this.index});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final progress = user?.subjectProgress[subject.id];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/game_select', arguments: subject.id);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: subject.gradientColors.map((c) => Color(c)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(subject.gradientColors.first).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subject.emoji, style: const TextStyle(fontSize: 32)),
                  if (progress != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 2),
                          Text(
                            '${progress.totalStars}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                subject.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subject.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  lineHeight: 6,
                  percent: (progress.gamesPlayed / 10).clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  progressColor: Colors.white,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Leaderboard Tab ──────────────────────────────────────────────────────────

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;
    // Simulate leaderboard data
    final players = [
      {'name': 'Arjun K', 'xp': 4200, 'avatar': '🦁', 'level': 9},
      {'name': 'Priya S', 'xp': 3800, 'avatar': '🦄', 'level': 8},
      {'name': 'Rohan M', 'xp': 3200, 'avatar': '🐉', 'level': 7},
      {'name': user.name, 'xp': user.xp, 'avatar': '🦊', 'level': user.level, 'isMe': true},
      {'name': 'Aisha P', 'xp': 2400, 'avatar': '🦋', 'level': 5},
      {'name': 'Dev R', 'xp': 1900, 'avatar': '🐺', 'level': 4},
      {'name': 'Sara T', 'xp': 1500, 'avatar': '🐼', 'level': 4},
    ];

    players.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              const Text(
                '🏆 Leaderboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('This Week', style: TextStyle(color: AppColors.textGray, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Top 3 podium
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _Podium(players: players.take(3).toList()),
        ),
        const SizedBox(height: 20),
        // Rest of list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: players.length > 3 ? players.length - 3 : 0,
            itemBuilder: (context, i) {
              final player = players[i + 3];
              final isMe = player['isMe'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryPurple.withOpacity(0.2) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isMe ? AppColors.primaryPurple : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '#${i + 4}',
                      style: const TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(player['avatar'] as String, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${player['name']}${isMe ? ' (You)' : ''}',
                        style: TextStyle(
                          color: isMe ? AppColors.primaryPurple : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${player['xp']} XP',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        Text('Level ${player['level']}', style: const TextStyle(color: AppColors.textGray, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  const _Podium({required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.length < 3) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 2nd place
        _PodiumItem(player: players[1], rank: 2, height: 90),
        const SizedBox(width: 8),
        // 1st place
        _PodiumItem(player: players[0], rank: 1, height: 120),
        const SizedBox(width: 8),
        // 3rd place
        _PodiumItem(player: players[2], rank: 3, height: 70),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final Map<String, dynamic> player;
  final int rank;
  final double height;

  const _PodiumItem({required this.player, required this.rank, required this.height});

  @override
  Widget build(BuildContext context) {
    final colors = {1: AppColors.primaryYellow, 2: AppColors.textGray, 3: const Color(0xFFCD7F32)};
    final color = colors[rank]!;

    return Expanded(
      child: Column(
        children: [
          Text(player['avatar'] as String, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(
            player['name'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          Text('${player['xp']} XP', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11)),
          const SizedBox(height: 4),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                rank == 1 ? '🥇' : rank == 2 ? '🥈' : '🥉',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Tab ──────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;
    final badges = [
      {'id': 'perfect_score', 'emoji': '⭐', 'name': 'Perfect Score', 'desc': 'Get 3 stars on any game'},
      {'id': 'week_streak', 'emoji': '🔥', 'name': '7-Day Streak', 'desc': 'Play 7 days in a row'},
      {'id': 'century', 'emoji': '💯', 'name': 'Century', 'desc': 'Answer 100 questions'},
      {'id': 'level_5', 'emoji': '🏆', 'name': 'Level 5', 'desc': 'Reach level 5'},
      {'id': 'explorer', 'emoji': '🗺️', 'name': 'Explorer', 'desc': 'Play 5 different subjects'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👤 Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 20),

          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(
              gradientColors: [const Color(0xFF6C3CE1), const Color(0xFF9B59F5)],
              glow: true,
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(_avatarEmoji(user.avatarId), style: const TextStyle(fontSize: 40))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                      Text('Level ${user.level} Hero', style: const TextStyle(color: Color(0xFFD4CAFE), fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(children: [
                        _StatBadge('🔥', '${user.streak} day streak'),
                        const SizedBox(width: 8),
                        _StatBadge('🎯', '${(user.accuracy * 100).round()}% acc'),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _StatCard('🪙', 'Coins', user.coins.toString(), AppColors.primaryYellow),
              _StatCard('💎', 'Gems', user.gems.toString(), AppColors.primaryCyan),
              _StatCard('❓', 'Questions', user.totalQuestionsAnswered.toString(), AppColors.primaryBlue),
              _StatCard('✅', 'Correct', user.totalCorrectAnswers.toString(), AppColors.primaryGreen),
            ],
          ),

          const SizedBox(height: 24),

          // Badges
          const Text('🏅 Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: badges.map((badge) {
              final earned = user.badges.contains(badge['id']);
              return Container(
                decoration: BoxDecoration(
                  color: earned ? AppColors.primaryPurple.withOpacity(0.2) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: earned ? AppColors.primaryPurple : AppColors.bgCardLight,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      badge['emoji']!,
                      style: TextStyle(fontSize: 28, color: earned ? null : const Color(0x44FFFFFF)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge['name']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: earned ? Colors.white : AppColors.textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Quick nav buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/shop'),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primaryOrange.withOpacity(0.4), blurRadius: 15)],
                    ),
                    child: const Center(
                      child: Text('🛒 Shop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/parent'),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.blueGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.4), blurRadius: 15)],
                    ),
                    child: const Center(
                      child: Text('👨‍👩‍👧 Parents', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Logout
          GestureDetector(
            onTap: () async {
              await context.read<UserProvider>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryRed.withOpacity(0.4), width: 1.5),
              ),
              child: const Center(
                child: Text('🚪 Sign Out', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _avatarEmoji(String avatarId) {
    const map = {
      'avatar_1': '🦊', 'avatar_2': '🐼', 'avatar_3': '🦁',
      'avatar_4': '🐸', 'avatar_5': '🐯', 'avatar_6': '🦄',
      'avatar_7': '🐺', 'avatar_8': '🦋', 'avatar_9': '🐉',
      'avatar_10': '🦅', 'avatar_11': '🐬', 'avatar_12': '🦊',
    };
    return map[avatarId] ?? '🦊';
  }
}

class _StatBadge extends StatelessWidget {
  final String emoji;
  final String label;
  const _StatBadge(this.emoji, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _StatCard(this.emoji, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
              Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: isActive ? 26 : 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryPurple : AppColors.textGray,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

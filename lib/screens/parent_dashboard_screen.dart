import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/subject_data.dart';
import '../theme/app_theme.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _unlocked = false;
  final _pinController = TextEditingController();
  static const String _parentPin = '1234'; // In production, use secure storage

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: _unlocked ? _buildDashboard() : _buildPinScreen(),
        ),
      ),
    );
  }

  Widget _buildPinScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.4), blurRadius: 25)],
              ),
              child: const Center(child: Text('👨‍👩‍👧', style: TextStyle(fontSize: 42))),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

            const SizedBox(height: 24),
            const Text(
              'Parent Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your PIN to continue',
              style: TextStyle(color: AppColors.textGray, fontSize: 15),
            ),
            const SizedBox(height: 32),

            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.4), width: 2),
              ),
              child: TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 12),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '• • • •',
                  hintStyle: TextStyle(color: AppColors.textGray, letterSpacing: 12),
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
                onChanged: (val) {
                  if (val.length == 4) {
                    if (val == _parentPin) {
                      setState(() => _unlocked = true);
                    } else {
                      _pinController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Incorrect PIN. Try: 1234'),
                          backgroundColor: AppColors.primaryRed,
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Default PIN: 1234',
              style: TextStyle(color: AppColors.textGray, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 14),
              const Text('👨‍👩‍👧 Parent Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tabs
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textGray,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: '📊 Progress'),
              Tab(text: '⏰ Screen Time'),
              Tab(text: '⚙️ Settings'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ProgressTab(user: user),
              _ScreenTimeTab(),
              _ParentSettingsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Progress Tab ─────────────────────────────────────────────────────────────

class _ProgressTab extends StatelessWidget {
  final dynamic user;
  const _ProgressTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child overview card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(
              gradientColors: [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)],
              glow: true,
              glowColor: AppColors.primaryBlue,
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Center(child: Text('🦊', style: TextStyle(fontSize: 36))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                      Text('Level ${user.level} • ${user.streak} day streak 🔥',
                          style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(
                        '${user.totalQuestionsAnswered} questions answered • ${(user.accuracy * 100).round()}% accuracy',
                        style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          const Text('Subject Performance 📚',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),

          if (user.subjectProgress.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
              child: const Center(
                child: Column(
                  children: [
                    Text('🎮', style: TextStyle(fontSize: 40)),
                    SizedBox(height: 8),
                    Text('No games played yet!',
                        style: TextStyle(color: AppColors.textGray, fontSize: 15, fontWeight: FontWeight.w700)),
                    Text('Encourage your child to start learning!',
                        style: TextStyle(color: AppColors.textGray, fontSize: 13)),
                  ],
                ),
              ),
            )
          else
            ...SubjectData.subjects.map((subject) {
              final progress = user.subjectProgress[subject.id];
              if (progress == null) return const SizedBox.shrink();
              final gradColor = Color(subject.gradientColors.first);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(subject.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(subject.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                        _StarRow(stars: progress.totalStars.clamp(0, 15), color: gradColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MiniStat('🎮', '${progress.gamesPlayed}', 'Games'),
                        _MiniStat('🏆', '${progress.highScore}', 'Best Score'),
                        _MiniStat('⭐', '${progress.totalStars}', 'Stars'),
                        _MiniStat('📈', progress.difficulty.toUpperCase(), 'Level'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (progress.gamesPlayed / 20).clamp(0.0, 1.0),
                        backgroundColor: AppColors.bgDark,
                        valueColor: AlwaysStoppedAnimation(gradColor),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${progress.gamesPlayed}/20 games played',
                        style: const TextStyle(color: AppColors.textGray, fontSize: 11)),
                  ],
                ),
              ).animate(delay: 100.ms).fadeIn().slideX(begin: 0.2, end: 0);
            }),

          const SizedBox(height: 20),

          // Overall stats
          const Text('Overall Statistics 📊',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatCard2('🧠', 'Total XP', '${user.xp}', AppColors.primaryPurple),
              _StatCard2('🪙', 'Coins', '${user.coins}', AppColors.primaryYellow),
              _StatCard2('🎯', 'Accuracy', '${(user.accuracy * 100).round()}%', AppColors.primaryGreen),
              _StatCard2('🔥', 'Day Streak', '${user.streak}', AppColors.primaryOrange),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int stars;
  final Color color;
  const _StarRow({required this.stars, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⭐', style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(width: 4),
          Text('$stars', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _MiniStat(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 10)),
      ],
    );
  }
}

class _StatCard2 extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StatCard2(this.emoji, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
              Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Screen Time Tab ──────────────────────────────────────────────────────────

class _ScreenTimeTab extends StatefulWidget {
  @override
  State<_ScreenTimeTab> createState() => _ScreenTimeTabState();
}

class _ScreenTimeTabState extends State<_ScreenTimeTab> {
  double _dailyLimit = 60; // minutes
  bool _breakReminder = true;
  bool _focusMode = false;
  TimeOfDay _bedtime = const TimeOfDay(hour: 21, minute: 0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily limit card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('⏰', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 10),
                    Text('Daily Time Limit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '${_dailyLimit.round()} min',
                    style: const TextStyle(
                        color: AppColors.primaryBlue, fontWeight: FontWeight.w900, fontSize: 36),
                  ),
                ),
                Slider(
                  value: _dailyLimit,
                  min: 15,
                  max: 180,
                  divisions: 11,
                  activeColor: AppColors.primaryBlue,
                  inactiveColor: AppColors.bgCardLight,
                  onChanged: (val) => setState(() => _dailyLimit = val),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('15 min', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                    const Text('3 hours', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 14),

          // Toggles
          _ToggleCard(
            emoji: '🔔',
            title: 'Break Reminders',
            subtitle: 'Remind every 20 minutes to take a break',
            value: _breakReminder,
            onChanged: (v) => setState(() => _breakReminder = v),
            color: AppColors.primaryGreen,
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 10),

          _ToggleCard(
            emoji: '🎯',
            title: 'Focus Mode',
            subtitle: 'Hide rewards & cosmetics during study',
            value: _focusMode,
            onChanged: (v) => setState(() => _focusMode = v),
            color: AppColors.primaryOrange,
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 14),

          // Bedtime setting
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
            child: Row(
              children: [
                const Text('🌙', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bedtime Lock',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                      Text('App locked after ${_bedtime.format(context)}',
                          style: const TextStyle(color: AppColors.textGray, fontSize: 13)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _bedtime,
                      builder: (context, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(primary: AppColors.primaryPurple),
                        ),
                        child: child!,
                      ),
                    );
                    if (time != null) setState(() => _bedtime = time);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _bedtime.format(context),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),

          // This week's usage (simulated)
          const Text('This Week\'s Usage 📅',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total time this week',
                        style: TextStyle(color: AppColors.textGray, fontSize: 13)),
                    Text('3h 42m', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                ...[
                  ['Mon', 0.6, '36m'],
                  ['Tue', 0.8, '48m'],
                  ['Wed', 0.4, '24m'],
                  ['Thu', 1.0, '60m'],
                  ['Fri', 0.7, '42m'],
                  ['Sat', 0.5, '30m'],
                  ['Sun', 0.2, '12m'],
                ].map((day) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36,
                            child: Text(day[0] as String,
                                style: const TextStyle(color: AppColors.textGray, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: day[1] as double,
                                backgroundColor: AppColors.bgDark,
                                valueColor: AlwaysStoppedAnimation(
                                    (day[1] as double) >= 1.0 ? AppColors.primaryRed : AppColors.primaryBlue),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 36,
                            child: Text(day[2] as String,
                                style: const TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ).animate(delay: 250.ms).fadeIn(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  const _ToggleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

// ── Parent Settings Tab ──────────────────────────────────────────────────────

class _ParentSettingsTab extends StatefulWidget {
  @override
  State<_ParentSettingsTab> createState() => _ParentSettingsTabState();
}

class _ParentSettingsTabState extends State<_ParentSettingsTab> {
  bool _safeMode = true;
  bool _weeklyReport = true;
  bool _showLeaderboard = true;
  bool _allowMultiplayer = false;
  String _ageGroup = '8-12';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Age Group',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: ['5-7', '8-12', '13-15'].map((age) {
              final selected = age == _ageGroup;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _ageGroup = age),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.purpleGradient : null,
                      color: selected ? null : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? Colors.transparent : AppColors.bgCardLight,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        age,
                        style: TextStyle(
                          color: selected ? Colors.white : AppColors.textGray,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(),

          const SizedBox(height: 20),

          const Text('Safety & Privacy',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          _ToggleCard(
            emoji: '🛡️',
            title: 'Safe Mode',
            subtitle: 'Filter all content for child safety',
            value: _safeMode,
            onChanged: (v) => setState(() => _safeMode = v),
            color: AppColors.primaryGreen,
          ).animate(delay: 50.ms).fadeIn(),

          const SizedBox(height: 10),

          _ToggleCard(
            emoji: '🏆',
            title: 'Show Leaderboard',
            subtitle: 'Allow child to see rankings',
            value: _showLeaderboard,
            onChanged: (v) => setState(() => _showLeaderboard = v),
            color: AppColors.primaryYellow,
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 10),

          _ToggleCard(
            emoji: '👥',
            title: 'Multiplayer Mode',
            subtitle: 'Allow competing with other players',
            value: _allowMultiplayer,
            onChanged: (v) => setState(() => _allowMultiplayer = v),
            color: AppColors.primaryBlue,
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 20),

          const Text('Reports',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          _ToggleCard(
            emoji: '📧',
            title: 'Weekly Reports',
            subtitle: 'Receive learning summaries by email',
            value: _weeklyReport,
            onChanged: (v) => setState(() => _weeklyReport = v),
            color: AppColors.primaryCyan,
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),

          // Save button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ Settings saved!'),
                  backgroundColor: AppColors.primaryGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryBlue.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6)),
                ],
              ),
              child: const Center(
                child: Text('💾 Save Settings',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
              ),
            ),
          ).animate(delay: 250.ms).fadeIn(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

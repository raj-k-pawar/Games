import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/subject_data.dart';
import '../models/question_model.dart';
import '../theme/app_theme.dart';

class GameSelectScreen extends StatefulWidget {
  final String subjectId;
  const GameSelectScreen({super.key, required this.subjectId});

  @override
  State<GameSelectScreen> createState() => _GameSelectScreenState();
}

class _GameSelectScreenState extends State<GameSelectScreen> {
  String _selectedDifficulty = 'easy';
  int _selectedModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final subject = SubjectData.getById(widget.subjectId);
    if (subject == null) return const Scaffold(body: Center(child: Text('Subject not found')));

    final gradColor = Color(subject.gradientColors.first);
    final user = context.watch<UserProvider>().user;
    final progress = user?.subjectProgress[subject.id];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
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
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${subject.emoji} ${subject.name}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject hero card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: subject.gradientColors.map((c) => Color(c)).toList(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: gradColor.withOpacity(0.5),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subject.emoji, style: const TextStyle(fontSize: 50)),
                            const SizedBox(height: 10),
                            Text(
                              subject.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              subject.description,
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                            ),
                            if (progress != null) ...[
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  _InfoChip('🎮 ${progress.gamesPlayed} played'),
                                  const SizedBox(width: 8),
                                  _InfoChip('⭐ ${progress.totalStars} stars'),
                                  const SizedBox(width: 8),
                                  _InfoChip('🏆 ${progress.highScore} best'),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),

                      const SizedBox(height: 28),

                      // Game modes
                      const Text(
                        'Choose Game Mode 🎮',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 14),

                      ...subject.gameModes.asMap().entries.map((entry) {
                        final i = entry.key;
                        final mode = entry.value;
                        final isSelected = i == _selectedModeIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedModeIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? gradColor.withOpacity(0.2) : AppColors.bgCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? gradColor : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected ? gradColor.withOpacity(0.3) : AppColors.bgCardLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(child: Text(mode.emoji, style: const TextStyle(fontSize: 24))),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mode.name,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                                      ),
                                      Text(
                                        mode.description,
                                        style: const TextStyle(color: AppColors.textGray, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle_rounded, color: gradColor, size: 24),
                              ],
                            ),
                          ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideX(begin: 0.2, end: 0),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Difficulty selector
                      const Text(
                        'Select Difficulty 🎯',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _DifficultyButton(
                            label: 'Easy',
                            emoji: '😊',
                            selected: _selectedDifficulty == 'easy',
                            gradient: AppColors.greenGradient,
                            onTap: () => setState(() => _selectedDifficulty = 'easy'),
                          ),
                          const SizedBox(width: 10),
                          _DifficultyButton(
                            label: 'Medium',
                            emoji: '🤔',
                            selected: _selectedDifficulty == 'medium',
                            gradient: AppColors.orangeGradient,
                            onTap: () => setState(() => _selectedDifficulty = 'medium'),
                          ),
                          const SizedBox(width: 10),
                          _DifficultyButton(
                            label: 'Hard',
                            emoji: '😤',
                            selected: _selectedDifficulty == 'hard',
                            gradient: AppColors.pinkGradient,
                            onTap: () => setState(() => _selectedDifficulty = 'hard'),
                          ),
                        ],
                      ).animate(delay: 300.ms).fadeIn(),

                      const SizedBox(height: 16),

                      // Difficulty info
                      _DifficultyInfo(difficulty: _selectedDifficulty),

                      const SizedBox(height: 32),

                      // Start button
                      GestureDetector(
                        onTap: _startGame,
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: subject.gradientColors.map((c) => Color(c)).toList(),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: gradColor.withOpacity(0.5),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🚀', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              const Text(
                                'Start Game!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame() {
    final subject = SubjectData.getById(widget.subjectId)!;
    Navigator.pushNamed(
      context,
      '/game',
      arguments: {
        'subjectId': widget.subjectId,
        'gameMode': subject.gameModes[_selectedModeIndex].id,
        'difficulty': _selectedDifficulty,
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 76,
          decoration: BoxDecoration(
            gradient: selected ? gradient : null,
            color: selected ? null : AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.bgCardLight,
              width: 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textGray,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyInfo extends StatelessWidget {
  final String difficulty;
  const _DifficultyInfo({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final info = {
      'easy': {'emoji': '😊', 'text': '25 questions • 20-30 sec each • 10 pts/correct', 'color': AppColors.primaryGreen},
      'medium': {'emoji': '🤔', 'text': '25 questions • 25-35 sec each • 20 pts/correct', 'color': AppColors.primaryOrange},
      'hard': {'emoji': '😤', 'text': '25 questions • 20-25 sec each • 30 pts/correct', 'color': AppColors.primaryPink},
    };
    final d = info[difficulty]!;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(difficulty),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: (d['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: (d['color'] as Color).withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Text(d['emoji'] as String, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              d['text'] as String,
              style: TextStyle(color: d['color'] as Color, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

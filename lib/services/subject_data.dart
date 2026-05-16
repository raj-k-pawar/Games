import '../models/question_model.dart';
import '../theme/app_theme.dart';
import 'package:flutter/material.dart';

class SubjectData {
  static final List<SubjectModel> subjects = [
    SubjectModel(
      id: 'mathematics',
      name: 'Mathematics',
      emoji: '🔢',
      description: 'Numbers, puzzles & logic',
      gradientColors: [0xFF1D4ED8, 0xFF3B82F6],
      gameModes: [
        GameMode(id: 'quick_calc', name: 'Speed Math', description: 'Race against time!', emoji: '⚡'),
        GameMode(id: 'puzzle', name: 'Math Puzzles', description: 'Solve tricky problems', emoji: '🧩'),
        GameMode(id: 'geometry', name: 'Geometry', description: 'Shapes & spaces', emoji: '📐'),
      ],
    ),
    SubjectModel(
      id: 'science',
      name: 'Science',
      emoji: '🔬',
      description: 'Explore the universe',
      gradientColors: [0xFF16A34A, 0xFF22C55E],
      gameModes: [
        GameMode(id: 'quiz', name: 'Science Quiz', description: 'Test your knowledge!', emoji: '🧪'),
        GameMode(id: 'space', name: 'Space Explorer', description: 'Journey to the stars', emoji: '🚀'),
        GameMode(id: 'body', name: 'Human Body', description: 'How we work', emoji: '🫀'),
      ],
    ),
    SubjectModel(
      id: 'history',
      name: 'History',
      emoji: '🏛️',
      description: 'Stories from the past',
      gradientColors: [0xFFEA580C, 0xFFF97316],
      gameModes: [
        GameMode(id: 'timeline', name: 'Timeline', description: 'Put events in order!', emoji: '📅'),
        GameMode(id: 'quiz', name: 'History Quiz', description: 'Test your knowledge', emoji: '📜'),
        GameMode(id: 'civilization', name: 'Civilizations', description: 'Ancient worlds', emoji: '🗺️'),
      ],
    ),
    SubjectModel(
      id: 'logic',
      name: 'Logic & IQ',
      emoji: '🧠',
      description: 'Puzzles & brain teasers',
      gradientColors: [0xFF7C3AED, 0xFF9B59F5],
      gameModes: [
        GameMode(id: 'puzzle', name: 'IQ Puzzles', description: 'Sharpen your mind!', emoji: '🎯'),
        GameMode(id: 'pattern', name: 'Patterns', description: 'Find the sequence', emoji: '🔗'),
        GameMode(id: 'memory', name: 'Memory Game', description: 'Remember & match', emoji: '🃏'),
      ],
    ),
    SubjectModel(
      id: 'coding',
      name: 'Coding & AI',
      emoji: '💻',
      description: 'Tech & programming basics',
      gradientColors: [0xFF0891B2, 0xFF06B6D4],
      gameModes: [
        GameMode(id: 'logic', name: 'Code Logic', description: 'Think like a coder!', emoji: '⚙️'),
        GameMode(id: 'binary', name: 'Binary Fun', description: '0s and 1s world', emoji: '🔣'),
        GameMode(id: 'ai', name: 'AI Basics', description: 'Machine learning intro', emoji: '🤖'),
      ],
    ),
    SubjectModel(
      id: 'geography',
      name: 'Geography',
      emoji: '🌍',
      description: 'Explore our world',
      gradientColors: [0xFF059669, 0xFF10B981],
      gameModes: [
        GameMode(id: 'map', name: 'Map Explorer', description: 'Navigate the world!', emoji: '🗺️'),
        GameMode(id: 'flags', name: 'Flag Quiz', description: 'Country flags!', emoji: '🚩'),
        GameMode(id: 'capitals', name: 'Capitals', description: 'World capitals', emoji: '🏙️'),
      ],
    ),
    SubjectModel(
      id: 'english',
      name: 'English',
      emoji: '📝',
      description: 'Words & communication',
      gradientColors: [0xFFBE185D, 0xFFEC4899],
      gameModes: [
        GameMode(id: 'vocab', name: 'Vocabulary', description: 'Learn new words!', emoji: '📚'),
        GameMode(id: 'grammar', name: 'Grammar Race', description: 'Grammar challenges', emoji: '✏️'),
        GameMode(id: 'story', name: 'Story Builder', description: 'Create stories', emoji: '📖'),
      ],
    ),
    SubjectModel(
      id: 'finance',
      name: 'Finance',
      emoji: '💰',
      description: 'Money & business basics',
      gradientColors: [0xFFB45309, 0xFFFBBF24],
      gameModes: [
        GameMode(id: 'tycoon', name: 'Money Tycoon', description: 'Manage your money!', emoji: '🏦'),
        GameMode(id: 'saving', name: 'Savings Game', description: 'Save & invest', emoji: '🐷'),
      ],
      isPremium: false,
    ),
  ];

  static SubjectModel? getById(String id) {
    try {
      return subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static Color getSubjectColor(String subjectId) {
    final subject = getById(subjectId);
    if (subject == null) return AppColors.primaryPurple;
    return Color(subject.gradientColors.first);
  }
}

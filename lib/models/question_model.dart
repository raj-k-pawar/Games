class SubjectModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<int> gradientColors; // ARGB ints
  final List<GameMode> gameModes;
  final bool isPremium;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.gradientColors,
    required this.gameModes,
    this.isPremium = false,
  });
}

class GameMode {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int minAge;
  final int maxAge;

  const GameMode({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.minAge = 5,
    this.maxAge = 15,
  });
}

class Question {
  final String id;
  final String subjectId;
  final String gameMode;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty; // easy, medium, hard
  final int points;
  final int timeSeconds;

  const Question({
    required this.id,
    required this.subjectId,
    required this.gameMode,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
    this.difficulty = 'easy',
    this.points = 10,
    this.timeSeconds = 30,
  });
}

class GameResult {
  final String subjectId;
  final String gameMode;
  final int score;
  final int maxScore;
  final int correctAnswers;
  final int totalQuestions;
  final int timeTaken;
  final int coinsEarned;
  final int xpEarned;
  final int gemsEarned;
  final int stars;
  final DateTime playedAt;

  GameResult({
    required this.subjectId,
    required this.gameMode,
    required this.score,
    required this.maxScore,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeTaken,
    required this.coinsEarned,
    required this.xpEarned,
    this.gemsEarned = 0,
    required this.stars,
    required this.playedAt,
  });

  double get accuracy => totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;
  double get scorePercent => maxScore == 0 ? 0 : score / maxScore;
}

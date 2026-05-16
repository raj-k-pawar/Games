class UserModel {
  String id;
  String name;
  String avatarId;
  int coins;
  int gems;
  int xp;
  int level;
  int streak;
  DateTime? lastPlayDate;
  Map<String, SubjectProgress> subjectProgress;
  List<String> badges;
  List<String> unlockedAvatars;
  List<String> unlockedPets;
  int totalQuestionsAnswered;
  int totalCorrectAnswers;

  UserModel({
    required this.id,
    required this.name,
    this.avatarId = 'avatar_1',
    this.coins = 100,
    this.gems = 5,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.lastPlayDate,
    Map<String, SubjectProgress>? subjectProgress,
    List<String>? badges,
    List<String>? unlockedAvatars,
    List<String>? unlockedPets,
    this.totalQuestionsAnswered = 0,
    this.totalCorrectAnswers = 0,
  })  : subjectProgress = subjectProgress ?? {},
        badges = badges ?? [],
        unlockedAvatars = unlockedAvatars ?? ['avatar_1'],
        unlockedPets = unlockedPets ?? [];

  int get xpForNextLevel => level * 500;
  double get xpProgress => xp / xpForNextLevel;
  double get accuracy => totalQuestionsAnswered == 0
      ? 0
      : totalCorrectAnswers / totalQuestionsAnswered;

  void addXP(int amount) {
    xp += amount;
    while (xp >= xpForNextLevel) {
      xp -= xpForNextLevel;
      level++;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarId': avatarId,
        'coins': coins,
        'gems': gems,
        'xp': xp,
        'level': level,
        'streak': streak,
        'lastPlayDate': lastPlayDate?.toIso8601String(),
        'subjectProgress': subjectProgress.map((k, v) => MapEntry(k, v.toJson())),
        'badges': badges,
        'unlockedAvatars': unlockedAvatars,
        'unlockedPets': unlockedPets,
        'totalQuestionsAnswered': totalQuestionsAnswered,
        'totalCorrectAnswers': totalCorrectAnswers,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        avatarId: json['avatarId'] ?? 'avatar_1',
        coins: json['coins'] ?? 100,
        gems: json['gems'] ?? 5,
        xp: json['xp'] ?? 0,
        level: json['level'] ?? 1,
        streak: json['streak'] ?? 0,
        lastPlayDate: json['lastPlayDate'] != null
            ? DateTime.parse(json['lastPlayDate'])
            : null,
        subjectProgress: (json['subjectProgress'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, SubjectProgress.fromJson(v))) ??
            {},
        badges: List<String>.from(json['badges'] ?? []),
        unlockedAvatars: List<String>.from(json['unlockedAvatars'] ?? ['avatar_1']),
        unlockedPets: List<String>.from(json['unlockedPets'] ?? []),
        totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
        totalCorrectAnswers: json['totalCorrectAnswers'] ?? 0,
      );
}

class SubjectProgress {
  String subjectId;
  int highScore;
  int gamesPlayed;
  int totalStars;
  String difficulty; // 'easy', 'medium', 'hard'

  SubjectProgress({
    required this.subjectId,
    this.highScore = 0,
    this.gamesPlayed = 0,
    this.totalStars = 0,
    this.difficulty = 'easy',
  });

  Map<String, dynamic> toJson() => {
        'subjectId': subjectId,
        'highScore': highScore,
        'gamesPlayed': gamesPlayed,
        'totalStars': totalStars,
        'difficulty': difficulty,
      };

  factory SubjectProgress.fromJson(Map<String, dynamic> json) => SubjectProgress(
        subjectId: json['subjectId'],
        highScore: json['highScore'] ?? 0,
        gamesPlayed: json['gamesPlayed'] ?? 0,
        totalStars: json['totalStars'] ?? 0,
        difficulty: json['difficulty'] ?? 'easy',
      );
}

// ─── User / Child Profile ────────────────────────────────────────────────────
class ChildProfile {
  String id;
  String name;
  String avatarId;
  int coins;
  int gems;
  int xp;
  int level;
  int streak;
  DateTime? lastPlay;
  Map<String,SubjectProgress> progress;
  List<String> badges;
  List<String> unlockedAvatars;
  List<String> unlockedPets;
  List<String> friends;         // friend IDs
  String quizzoId;              // unique 6-char ID for friend search
  int totalAnswered;
  int totalCorrect;
  // Power-ups inventory
  int skipLifelines;
  int fiftyLifelines;
  int timeLifelines;

  ChildProfile({
    required this.id,
    required this.name,
    this.avatarId = 'avatar_fox',
    this.coins = 200,
    this.gems = 10,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.lastPlay,
    Map<String,SubjectProgress>? progress,
    List<String>? badges,
    List<String>? unlockedAvatars,
    List<String>? unlockedPets,
    List<String>? friends,
    String? quizzoId,
    this.totalAnswered = 0,
    this.totalCorrect = 0,
    this.skipLifelines = 3,
    this.fiftyLifelines = 2,
    this.timeLifelines = 2,
  }) : progress = progress ?? {},
       badges = badges ?? [],
       unlockedAvatars = unlockedAvatars ?? ['avatar_fox'],
       unlockedPets = unlockedPets ?? [],
       friends = friends ?? [],
       quizzoId = quizzoId ?? _genId(name);

  static String _genId(String name) {
    final n = name.isNotEmpty ? name[0].toUpperCase() : 'Q';
    final num = (DateTime.now().millisecondsSinceEpoch % 99999).toString().padLeft(5,'0');
    return '$n$num';
  }

  int get xpForNext => level * 500;
  double get xpPct => (xp / xpForNext).clamp(0.0,1.0);
  double get accuracy => totalAnswered==0?0:(totalCorrect/totalAnswered);

  void addXP(int amt) {
    xp += amt;
    while (xp >= xpForNext) { xp -= xpForNext; level++; }
  }

  Map<String,dynamic> toJson() => {
    'id':id,'name':name,'avatarId':avatarId,'coins':coins,'gems':gems,
    'xp':xp,'level':level,'streak':streak,'lastPlay':lastPlay?.toIso8601String(),
    'progress':progress.map((k,v)=>MapEntry(k,v.toJson())),
    'badges':badges,'unlockedAvatars':unlockedAvatars,'unlockedPets':unlockedPets,
    'friends':friends,'quizzoId':quizzoId,
    'totalAnswered':totalAnswered,'totalCorrect':totalCorrect,
    'skipLifelines':skipLifelines,'fiftyLifelines':fiftyLifelines,'timeLifelines':timeLifelines,
  };

  factory ChildProfile.fromJson(Map<String,dynamic> j) => ChildProfile(
    id: j['id'], name: j['name'], avatarId: j['avatarId']??'avatar_fox',
    coins: j['coins']??200, gems: j['gems']??10, xp: j['xp']??0,
    level: j['level']??1, streak: j['streak']??0,
    lastPlay: j['lastPlay']!=null?DateTime.parse(j['lastPlay']):null,
    progress: (j['progress'] as Map<String,dynamic>?)?.map((k,v)=>MapEntry(k,SubjectProgress.fromJson(v as Map<String,dynamic>)))??{},
    badges: List<String>.from(j['badges']??[]),
    unlockedAvatars: List<String>.from(j['unlockedAvatars']??['avatar_fox']),
    unlockedPets: List<String>.from(j['unlockedPets']??[]),
    friends: List<String>.from(j['friends']??[]),
    quizzoId: j['quizzoId'],
    totalAnswered: j['totalAnswered']??0, totalCorrect: j['totalCorrect']??0,
    skipLifelines: j['skipLifelines']??3, fiftyLifelines: j['fiftyLifelines']??2, timeLifelines: j['timeLifelines']??2,
  );
}

class SubjectProgress {
  String subjectId;
  int highScore;
  int gamesPlayed;
  int totalStars;
  int totalCorrect;

  SubjectProgress({required this.subjectId,this.highScore=0,this.gamesPlayed=0,this.totalStars=0,this.totalCorrect=0});
  Map<String,dynamic> toJson() => {'subjectId':subjectId,'highScore':highScore,'gamesPlayed':gamesPlayed,'totalStars':totalStars,'totalCorrect':totalCorrect};
  factory SubjectProgress.fromJson(Map<String,dynamic> j) => SubjectProgress(subjectId:j['subjectId'],highScore:j['highScore']??0,gamesPlayed:j['gamesPlayed']??0,totalStars:j['totalStars']??0,totalCorrect:j['totalCorrect']??0);
}

// ─── Parent Account ──────────────────────────────────────────────────────────
class ParentAccount {
  String id;
  String name;
  String pin;              // 4-digit PIN
  List<String> childIds;
  // Per-child settings stored as childId -> settings map
  Map<String,ChildSettings> childSettings;

  ParentAccount({required this.id,required this.name,required this.pin,List<String>? childIds,Map<String,ChildSettings>? childSettings})
    : childIds=childIds??[], childSettings=childSettings??{};

  Map<String,dynamic> toJson() => {
    'id':id,'name':name,'pin':pin,'childIds':childIds,
    'childSettings':childSettings.map((k,v)=>MapEntry(k,v.toJson())),
  };
  factory ParentAccount.fromJson(Map<String,dynamic> j) => ParentAccount(
    id:j['id'],name:j['name'],pin:j['pin'],
    childIds:List<String>.from(j['childIds']??[]),
    childSettings:(j['childSettings'] as Map<String,dynamic>?)?.map((k,v)=>MapEntry(k,ChildSettings.fromJson(v as Map<String,dynamic>)))??{},
  );
}

class ChildSettings {
  int dailyLimitMinutes;       // screen time limit
  int bedtimeHour;             // lock after this hour
  bool multiplayerEnabled;
  bool leaderboardEnabled;
  List<String> enabledSubjects;
  String difficulty;           // 'easy'|'medium'|'hard'|'auto'

  ChildSettings({
    this.dailyLimitMinutes=60, this.bedtimeHour=21,
    this.multiplayerEnabled=true, this.leaderboardEnabled=true,
    List<String>? enabledSubjects, this.difficulty='auto',
  }) : enabledSubjects = enabledSubjects ?? ['mathematics','science','history','logic','coding','geography','english','finance'];

  Map<String,dynamic> toJson() => {
    'dailyLimitMinutes':dailyLimitMinutes,'bedtimeHour':bedtimeHour,
    'multiplayerEnabled':multiplayerEnabled,'leaderboardEnabled':leaderboardEnabled,
    'enabledSubjects':enabledSubjects,'difficulty':difficulty,
  };
  factory ChildSettings.fromJson(Map<String,dynamic> j) => ChildSettings(
    dailyLimitMinutes:j['dailyLimitMinutes']??60, bedtimeHour:j['bedtimeHour']??21,
    multiplayerEnabled:j['multiplayerEnabled']??true, leaderboardEnabled:j['leaderboardEnabled']??true,
    enabledSubjects:List<String>.from(j['enabledSubjects']??[]),
    difficulty:j['difficulty']??'auto',
  );
}

// ─── Question / Subject ───────────────────────────────────────────────────────
class Subject {
  final String id, name, emoji, description;
  final List<int> gradColors;
  const Subject({required this.id,required this.name,required this.emoji,required this.description,required this.gradColors});
}

class Question {
  final String id, subjectId, question, difficulty, explanation;
  final List<String> options;
  final int correctIndex, points, timeSeconds;
  const Question({required this.id,required this.subjectId,required this.question,
    required this.options,required this.correctIndex,required this.explanation,
    required this.difficulty,required this.points,required this.timeSeconds});
}

class GameResult {
  final String subjectId;
  final int score, maxScore, correctAnswers, totalQuestions, timeTaken;
  final int coinsEarned, xpEarned, gemsEarned, stars;
  final DateTime playedAt;
  GameResult({required this.subjectId,required this.score,required this.maxScore,
    required this.correctAnswers,required this.totalQuestions,required this.timeTaken,
    required this.coinsEarned,required this.xpEarned,required this.gemsEarned,
    required this.stars,required this.playedAt});
  double get accuracy => totalQuestions==0?0:correctAnswers/totalQuestions;
}

// ─── Shop items ───────────────────────────────────────────────────────────────
class ShopItem {
  final String id, name, emoji, description, type; // 'avatar'|'pet'|'powerup'
  final int price;
  final bool useGems;
  final String? bonus;
  const ShopItem({required this.id,required this.name,required this.emoji,
    required this.description,required this.type,required this.price,
    this.useGems=false,this.bonus});
}

// ─── Challenge / Battle ───────────────────────────────────────────────────────
class Challenge {
  final String id, challengerId, challengerName, challengerAvatar, subjectId, difficulty;
  final int challengerScore;
  String status; // 'pending'|'accepted'|'completed'
  int? opponentScore;
  Challenge({required this.id,required this.challengerId,required this.challengerName,
    required this.challengerAvatar,required this.subjectId,required this.difficulty,
    required this.challengerScore,this.status='pending',this.opponentScore});
}

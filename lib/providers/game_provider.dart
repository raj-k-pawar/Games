import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/question_bank.dart';

enum GameState { idle, playing, paused, finished }

class GameProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _selectedAnswer = -1;
  bool _answered = false;
  GameState _gameState = GameState.idle;
  int _timeLeft = 30;
  int _totalTime = 0;

  // Lifelines
  int _skipLifelines = 2;
  int _fiftyFiftyLifelines = 1;
  int _extraTimeLifelines = 1;
  List<int> _hiddenOptions = [];
  bool _fiftyFiftyUsed = false;

  // Getters
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get selectedAnswer => _selectedAnswer;
  bool get answered => _answered;
  GameState get gameState => _gameState;
  int get timeLeft => _timeLeft;
  int get totalTime => _totalTime;
  int get skipLifelines => _skipLifelines;
  int get fiftyFiftyLifelines => _fiftyFiftyLifelines;
  int get extraTimeLifelines => _extraTimeLifelines;
  List<int> get hiddenOptions => _hiddenOptions;
  bool get isLastQuestion => _currentIndex >= _questions.length - 1;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  double get progress =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  void loadGame({
    required String subjectId,
    required String difficulty,
    int questionCount = 10,
  }) {
    _questions = QuestionBank.getQuestions(
      subjectId: subjectId,
      difficulty: difficulty,
      count: questionCount,
    );
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _selectedAnswer = -1;
    _answered = false;
    _gameState = GameState.playing;
    _skipLifelines = 2;
    _fiftyFiftyLifelines = 1;
    _extraTimeLifelines = 1;
    _hiddenOptions = [];
    _fiftyFiftyUsed = false;
    _totalTime = 0;
    if (_questions.isNotEmpty) {
      _timeLeft = _questions[0].timeSeconds;
    }
    notifyListeners();
  }

  void tickTimer() {
    if (_gameState != GameState.playing || _answered) return;
    if (_timeLeft > 0) {
      _timeLeft--;
      _totalTime++;
      notifyListeners();
    } else {
      // Time's up — mark as wrong
      submitAnswer(-1);
    }
  }

  void submitAnswer(int answerIndex) {
    if (_answered || _gameState != GameState.playing) return;
    _answered = true;
    _selectedAnswer = answerIndex;

    final q = currentQuestion;
    if (q != null && answerIndex == q.correctIndex) {
      _correctAnswers++;
      // Bonus points for fast answer
      final timeBonus = (_timeLeft / q.timeSeconds * 5).round();
      _score += q.points + timeBonus;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _answered = false;
      _selectedAnswer = -1;
      _hiddenOptions = [];
      _fiftyFiftyUsed = false;
      if (_questions.isNotEmpty) {
        _timeLeft = _questions[_currentIndex].timeSeconds;
      }
      notifyListeners();
    } else {
      _gameState = GameState.finished;
      notifyListeners();
    }
  }

  void pauseGame() {
    _gameState = GameState.paused;
    notifyListeners();
  }

  void resumeGame() {
    _gameState = GameState.playing;
    notifyListeners();
  }

  // ── Lifelines ────────────────────────────────────────────────────────────

  bool useSkip() {
    if (_skipLifelines <= 0 || _answered) return false;
    _skipLifelines--;
    nextQuestion();
    return true;
  }

  bool useFiftyFifty() {
    if (_fiftyFiftyLifelines <= 0 || _answered || _fiftyFiftyUsed) return false;
    final q = currentQuestion;
    if (q == null) return false;

    _fiftyFiftyLifelines--;
    _fiftyFiftyUsed = true;

    // Hide 2 wrong answers
    final wrongIndices = List.generate(q.options.length, (i) => i)
      ..removeWhere((i) => i == q.correctIndex);
    wrongIndices.shuffle();
    _hiddenOptions = wrongIndices.take(2).toList();
    notifyListeners();
    return true;
  }

  bool useExtraTime() {
    if (_extraTimeLifelines <= 0 || _answered) return false;
    _extraTimeLifelines--;
    _timeLeft += 15;
    notifyListeners();
    return true;
  }

  GameResult buildResult(String subjectId, String gameMode) {
    final maxScore = _questions.fold<int>(0, (sum, q) => sum + q.points + 5);
    final stars = _score >= maxScore * 0.8
        ? 3
        : _score >= maxScore * 0.5
            ? 2
            : 1;
    final coinsEarned = (_score * 0.5).round();
    final xpEarned = _score;
    final gemsEarned = stars == 3 ? 1 : 0;

    return GameResult(
      subjectId: subjectId,
      gameMode: gameMode,
      score: _score,
      maxScore: maxScore,
      correctAnswers: _correctAnswers,
      totalQuestions: _questions.length,
      timeTaken: _totalTime,
      coinsEarned: coinsEarned,
      xpEarned: xpEarned,
      gemsEarned: gemsEarned,
      stars: stars,
      playedAt: DateTime.now(),
    );
  }

  void reset() {
    _gameState = GameState.idle;
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _selectedAnswer = -1;
    _answered = false;
    notifyListeners();
  }
}

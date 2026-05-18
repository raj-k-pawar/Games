import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/question_service.dart';

enum GameState { idle, playing, finished }

class GameProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _selectedAnswer = -1;
  bool _answered = false;
  GameState _gameState = GameState.idle;
  int _timeLeft = 25;
  int _totalTime = 0;

  // Lifelines
  int _skips = 2;
  int _fiftyFifty = 1;
  int _extraTime = 1;
  List<int> _hiddenOptions = [];
  bool _ffUsed = false;

  // No-repeat tracking (static = persists across games)
  static final Set<String> _usedIds = {};

  // Getters
  List<Question> get questions    => _questions;
  int  get currentIndex           => _currentIndex;
  int  get score                  => _score;
  int  get correctAnswers         => _correctAnswers;
  int  get selectedAnswer         => _selectedAnswer;
  bool get answered               => _answered;
  GameState get gameState         => _gameState;
  int  get timeLeft               => _timeLeft;
  int  get totalTime              => _totalTime;
  int  get skips                  => _skips;
  int  get fiftyFifty             => _fiftyFifty;
  int  get extraTime              => _extraTime;
  List<int> get hiddenOptions     => _hiddenOptions;
  bool get isLastQuestion         => _currentIndex >= _questions.length - 1;
  double get progress             => _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  Question? get currentQuestion =>
    _questions.isNotEmpty && _currentIndex < _questions.length
      ? _questions[_currentIndex] : null;

  void loadGame({required String subjectId, required String difficulty, int count = 25}) {
    _questions = QuestionService.get(
      subjectId: subjectId, difficulty: difficulty,
      count: count, exclude: Set.unmodifiable(_usedIds),
    );
    for (final q in _questions) _usedIds.add(q.id);

    // Reset pool when all used
    final allIds = QuestionService.allIds(subjectId, difficulty);
    if (allIds.isNotEmpty && allIds.every((id) => _usedIds.contains(id))) {
      for (final id in allIds) _usedIds.remove(id);
    }

    _currentIndex = 0; _score = 0; _correctAnswers = 0;
    _selectedAnswer = -1; _answered = false;
    _gameState = GameState.playing;
    _skips = 2; _fiftyFifty = 1; _extraTime = 1;
    _hiddenOptions = []; _ffUsed = false; _totalTime = 0;
    if (_questions.isNotEmpty) _timeLeft = _questions[0].timeSeconds;
    notifyListeners();
  }

  void tickTimer() {
    if (_gameState != GameState.playing || _answered) return;
    if (_timeLeft > 0) {
      _timeLeft--;
      _totalTime++;
      notifyListeners();
    } else {
      // Time up — mark wrong, show next button
      _answered = true;
      _selectedAnswer = -1;
      _totalTime++;
      notifyListeners();
    }
  }

  void submitAnswer(int index) {
    if (_answered || _gameState != GameState.playing) return;
    _answered = true;
    _selectedAnswer = index;
    final q = currentQuestion;
    if (q != null && index == q.correctIndex) {
      _correctAnswers++;
      final bonus = (_timeLeft / q.timeSeconds * 5).round();
      _score += q.points + bonus;
    }
    notifyListeners();
  }

  // Called ONLY from Next button
  void nextQuestion() {
    if (!_answered) return;
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _answered = false; _selectedAnswer = -1;
      _hiddenOptions = []; _ffUsed = false;
      _timeLeft = _questions[_currentIndex].timeSeconds;
      notifyListeners();
    } else {
      _gameState = GameState.finished;
      notifyListeners();
    }
  }

  bool useSkip() {
    if (_skips <= 0 || _answered) return false;
    _skips--;
    _answered = true; _selectedAnswer = -1;
    notifyListeners();
    return true;
  }

  bool useFiftyFifty() {
    if (_fiftyFifty <= 0 || _answered || _ffUsed) return false;
    final q = currentQuestion;
    if (q == null) return false;
    _fiftyFifty--; _ffUsed = true;
    final wrong = List.generate(q.options.length, (i) => i)
      ..removeWhere((i) => i == q.correctIndex);
    wrong.shuffle();
    _hiddenOptions = wrong.take(2).toList();
    notifyListeners();
    return true;
  }

  bool useExtraTime() {
    if (_extraTime <= 0 || _answered) return false;
    _extraTime--;
    _timeLeft += 15;
    notifyListeners();
    return true;
  }

  GameResult buildResult(String subjectId) {
    final maxScore = _questions.fold<int>(0, (s, q) => s + q.points + 5);
    final stars = _score >= maxScore * 0.8 ? 3 : _score >= maxScore * 0.5 ? 2 : 1;
    return GameResult(
      subjectId: subjectId, score: _score, maxScore: maxScore,
      correctAnswers: _correctAnswers, totalQuestions: _questions.length,
      timeTaken: _totalTime, coinsEarned: (_score * 0.5).round(),
      xpEarned: _score, gemsEarned: stars == 3 ? 1 : 0,
      stars: stars, playedAt: DateTime.now(),
    );
  }

  void reset() {
    _gameState = GameState.idle; _questions = [];
    _currentIndex = 0; _score = 0; _correctAnswers = 0;
    _selectedAnswer = -1; _answered = false;
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/question_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      try {
        _user = UserModel.fromJson(jsonDecode(userData));
        _checkAndUpdateStreak();
      } catch (_) {
        _user = null;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(String name, String avatarId) async {
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatarId: avatarId,
      coins: 200,
      gems: 10,
      xp: 0,
      level: 1,
      streak: 1,
      lastPlayDate: DateTime.now(),
    );
    await _save();
    notifyListeners();
  }

  void _checkAndUpdateStreak() {
    if (_user == null) return;
    final now = DateTime.now();
    final last = _user!.lastPlayDate;
    if (last == null) {
      _user!.streak = 1;
      _user!.lastPlayDate = now;
      return;
    }
    final diff = now.difference(last).inDays;
    if (diff == 1) {
      _user!.streak++;
    } else if (diff > 1) {
      _user!.streak = 1;
    }
    _user!.lastPlayDate = now;
  }

  Future<void> applyGameResult(GameResult result) async {
    if (_user == null) return;

    _user!.coins += result.coinsEarned;
    _user!.gems += result.gemsEarned;
    _user!.addXP(result.xpEarned);
    _user!.totalQuestionsAnswered += result.totalQuestions;
    _user!.totalCorrectAnswers += result.correctAnswers;

    // Update subject progress
    final existing = _user!.subjectProgress[result.subjectId];
    if (existing == null || result.score > existing.highScore) {
      _user!.subjectProgress[result.subjectId] = SubjectProgress(
        subjectId: result.subjectId,
        highScore: result.score,
        gamesPlayed: (existing?.gamesPlayed ?? 0) + 1,
        totalStars: (existing?.totalStars ?? 0) + result.stars,
        difficulty: existing?.difficulty ?? 'easy',
      );
    } else {
      existing.gamesPlayed++;
      existing.totalStars += result.stars;
    }

    // Award badges
    _checkBadges(result);

    await _save();
    notifyListeners();
  }

  void _checkBadges(GameResult result) {
    if (_user == null) return;

    if (result.stars == 3 && !_user!.badges.contains('perfect_score')) {
      _user!.badges.add('perfect_score');
    }
    if (_user!.streak >= 7 && !_user!.badges.contains('week_streak')) {
      _user!.badges.add('week_streak');
    }
    if (_user!.totalQuestionsAnswered >= 100 && !_user!.badges.contains('century')) {
      _user!.badges.add('century');
    }
    if (_user!.level >= 5 && !_user!.badges.contains('level_5')) {
      _user!.badges.add('level_5');
    }
    if (_user!.subjectProgress.length >= 5 && !_user!.badges.contains('explorer')) {
      _user!.badges.add('explorer');
    }
  }

  Future<void> updateAvatar(String avatarId) async {
    if (_user == null) return;
    _user!.avatarId = avatarId;
    await _save();
    notifyListeners();
  }

  Future<void> spendCoins(int amount) async {
    if (_user == null || _user!.coins < amount) return;
    _user!.coins -= amount;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_user!.toJson()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    _user = null;
    notifyListeners();
  }
}

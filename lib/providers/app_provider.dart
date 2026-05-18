import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

// ─── App Provider — manages parent + child sessions ──────────────────────────
class AppProvider extends ChangeNotifier {
  // Auth state
  ChildProfile? _child;
  ParentAccount? _parent;
  bool _isLoading = true;
  String _sessionType = 'none'; // 'child' | 'parent' | 'none'

  ChildProfile? get child  => _child;
  ParentAccount? get parent => _parent;
  bool get isLoading      => _isLoading;
  String get sessionType  => _sessionType;
  bool get isChildLoggedIn  => _child != null && _sessionType == 'child';
  bool get isParentLoggedIn => _parent != null && _sessionType == 'parent';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Try restore last session
    final childJson = prefs.getString('child_data');
    final parentJson = prefs.getString('parent_data');
    final lastSession = prefs.getString('last_session') ?? 'none';

    if (childJson != null) {
      try { _child = ChildProfile.fromJson(jsonDecode(childJson)); } catch(_) {}
    }
    if (parentJson != null) {
      try { _parent = ParentAccount.fromJson(jsonDecode(parentJson)); } catch(_) {}
    }
    _sessionType = lastSession;
    _isLoading = false;
    notifyListeners();
  }

  // ── Child auth ────────────────────────────────────────────────────────────
  Future<void> createChild(String name, String avatarId) async {
    _child = ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name, avatarId: avatarId,
      coins: 200, gems: 10,
      streak: 1, lastPlay: DateTime.now(),
    );
    _sessionType = 'child';
    await _saveChild();
    await _saveSession();
    notifyListeners();
  }

  Future<void> loginChild() async {
    _sessionType = 'child';
    _checkStreak();
    await _saveSession();
    notifyListeners();
  }

  void _checkStreak() {
    if (_child == null) return;
    final now = DateTime.now();
    final last = _child!.lastPlay;
    if (last == null) { _child!.streak = 1; }
    else {
      final diff = now.difference(last).inDays;
      if (diff == 1) { _child!.streak++; }
      else if (diff > 1) { _child!.streak = 1; }
    }
    _child!.lastPlay = now;
  }

  // ── Parent auth ───────────────────────────────────────────────────────────
  Future<void> createParent(String name, String pin) async {
    _parent = ParentAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name, pin: pin,
    );
    // Link existing child to parent
    if (_child != null) {
      _parent!.childIds.add(_child!.id);
      _parent!.childSettings[_child!.id] = ChildSettings();
    }
    _sessionType = 'parent';
    await _saveParent();
    await _saveSession();
    notifyListeners();
  }

  Future<bool> loginParent(String pin) async {
    if (_parent == null) return false;
    if (_parent!.pin != pin) return false;
    _sessionType = 'parent';
    await _saveSession();
    notifyListeners();
    return true;
  }

  void switchToChild() {
    _sessionType = 'child';
    _saveSession();
    notifyListeners();
  }

  // ── Game result ───────────────────────────────────────────────────────────
  Future<void> applyResult(GameResult result) async {
    if (_child == null) return;
    _child!.coins += result.coinsEarned;
    _child!.gems  += result.gemsEarned;
    _child!.addXP(result.xpEarned);
    _child!.totalAnswered += result.totalQuestions;
    _child!.totalCorrect  += result.correctAnswers;
    // Subject progress
    final sp = _child!.progress[result.subjectId];
    if (sp == null || result.score > sp.highScore) {
      _child!.progress[result.subjectId] = SubjectProgress(
        subjectId: result.subjectId,
        highScore: result.score,
        gamesPlayed: (sp?.gamesPlayed ?? 0) + 1,
        totalStars: (sp?.totalStars ?? 0) + result.stars,
        totalCorrect: (sp?.totalCorrect ?? 0) + result.correctAnswers,
      );
    } else {
      sp.gamesPlayed++;
      sp.totalStars += result.stars;
      sp.totalCorrect += result.correctAnswers;
    }
    _checkBadges();
    await _saveChild();
    notifyListeners();
  }

  void _checkBadges() {
    if (_child == null) return;
    final b = _child!.badges;
    if (_child!.progress.length >= 3 && !b.contains('explorer'))     b.add('explorer');
    if (_child!.streak >= 7         && !b.contains('week_streak'))    b.add('week_streak');
    if (_child!.totalAnswered >= 100 && !b.contains('century'))       b.add('century');
    if (_child!.level >= 5          && !b.contains('level_5'))        b.add('level_5');
    if (_child!.coins >= 1000       && !b.contains('rich'))           b.add('rich');
    if (_child!.progress.values.any((p)=>p.totalStars>=3) && !b.contains('star_collector')) b.add('star_collector');
  }

  // ── Shop ──────────────────────────────────────────────────────────────────
  Future<bool> purchaseItem(ShopItem item) async {
    if (_child == null) return false;
    if (item.useGems) {
      if (_child!.gems < item.price) return false;
      _child!.gems -= item.price;
    } else {
      if (_child!.coins < item.price) return false;
      _child!.coins -= item.price;
    }
    if (item.type == 'avatar' && !_child!.unlockedAvatars.contains(item.id)) {
      _child!.unlockedAvatars.add(item.id);
    }
    if (item.type == 'pet' && !_child!.unlockedPets.contains(item.id)) {
      _child!.unlockedPets.add(item.id);
    }
    if (item.type == 'powerup') {
      if (item.id.contains('skip'))  _child!.skipLifelines += 5;
      if (item.id.contains('time'))  _child!.timeLifelines += 5;
      if (item.id.contains('fifty')) _child!.fiftyLifelines += 3;
    }
    await _saveChild();
    notifyListeners();
    return true;
  }

  Future<void> equipAvatar(String avatarId) async {
    if (_child == null) return;
    _child!.avatarId = avatarId;
    await _saveChild();
    notifyListeners();
  }

  // ── Parent settings ───────────────────────────────────────────────────────
  ChildSettings? getChildSettings() {
    if (_parent == null || _child == null) return null;
    return _parent!.childSettings[_child!.id] ?? ChildSettings();
  }

  Future<void> saveChildSettings(ChildSettings s) async {
    if (_parent == null || _child == null) return;
    _parent!.childSettings[_child!.id] = s;
    await _saveParent();
    notifyListeners();
  }

  // ── Persistence ───────────────────────────────────────────────────────────
  Future<void> _saveChild() async {
    if (_child == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_data', jsonEncode(_child!.toJson()));
  }

  Future<void> _saveParent() async {
    if (_parent == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parent_data', jsonEncode(_parent!.toJson()));
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_session', _sessionType);
  }

  Future<void> logoutChild() async {
    _sessionType = 'none';
    await _saveSession();
    notifyListeners();
  }

  Future<void> logoutParent() async {
    _sessionType = 'none';
    await _saveSession();
    notifyListeners();
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _child = null;
    _parent = null;
    _sessionType = 'none';
    notifyListeners();
  }
}

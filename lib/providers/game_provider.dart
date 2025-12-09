import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../data/questions.dart';

class GameProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _index = 0;
  int _teamRed = 0;
  int _teamGreen = 0;
  bool _isRedTurn = true;
  Timer? _timer;
  int _remainingSeconds = 20;
  bool _isRunning = false;

  List<Question> get questions => _questions;
  int get index => _index;
  int get teamRed => _teamRed;
  int get teamGreen => _teamGreen;
  bool get isRedTurn => _isRedTurn;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  GameProvider() {
    _load();
  }

  Future<void> _load() async {
    _questions = List.from(defaultQuestions);
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getStringList('custom_questions') ?? [];
    for (var q in custom) {
      try {
        final m = jsonDecode(q);
        _questions.add(Question.fromJson(Map<String, dynamic>.from(m)));
      } catch (_) {}
    }
    notifyListeners();
  }

  void startGame() {
    _index = 0;
    _teamRed = 0;
    _teamGreen = 0;
    _isRedTurn = true;
    notifyListeners();
  }

  void nextTurn() {
    _isRedTurn = !_isRedTurn;
    _index++;
    _remainingSeconds = 20;
    _stopTimer();
    notifyListeners();
  }

  void addScore(int pts) {
    if (_isRedTurn) {
      _teamRed += pts;
    } else {
      _teamGreen += pts;
    }
    notifyListeners();
  }

  Question get currentQuestion => _questions[_index];

  bool get isLast => _index >= _questions.length - 1;

  void startTimer({int seconds = 20}) {
    _remainingSeconds = seconds;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        _isRunning = false;
        notifyListeners();
      } else {
        _remainingSeconds--;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  Future<void> addCustomQuestion(Question q) async {
    _questions.add(q);
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('custom_questions') ?? [];
    list.add(jsonEncode(q.toJson()));
    await prefs.setStringList('custom_questions', list);
    notifyListeners();
  }

  void revealAnswerAndAdvance(int points) {
    addScore(points);
    if (!isLast) {
      nextTurn();
    } else {
      _index = _questions.length; // mark finished
      notifyListeners();
    }
  }

  int get totalQuestions => _questions.length;
}

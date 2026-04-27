import 'package:flutter/material.dart';
import '../models/savings_goal.dart';

class SavingsViewModel extends ChangeNotifier {
  String? _userId;
  final List<SavingsGoal> _allGoals = [
    SavingsGoal(
      id: '1',
      userId: 'user_123',
      title: 'New MacBook Pro',
      targetAmount: 2500.0,
      savedAmount: 1200.0,
      deadline: DateTime.now().add(const Duration(days: 90)),
      emoji: '💻',
      color: Colors.blue,
    ),
    SavingsGoal(
      id: '2',
      userId: 'user_123',
      title: 'Summer Vacation',
      targetAmount: 5000.0,
      savedAmount: 1500.0,
      deadline: DateTime.now().add(const Duration(days: 120)),
      emoji: '🏖️',
      color: Colors.orange,
    ),
  ];

  void updateUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
      notifyListeners();
    }
  }

  List<SavingsGoal> get goals => _allGoals.where((g) => g.userId == _userId).toList();

  void addGoal(SavingsGoal goal) {
    _allGoals.insert(0, goal);
    notifyListeners();
  }

  void updateGoal(SavingsGoal updated) {
    final index = _allGoals.indexWhere((g) => g.id == updated.id);
    if (index != -1) {
      _allGoals[index] = updated;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _allGoals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void addSavings(String goalId, double amount) {
    final index = _allGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _allGoals[index];
      _allGoals[index] = SavingsGoal(
        id: goal.id,
        userId: goal.userId,
        title: goal.title,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount + amount,
        deadline: goal.deadline,
        emoji: goal.emoji,
        color: goal.color,
      );
      notifyListeners();
    }
  }
}

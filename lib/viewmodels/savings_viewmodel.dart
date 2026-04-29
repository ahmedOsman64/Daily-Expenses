import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../services/supabase_service.dart';
import '../core/constants/constants.dart';


class SavingsViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService;
  String? _userId;
  List<SavingsGoal> _goals = [];
  bool _isLoading = false;

  SavingsViewModel(this._supabaseService) {
    if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
      _loadSampleData();
    }
  }

  void _loadSampleData() {
    _goals = [
      SavingsGoal(
        id: '1',
        userId: 'test-user-id',
        title: 'New Car',
        targetAmount: 25000.0,
        savedAmount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 365)),
        emoji: '🚗',
        color: Colors.blue,
      ),
      SavingsGoal(
        id: '2',
        userId: 'test-user-id',
        title: 'Vacation',
        targetAmount: 3000.0,
        savedAmount: 1200.0,
        deadline: DateTime.now().add(const Duration(days: 90)),
        emoji: '🏖️',
        color: Colors.orange,
      ),
    ];
  }

  List<SavingsGoal> get goals => _goals;
  bool get isLoading => _isLoading;

  void updateUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
      if (_userId != null) {
        fetchGoals();
      } else {
        _goals = [];
        notifyListeners();
      }
    }
  }

  Future<void> fetchGoals() async {
    if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _goals = await _supabaseService.getSavingsGoals();
    } catch (e) {
      debugPrint('Error fetching savings goals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGoal(SavingsGoal goal) async {
    // Add locally first so user sees it immediately (Optimistic UI)
    _goals.insert(0, goal);
    notifyListeners();

    try {
      // Only attempt to sync with Supabase if the user is authenticated
      if (goal.userId != 'anonymous') {
        await _supabaseService.addSavingsGoal(goal);
      }
    } catch (e) {
      debugPrint('Error syncing savings goal to Supabase: $e');
      // Note: We keep it in the local list even if sync fails for better UX
    }
  }

  Future<void> updateGoal(SavingsGoal updated) async {
    // Update locally first
    final index = _goals.indexWhere((g) => g.id == updated.id);
    if (index != -1) {
      _goals[index] = updated;
      notifyListeners();
    }

    try {
      if (updated.userId != 'anonymous') {
        await _supabaseService.updateSavingsGoal(updated);
      }
    } catch (e) {
      debugPrint('Error syncing savings goal update to Supabase: $e');
    }
  }

  Future<void> deleteGoal(String id) async {
    // Remove locally first
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();

    try {
      await _supabaseService.deleteSavingsGoal(id);
    } catch (e) {
      debugPrint('Error syncing delete savings goal to Supabase: $e');
    }
  }

  Future<void> addSavings(String goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final updated = SavingsGoal(
        id: goal.id,
        userId: goal.userId,
        title: goal.title,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount + amount,
        deadline: goal.deadline,
        emoji: goal.emoji,
        color: goal.color,
      );
      
      // Update locally first
      _goals[index] = updated;
      notifyListeners();
      
      try {
        if (updated.userId != 'anonymous') {
          await _supabaseService.updateSavingsGoal(updated);
        }
      } catch (e) {
        debugPrint('Error syncing savings update to Supabase: $e');
      }
    }
  }

  double get totalSaved =>
      _goals.fold(0, (sum, goal) => sum + goal.savedAmount);
  double get totalTarget =>
      _goals.fold(0, (sum, goal) => sum + goal.targetAmount);
  double get overallProgress =>
      totalTarget > 0 ? totalSaved / totalTarget : 0.0;
}

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/income.dart';
import '../core/constants/constants.dart';
import '../services/supabase_service.dart';
import 'notification_viewmodel.dart';

class ExpenseViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService;
  NotificationViewModel? _notificationViewModel;
  String? _userId;

  List<Expense> _allExpenses = [];
  List<Income> _allIncomes = [];
  Budget _monthlyBudget = Budget(
    limit: 0.0,
    spent: 0.0,
    month: DateTime.now().month,
    year: DateTime.now().year,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ExpenseViewModel(this._supabaseService) {
    if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
      _loadSampleData();
    }
  }

  void setNotificationViewModel(NotificationViewModel? vm) {
    _notificationViewModel = vm;
  }

  void _loadSampleData() {
    _allIncomes = [
      Income(
        id: '1',
        userId: 'test-user-id',
        title: 'Monthly Salary',
        amount: 5000.0,
        category: IncomeCategory.salary,
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    _allExpenses = [
      Expense(
        id: '1',
        userId: 'test-user-id',
        title: 'Grocery Shopping',
        amount: 150.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: ExpenseCategory.food,
      ),
      Expense(
        id: '2',
        userId: 'test-user-id',
        title: 'Monthly Rent',
        amount: 1200.0,
        date: DateTime.now().subtract(const Duration(days: 10)),
        category: ExpenseCategory.bills,
      ),
    ];
    _monthlyBudget = Budget(
      limit: 2000.0,
      spent: 1350.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
    );
  }

  void updateUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
      if (_userId != null) {
        fetchData();
      } else {
        _allExpenses = [];
        _allIncomes = [];
        notifyListeners();
      }
    }
  }

  Future<void> fetchData() async {
    if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
      _recalculateBudget();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final expenses = await _supabaseService.getExpenses();
      final incomes = await _supabaseService.getIncomes();
      final budgetData = await _supabaseService.getBudget(
        _monthlyBudget.month,
        _monthlyBudget.year,
      );

      _allExpenses = expenses;
      _allIncomes = incomes;
      
      if (budgetData != null) {
        _monthlyBudget = Budget(
          limit: (budgetData['limit'] as num).toDouble(),
          spent: 0, // Will be recalculated
          month: _monthlyBudget.month,
          year: _monthlyBudget.year,
        );
      }

      _recalculateBudget();
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _recalculateBudget() {
    double spent = expenses.fold(0, (sum, e) {
      if (e.date.month == _monthlyBudget.month &&
          e.date.year == _monthlyBudget.year) {
        return sum + e.amount;
      }
      return sum;
    });
    _monthlyBudget = Budget(
      limit: _monthlyBudget.limit,
      spent: spent,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    // Fire budget & balance notifications
    _notificationViewModel?.checkBudget(spent, _monthlyBudget.limit);
    _notificationViewModel?.checkBalance(balance);
  }

  List<Expense> get expenses =>
      _allExpenses.where((e) => e.userId == _userId).toList();
  List<Income> get incomes =>
      _allIncomes.where((i) => i.userId == _userId).toList();
  Budget get monthlyBudget => _monthlyBudget;

  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);
  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);
  double get balance => totalIncome - totalExpenses;

  Future<void> addIncome(Income income) async {
    // Add locally first
    _allIncomes.insert(0, income);
    notifyListeners();
    // Fire notification
    _notificationViewModel?.onIncomeAdded(income.title, income.amount);

    try {
      if (income.userId != 'anonymous') {
        await _supabaseService.addIncome(income);
      }
    } catch (e) {
      debugPrint('Error syncing income to Supabase: $e');
    }
  }

  Future<void> deleteIncome(String id) async {
    // Remove locally first
    _allIncomes.removeWhere((i) => i.id == id);
    notifyListeners();

    try {
      await _supabaseService.deleteIncome(id);
    } catch (e) {
      debugPrint('Error syncing delete income to Supabase: $e');
    }
  }

  Future<void> addExpense(Expense expense) async {
    // Add locally first
    _allExpenses.insert(0, expense);
    _recalculateBudget();
    notifyListeners();
    // Fire notification
    _notificationViewModel?.onExpenseAdded(expense.title, expense.amount);

    try {
      if (expense.userId != 'anonymous') {
        await _supabaseService.addExpense(expense);
      }
    } catch (e) {
      debugPrint('Error syncing expense to Supabase: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    // Remove locally first
    _allExpenses.removeWhere((e) => e.id == id);
    _recalculateBudget();
    notifyListeners();

    try {
      await _supabaseService.deleteExpense(id);
    } catch (e) {
      debugPrint('Error syncing delete expense to Supabase: $e');
    }
  }

  Future<void> updateExpense(Expense updated) async {
    // Update locally first
    final index = _allExpenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _allExpenses[index] = updated;
      _recalculateBudget();
      notifyListeners();
    }

    try {
      if (updated.userId != 'anonymous') {
        await _supabaseService.updateExpense(updated);
      }
    } catch (e) {
      debugPrint('Error syncing update expense to Supabase: $e');
    }
  }

  Future<void> updateIncome(Income updated) async {
    // Update locally first
    final index = _allIncomes.indexWhere((i) => i.id == updated.id);
    if (index != -1) {
      _allIncomes[index] = updated;
      notifyListeners();
    }

    try {
      if (updated.userId != 'anonymous') {
        await _supabaseService.updateIncome(updated);
      }
    } catch (e) {
      debugPrint('Error syncing update income to Supabase: $e');
    }
  }

  Future<void> updateBudgetLimit(double newLimit) async {
    // Update locally first
    _monthlyBudget = Budget(
      limit: newLimit,
      spent: _monthlyBudget.spent,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    notifyListeners();

    try {
      if (_userId != null && _userId != 'anonymous') {
        await _supabaseService.upsertBudget(
          newLimit,
          _monthlyBudget.month,
          _monthlyBudget.year,
        );
      }
    } catch (e) {
      debugPrint('Error syncing budget to Supabase: $e');
    }
  }

  Map<ExpenseCategory, double> getCategoryBreakdown() {
    Map<ExpenseCategory, double> breakdown = {};
    for (var expense in expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  List<Expense> getExpensesForPeriod(String period) {
    final now = DateTime.now();
    return expenses.where((e) {
      switch (period) {
        case 'Daily':
          return e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day;
        case 'Weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          return e.date.isAfter(weekStart.subtract(const Duration(days: 1)));
        case 'Monthly':
          return e.date.year == now.year && e.date.month == now.month;
        case 'Yearly':
          return e.date.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  Map<ExpenseCategory, double> getCategoryBreakdownForPeriod(String period) {
    final filtered = getExpensesForPeriod(period);
    Map<ExpenseCategory, double> breakdown = {};
    for (var expense in filtered) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  double getTotalExpensesForPeriod(String period) {
    return getExpensesForPeriod(period).fold(0, (sum, e) => sum + e.amount);
  }

  List<Income> getIncomesForPeriod(String period) {
    final now = DateTime.now();
    return incomes.where((i) {
      switch (period) {
        case 'Daily':
          return i.date.year == now.year &&
              i.date.month == now.month &&
              i.date.day == now.day;
        case 'Weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          return i.date.isAfter(weekStart.subtract(const Duration(days: 1)));
        case 'Monthly':
          return i.date.year == now.year && i.date.month == now.month;
        case 'Yearly':
          return i.date.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  double getTotalIncomeForPeriod(String period) {
    return getIncomesForPeriod(period).fold(0, (sum, i) => sum + i.amount);
  }

  // Budget Alert Logic
  bool get isNearLimit =>
      monthlyBudget.spent >= (monthlyBudget.limit * 0.95) &&
      monthlyBudget.spent < monthlyBudget.limit;
  bool get isExceeded => monthlyBudget.spent >= monthlyBudget.limit && monthlyBudget.limit > 0;
}

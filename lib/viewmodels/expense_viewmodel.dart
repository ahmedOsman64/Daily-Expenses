import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/income.dart';
import '../core/constants/constants.dart';

class ExpenseViewModel extends ChangeNotifier {
  String? _userId;

  final List<Expense> _allExpenses = [
    Expense(
      id: '1',
      userId: 'user_123',
      title: 'Groceries',
      amount: 50.0,
      category: ExpenseCategory.food,
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      userId: 'user_123',
      title: 'Uber Ride',
      amount: 15.0,
      category: ExpenseCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '3',
      userId: 'user_123',
      title: 'Monthly Rent',
      amount: 1200.0,
      category: ExpenseCategory.bills,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<Income> _allIncomes = [
    Income(
      id: 'i1',
      userId: 'user_123',
      title: 'Monthly Salary',
      amount: 5000.0,
      category: IncomeCategory.salary,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  Budget _monthlyBudget = Budget(
    limit: 2000.0,
    spent: 0.0,
    month: DateTime.now().month,
    year: DateTime.now().year,
  );

  void updateUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
      _recalculateBudget();
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

  void addIncome(Income income) {
    _allIncomes.insert(0, income);
    notifyListeners();
  }

  void deleteIncome(String id) {
    _allIncomes.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _allExpenses.insert(0, expense);
    _recalculateBudget();
    notifyListeners();
  }

  void deleteExpense(String id) {
    _allExpenses.removeWhere((e) => e.id == id);
    _recalculateBudget();
    notifyListeners();
  }

  void updateExpense(Expense updated) {
    final index = _allExpenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    _allExpenses[index] = updated;
    _recalculateBudget();
    notifyListeners();
  }

  void updateIncome(Income updated) {
    final index = _allIncomes.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    _allIncomes[index] = updated;
    notifyListeners();
  }

  void updateBudgetLimit(double newLimit) {
    _monthlyBudget = Budget(
      limit: newLimit,
      spent: _monthlyBudget.spent,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    notifyListeners();
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
  bool get isExceeded => monthlyBudget.spent >= monthlyBudget.limit;
}

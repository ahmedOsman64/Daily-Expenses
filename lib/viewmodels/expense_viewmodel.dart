import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/income.dart';
import '../core/constants/constants.dart';

class ExpenseViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Groceries',
      amount: 50.0,
      category: ExpenseCategory.food,
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      title: 'Uber Ride',
      amount: 15.0,
      category: ExpenseCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '3',
      title: 'Monthly Rent',
      amount: 1200.0,
      category: ExpenseCategory.bills,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<Income> _incomes = [
    Income(
      id: 'i1',
      title: 'Monthly Salary',
      amount: 5000.0,
      category: IncomeCategory.salary,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  Budget _monthlyBudget = Budget(
    limit: 2000.0,
    spent: 1265.0,
    month: DateTime.now().month,
    year: DateTime.now().year,
  );

  List<Expense> get expenses => _expenses;
  List<Income> get incomes => _incomes;
  Budget get monthlyBudget => _monthlyBudget;

  double get totalExpenses => _expenses.fold(0, (sum, item) => sum + item.amount);
  double get totalIncome => _incomes.fold(0, (sum, item) => sum + item.amount);
  double get balance => totalIncome - totalExpenses;

  void addIncome(Income income) {
    _incomes.insert(0, income);
    notifyListeners();
  }

  void deleteIncome(String id) {
    _incomes.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.insert(0, expense);
    _monthlyBudget = Budget(
      limit: _monthlyBudget.limit,
      spent: _monthlyBudget.spent + expense.amount,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    notifyListeners();
  }

  void deleteExpense(String id) {
    final expense = _expenses.firstWhere((e) => e.id == id);
    _expenses.removeWhere((e) => e.id == id);
    _monthlyBudget = Budget(
      limit: _monthlyBudget.limit,
      spent: _monthlyBudget.spent - expense.amount,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    notifyListeners();
  }

  void updateExpense(Expense updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    final oldAmount = _expenses[index].amount;
    _expenses[index] = updated;
    _monthlyBudget = Budget(
      limit: _monthlyBudget.limit,
      spent: _monthlyBudget.spent - oldAmount + updated.amount,
      month: _monthlyBudget.month,
      year: _monthlyBudget.year,
    );
    notifyListeners();
  }

  void updateIncome(Income updated) {
    final index = _incomes.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    _incomes[index] = updated;
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
    for (var expense in _expenses) {
      breakdown[expense.category] = (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  List<Expense> getExpensesForPeriod(String period) {
    final now = DateTime.now();
    return _expenses.where((e) {
      switch (period) {
        case 'Daily':
          return e.date.year == now.year && e.date.month == now.month && e.date.day == now.day;
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
      breakdown[expense.category] = (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  double getTotalExpensesForPeriod(String period) {
    return getExpensesForPeriod(period).fold(0, (sum, e) => sum + e.amount);
  }

  List<Income> getIncomesForPeriod(String period) {
    final now = DateTime.now();
    return _incomes.where((i) {
      switch (period) {
        case 'Daily':
          return i.date.year == now.year && i.date.month == now.month && i.date.day == now.day;
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
}

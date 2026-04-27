class AppConstants {
  static const String appName = 'Daily Expenses';
  
  // Storage Keys
  static const String keyDarkMode = 'is_dark_mode';
  static const String keyUserLoggedIn = 'is_user_logged_in';
}

enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  other
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.food: return 'Food';
      case ExpenseCategory.transport: return 'Transport';
      case ExpenseCategory.shopping: return 'Shopping';
      case ExpenseCategory.bills: return 'Bills';
      case ExpenseCategory.entertainment: return 'Entertainment';
      case ExpenseCategory.other: return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.food: return '🍔';
      case ExpenseCategory.transport: return '🚗';
      case ExpenseCategory.shopping: return '🛍️';
      case ExpenseCategory.bills: return '📄';
      case ExpenseCategory.entertainment: return '🎬';
      case ExpenseCategory.other: return '📦';
    }
  }
}

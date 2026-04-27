
enum IncomeCategory {
  salary,
  business,
  investment,
  gift,
  other,
}

extension IncomeCategoryExtension on IncomeCategory {
  String get name {
    switch (this) {
      case IncomeCategory.salary: return 'Salary';
      case IncomeCategory.business: return 'Business';
      case IncomeCategory.investment: return 'Investment';
      case IncomeCategory.gift: return 'Gift';
      case IncomeCategory.other: return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case IncomeCategory.salary: return '💼';
      case IncomeCategory.business: return '🏢';
      case IncomeCategory.investment: return '📈';
      case IncomeCategory.gift: return '🎁';
      case IncomeCategory.other: return '💰';
    }
  }
}

class Income {
  final String id;
  final String title;
  final double amount;
  final IncomeCategory category;
  final DateTime date;
  final String? description;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}

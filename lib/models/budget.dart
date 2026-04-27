class Budget {
  final double limit;
  final double spent;
  final int month;
  final int year;

  Budget({
    required this.limit,
    required this.spent,
    required this.month,
    required this.year,
  });

  double get remaining => limit - spent;
  double get percentage => (spent / limit).clamp(0.0, 1.0);
}

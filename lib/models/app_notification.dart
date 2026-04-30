import 'package:flutter/material.dart';

enum NotificationType { budget, expense, income, warning, info }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.budget:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.expense:
        return Icons.arrow_upward_rounded;
      case NotificationType.income:
        return Icons.arrow_downward_rounded;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.info:
        return Icons.info_outline_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.budget:
        return const Color(0xFFFFB300);
      case NotificationType.expense:
        return const Color(0xFFEF5350);
      case NotificationType.income:
        return const Color(0xFF66BB6A);
      case NotificationType.warning:
        return const Color(0xFFFF7043);
      case NotificationType.info:
        return const Color(0xFF42A5F5);
    }
  }
}

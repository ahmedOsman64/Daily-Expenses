import 'package:flutter/material.dart';
import '../models/app_notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications.reversed.toList());

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
  }) {
    _notifications.add(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// Called when a new expense is added
  void onExpenseAdded(String title, double amount) {
    addNotification(
      title: 'New Expense Added',
      body: '$title — \$${amount.toStringAsFixed(2)}',
      type: NotificationType.expense,
    );
  }

  /// Called when a new income is added
  void onIncomeAdded(String title, double amount) {
    addNotification(
      title: 'Income Received',
      body: '$title — \$${amount.toStringAsFixed(2)}',
      type: NotificationType.income,
    );
  }

  /// Called after budget recalculation to check thresholds
  void checkBudget(double spent, double limit) {
    if (limit <= 0) return;
    final ratio = spent / limit;

    if (ratio >= 1.0) {
      // Check if we already have an "exceeded" notification recently
      final hasRecent = _notifications.any(
        (n) =>
            n.type == NotificationType.warning &&
            n.title == 'Budget Exceeded!' &&
            DateTime.now().difference(n.createdAt).inMinutes < 5,
      );
      if (!hasRecent) {
        addNotification(
          title: 'Budget Exceeded!',
          body:
              'You have spent \$${spent.toStringAsFixed(2)} out of your \$${limit.toStringAsFixed(2)} budget.',
          type: NotificationType.warning,
        );
      }
    } else if (ratio >= 0.8) {
      final hasRecent = _notifications.any(
        (n) =>
            n.type == NotificationType.budget &&
            n.title == 'Budget Alert' &&
            DateTime.now().difference(n.createdAt).inMinutes < 30,
      );
      if (!hasRecent) {
        addNotification(
          title: 'Budget Alert',
          body:
              'You\'ve used ${(ratio * 100).toStringAsFixed(0)}% of your monthly budget.',
          type: NotificationType.budget,
        );
      }
    }
  }

  /// Called to check if balance is negative
  void checkBalance(double balance) {
    if (balance < 0) {
      final hasRecent = _notifications.any(
        (n) =>
            n.type == NotificationType.warning &&
            n.title == 'Negative Balance' &&
            DateTime.now().difference(n.createdAt).inMinutes < 60,
      );
      if (!hasRecent) {
        addNotification(
          title: 'Negative Balance',
          body:
              'Your expenses exceed your income by \$${(-balance).toStringAsFixed(2)}. Consider reviewing your spending.',
          type: NotificationType.warning,
        );
      }
    }
  }

  /// Daily greeting notification — call on login
  void sendWelcomeNotification(String? userName) {
    final hour = DateTime.now().hour;
    final greeting =
        hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    final name = userName ?? 'there';

    // Only send once per day
    final alreadySentToday = _notifications.any(
      (n) =>
          n.type == NotificationType.info &&
          n.title.startsWith(greeting) &&
          n.createdAt.day == DateTime.now().day,
    );
    if (!alreadySentToday) {
      addNotification(
        title: '$greeting, $name! 👋',
        body: 'Track your spending today and stay on top of your finances.',
        type: NotificationType.info,
      );
    }
  }
}

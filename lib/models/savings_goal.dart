import 'package:flutter/material.dart';

class SavingsGoal {
  final String id;
  final String userId;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final String emoji;
  final Color color;

  SavingsGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    required this.emoji,
    required this.color,
  });

  double get progress => (savedAmount / targetAmount).clamp(0.0, 1.0);
  double get remaining => targetAmount - savedAmount;
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'target_amount': targetAmount,
      'saved_amount': savedAmount,
      'deadline': deadline.toIso8601String(),
      'emoji': emoji,
      'color': color.toARGB32(),
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'],
      userId: map['user_id'] ?? '',
      title: map['title'],
      targetAmount: map['target_amount'],
      savedAmount: map['saved_amount'],
      deadline: DateTime.parse(map['deadline']),
      emoji: map['emoji'] ?? '💰',
      color: Color(map['color']),
    );
  }
}

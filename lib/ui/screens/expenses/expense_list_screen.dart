import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../models/expense.dart';
import '../../../models/income.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/constants.dart';
import 'edit_transaction_screen.dart';
import 'package:intl/intl.dart';


class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String categoryName;
  final String categoryIcon;
  final Expense? expense;
  final Income? income;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.categoryName,
    required this.categoryIcon,
    this.expense,
    this.income,
  });
}

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Consumer<ExpenseViewModel>(
            builder: (context, vm, _) {
              final List<TransactionItem> allTransactions = [
                ...vm.expenses.map(
                  (e) => TransactionItem(
                    id: e.id,
                    title: e.title,
                    amount: e.amount,
                    date: e.date,
                    isIncome: false,
                    categoryName: e.category.name,
                    categoryIcon: e.category.icon,
                    expense: e,
                  ),
                ),
                ...vm.incomes.map(
                  (i) => TransactionItem(
                    id: i.id,
                    title: i.title,
                    amount: i.amount,
                    date: i.date,
                    isIncome: true,
                    categoryName: i.category.name,
                    categoryIcon: i.category.icon,
                    income: i,
                  ),
                ),
              ];

              allTransactions.sort((a, b) => b.date.compareTo(a.date));

              if (allTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No transactions yet.',
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: allTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = allTransactions[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => _showActionSheet(context, transaction, vm),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        (transaction.isIncome
                                                ? AppColors.success
                                                : AppColors.error)
                                            .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    transaction.categoryIcon,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.title,
                                        style: AppTypography.bodyLarge.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${transaction.categoryName} • ${DateFormat('MMM dd, yyyy').format(transaction.date)}',
                                        style: AppTypography.caption.copyWith(
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${transaction.isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: transaction.isIncome
                                            ? AppColors.success
                                            : AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Icon(
                                      Icons.more_horiz_rounded,
                                      color: Colors.white30,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showActionSheet(
    BuildContext context,
    TransactionItem transaction,
    ExpenseViewModel vm,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3C),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          (transaction.isIncome
                                  ? AppColors.success
                                  : AppColors.error)
                              .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      transaction.categoryIcon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${transaction.categoryName} • ${DateFormat('MMM dd, yyyy').format(transaction.date)}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${transaction.isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
                    style: TextStyle(
                      color: transaction.isIncome
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // View Button
              _actionButton(
                icon: Icons.visibility_rounded,
                label: 'View Details',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  _showDetails(context, transaction);
                },
              ),
              const SizedBox(height: 12),
              // Edit Button
              _actionButton(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: AppColors.secondary,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTransactionScreen(
                        expense: transaction.expense,
                        income: transaction.income,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // Delete Button
              _actionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(ctx);
                  if (transaction.isIncome) {
                    vm.deleteIncome(transaction.id);
                  } else {
                    vm.deleteExpense(transaction.id);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${transaction.isIncome ? 'Income' : 'Expense'} deleted',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withValues(alpha: 0.5),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, TransactionItem transaction) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3C),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transaction.categoryIcon,
                style: const TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 16),
              Text(
                transaction.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${transaction.isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  color: transaction.isIncome
                      ? AppColors.success
                      : AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 24),
              _detailRow('Type', transaction.isIncome ? 'Income' : 'Expense'),
              _detailRow('Category', transaction.categoryName),
              _detailRow(
                'Date',
                DateFormat('MMMM dd, yyyy').format(transaction.date),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

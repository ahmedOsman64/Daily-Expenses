import 'dart:io' as io;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../models/expense.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../navigation/app_router.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/constants.dart';
import '../../components/summary_card.dart';
import '../../components/financial_wisdom_card.dart';
import '../../../viewmodels/notification_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final expenseVm = context.watch<ExpenseViewModel>();
    final notifVm = context.watch<NotificationViewModel>();

    // Send welcome notification once per session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifVm.sendWelcomeNotification(authVm.userName);
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top App Bar Style
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              authVm.userName ?? 'User',
                              style: AppTypography.headingLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Bell icon with unread badge
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRouter.notifications),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                                  ),
                                  if (notifVm.unreadCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF5350),
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                        child: Text(
                                          notifVm.unreadCount > 9 ? '9+' : '${notifVm.unreadCount}',
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Avatar / Settings
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRouter.settings),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                                  child: authVm.profileImage != null
                                      ? ClipOval(
                                          child: Image(
                                            image: authVm.profileImage!.startsWith('http') || authVm.profileImage!.startsWith('blob:')
                                                ? NetworkImage(authVm.profileImage!)
                                                : FileImage(io.File(authVm.profileImage!)) as ImageProvider,
                                            fit: BoxFit.cover,
                                            width: 48,
                                            height: 48,
                                            errorBuilder: (context, error, stackTrace) => Center(
                                              child: Text(
                                                (authVm.userName ?? 'U').substring(0, 1).toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          (authVm.userName ?? 'U').substring(0, 1).toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Summary Cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        SummaryCard(
                          title: 'Total Balance',
                          amount: CurrencyFormatter.formatCompact(
                            expenseVm.balance,
                          ),
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                        ),
                        SummaryCard(
                          title: 'Expenses',
                          amount: CurrencyFormatter.formatCompact(
                            expenseVm.totalExpenses,
                          ),
                          icon: Icons.show_chart_rounded,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),
                // Financial Wisdom Section
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: FinancialWisdomCard(),
                  ),
                ),
                // Plan Section
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildPlanCard(context),
                  ),
                ),
                // Budget Section
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: _buildBudgetProgress(expenseVm),
                  ),
                ),
                // Recent Expenses Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: AppTypography.headingMedium.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRouter.expenseList,
                          ),
                          child: const Text(
                            'View All',
                            style: TextStyle(color: AppColors.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Recent Expenses List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recent = expenseVm.expenses.take(5).toList();
                        if (recent.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No transactions yet',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }
                        final expense = recent[index];
                        return _buildExpenseTile(expense);
                      },
                      childCount: expenseVm.expenses.isEmpty
                          ? 1
                          : (expenseVm.expenses.length > 5
                                ? 5
                                : expenseVm.expenses.length),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          // Bottom Navigation (Floating style)
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: _buildFloatingBottomNav(context),
          ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addExpense),
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBudgetProgress(ExpenseViewModel vm) {
    final budget = vm.monthlyBudget;
    final isNearLimit = vm.isNearLimit;
    final isExceeded = vm.isExceeded;
    final statusColor = isExceeded ? AppColors.error : (isNearLimit ? Colors.orange : AppColors.primary);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isExceeded 
                ? AppColors.error.withValues(alpha: 0.05) 
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isExceeded 
                  ? AppColors.error.withValues(alpha: 0.3) 
                  : Colors.white.withValues(alpha: 0.1)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Monthly Budget',
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isNearLimit || isExceeded) ...[
                        const SizedBox(width: 8),
                        Icon(
                          isExceeded ? Icons.error_outline_rounded : Icons.warning_amber_rounded,
                          color: statusColor,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(budget.percentage * 100).toInt()}%',
                      style: AppTypography.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (isNearLimit && !isExceeded)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Alert: Only 5% remaining!',
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              if (isExceeded)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Text(
                    'Danger: Budget Limit Exceeded!',
                    style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: 12,
                        width:
                            constraints.maxWidth *
                            budget.percentage.clamp(0, 1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isExceeded 
                                ? [AppColors.error, Colors.red.shade900]
                                : [statusColor, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${CurrencyFormatter.format(budget.spent)} spent',
                    style: AppTypography.caption.copyWith(
                      color: isExceeded ? AppColors.error : Colors.white70,
                    ),
                  ),
                  Text(
                    'Limit: ${CurrencyFormatter.format(budget.limit)}',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseTile(Expense expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              expense.category.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  expense.category.name,
                  style: AppTypography.caption.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          Text(
            '-${CurrencyFormatter.format(expense.amount)}',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', true, () {}),
              _buildNavItem(Icons.bar_chart_rounded, 'Analytics', false, () {
                Navigator.pushNamed(context, AppRouter.analytics);
              }),
              const SizedBox(width: 40), // Space for FAB
              _buildNavItem(
                Icons.account_balance_wallet_rounded,
                'Wallet',
                false,
                () {
                  Navigator.pushNamed(context, AppRouter.wallet);
                },
              ),
              _buildNavItem(Icons.person_rounded, 'Profile', false, () {
                Navigator.pushNamed(context, AppRouter.settings);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.white60,
            size: 28,
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 4,
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRouter.plan),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_graph_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Plan',
                        style: AppTypography.headingSmall.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Set and track your savings goals',
                        style: AppTypography.bodySmall.copyWith(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

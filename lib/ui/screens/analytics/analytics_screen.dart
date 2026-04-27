import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../navigation/app_router.dart';
import '../../components/floating_nav_bar.dart';
import '../../../core/services/pdf_service.dart';


class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  String _selectedPeriod = 'Monthly';

  Future<void> _downloadReport() async {
    final vm = context.read<ExpenseViewModel>();
    final authVm = context.read<AuthViewModel>();
    
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating PDF Report...'), duration: Duration(seconds: 1)),
    );

    try {
      await PdfService.generateReport(
        userName: authVm.userName ?? 'User',
        period: _selectedPeriod,
        totalIncome: vm.getTotalIncomeForPeriod(_selectedPeriod),
        totalExpenses: vm.getTotalExpensesForPeriod(_selectedPeriod),
        expenses: vm.getExpensesForPeriod(_selectedPeriod),
        incomes: vm.getIncomesForPeriod(_selectedPeriod),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override

  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Spending Analytics',
                              style: AppTypography.headingLarge.copyWith(color: Colors.white, fontSize: 24),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: _downloadReport,
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Period Selector
                    _buildPeriodSelector(),
                    const SizedBox(height: 24),
                    // Summary Card
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    // Pie Chart Card
                    _buildChartCard(),
                    const SizedBox(height: 32),
                    Text(
                      'Category Breakdown',
                      style: AppTypography.headingMedium.copyWith(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryList(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            const FloatingNavBar(currentIndex: 1),
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

  Widget _buildPeriodSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: _periods.map((period) {
              final isSelected = period == _selectedPeriod;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = period),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Text(
                      period,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final vm = context.watch<ExpenseViewModel>();
    final total = vm.getTotalExpensesForPeriod(_selectedPeriod);
    final count = vm.getExpensesForPeriod(_selectedPeriod).length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_selectedPeriod Spending',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(total),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Transactions', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(
                '$_selectedPeriod Overview',
                style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              SizedBox(height: 220, child: _buildPieChart()),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.white54, size: 16),
                  SizedBox(width: 8),
                  Text('Tap sections for details', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final vm = context.watch<ExpenseViewModel>();
    final breakdown = vm.getCategoryBreakdownForPeriod(_selectedPeriod);
    final total = vm.getTotalExpensesForPeriod(_selectedPeriod);

    if (total == 0 || breakdown.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline_rounded, size: 64, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(
              'No data for $_selectedPeriod period',
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 60,
        sections: breakdown.entries.map((entry) {
          final percentage = (entry.value / total) * 100;
          return PieChartSectionData(
            color: _getCategoryColor(entry.key),
            value: entry.value,
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 40,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryList() {
    final vm = context.watch<ExpenseViewModel>();
    final breakdown = vm.getCategoryBreakdownForPeriod(_selectedPeriod);
    final total = vm.getTotalExpensesForPeriod(_selectedPeriod);

    if (breakdown.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text('No expenses for this period.', style: TextStyle(color: Colors.white54, fontSize: 14)),
        ),
      );
    }

    // Sort by value descending
    final sortedEntries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
        final barFraction = total > 0 ? (entry.value / total) : 0.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(entry.key).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(entry.key.icon, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(
                          '${percentage.toStringAsFixed(1)}% of total',
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(entry.value),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: barFraction,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(entry.key)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.food: return AppColors.catFood;
      case ExpenseCategory.transport: return AppColors.catTransport;
      case ExpenseCategory.shopping: return AppColors.catShopping;
      case ExpenseCategory.bills: return AppColors.catBills;
      case ExpenseCategory.entertainment: return AppColors.catEntertainment;
      case ExpenseCategory.other: return AppColors.catOther;
    }
  }
}

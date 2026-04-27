import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';

class ManageBudgetScreen extends StatefulWidget {
  const ManageBudgetScreen({super.key});

  @override
  State<ManageBudgetScreen> createState() => _ManageBudgetScreenState();
}

class _ManageBudgetScreenState extends State<ManageBudgetScreen> with SingleTickerProviderStateMixin {
  final _budgetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  double _currentLimit = 0;

  @override
  void initState() {
    super.initState();
    final expenseVm = context.read<ExpenseViewModel>();
    _currentLimit = expenseVm.monthlyBudget.limit;
    _budgetController.text = _currentLimit.toStringAsFixed(0);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final newLimit = double.parse(_budgetController.text);
      final expenseVm = context.read<ExpenseViewModel>();
      expenseVm.updateBudgetLimit(newLimit);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseVm = context.watch<ExpenseViewModel>();
    final budget = expenseVm.monthlyBudget;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Budgets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'Current Monthly Budget',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CurrencyFormatter.format(budget.limit),
                            style: AppTypography.headingLarge.copyWith(color: Colors.white, fontSize: 36),
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: budget.spent / budget.limit,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              budget.spent > budget.limit ? AppColors.error : AppColors.primary,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${CurrencyFormatter.format(budget.spent)} spent',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                '${CurrencyFormatter.format(budget.limit - budget.spent)} left',
                                style: TextStyle(
                                  color: budget.spent > budget.limit ? AppColors.error : Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Set New Limit',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              _buildGlassTextField(
                                controller: _budgetController,
                                label: 'Monthly Amount',
                                hint: 'e.g. 2000',
                                icon: Icons.attach_money_rounded,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Budget limit required';
                                  if (double.tryParse(v) == null) return 'Enter a valid number';
                                  if (double.parse(v) <= 0) return 'Limit must be greater than zero';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _saveBudget,
                          borderRadius: BorderRadius.circular(20),
                          child: const Center(
                            child: Text(
                              'Update Budget',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(icon, color: Colors.white70, size: 28),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

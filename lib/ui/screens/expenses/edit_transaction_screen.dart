import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../models/expense.dart';
import '../../../models/income.dart';
import '../../../theme/colors.dart';
import '../../../core/constants/constants.dart';
import 'package:intl/intl.dart';

class EditTransactionScreen extends StatefulWidget {
  /// Pass either [expense] or [income], not both.
  final Expense? expense;
  final Income? income;

  const EditTransactionScreen({super.key, this.expense, this.income})
      : assert(expense != null || income != null, 'Must provide expense or income');

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  ExpenseCategory? _selectedExpenseCat;
  IncomeCategory? _selectedIncomeCat;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  bool get _isExpense => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isExpense) {
      final e = widget.expense!;
      _titleController = TextEditingController(text: e.title);
      _amountController = TextEditingController(text: e.amount.toStringAsFixed(2));
      _noteController = TextEditingController(text: e.description ?? '');
      _selectedDate = e.date;
      _selectedExpenseCat = e.category;
    } else {
      final i = widget.income!;
      _titleController = TextEditingController(text: i.title);
      _amountController = TextEditingController(text: i.amount.toStringAsFixed(2));
      _noteController = TextEditingController(text: i.description ?? '');
      _selectedDate = i.date;
      _selectedIncomeCat = i.category;
    }

    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: Color(0xFF1A1F3C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<ExpenseViewModel>();
    final amount = double.parse(_amountController.text);
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();

    if (_isExpense) {
      vm.updateExpense(Expense(
        id: widget.expense!.id,
        userId: widget.expense!.userId,
        title: title,
        amount: amount,
        category: _selectedExpenseCat!,
        date: _selectedDate,
        description: note.isEmpty ? null : note,
      ));
    } else {
      vm.updateIncome(Income(
        id: widget.income!.id,
        userId: widget.income!.userId,
        title: title,
        amount: amount,
        category: _selectedIncomeCat!,
        date: _selectedDate,
        description: note.isEmpty ? null : note,
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_isExpense ? 'Expense' : 'Income'} updated!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _isExpense ? 'Edit Expense' : 'Edit Income',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Amount field (big)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Amount', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  prefixText: '\$ ',
                                  prefixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 28),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 36),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Amount required';
                                  if (double.tryParse(v) == null) return 'Invalid number';
                                  if (double.parse(v) <= 0) return 'Must be > 0';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Details card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGlassField(
                                controller: _titleController,
                                label: 'Title',
                                hint: _isExpense ? 'e.g. Groceries' : 'e.g. Salary',
                                icon: Icons.label_outline_rounded,
                                validator: (v) => v!.isEmpty ? 'Title required' : null,
                              ),
                              const SizedBox(height: 20),
                              _buildGlassField(
                                controller: _noteController,
                                label: 'Note (optional)',
                                hint: 'Add a note...',
                                icon: Icons.notes_rounded,
                              ),
                              const SizedBox(height: 20),
                              // Date picker
                              const Text('Date', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _pickDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today_rounded, color: Colors.white54, size: 20),
                                      const SizedBox(width: 12),
                                      Text(
                                        DateFormat('MMMM dd, yyyy').format(_selectedDate),
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.edit_calendar_rounded, color: Colors.white30, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Category selector
                              const Text('Category', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 12),
                              if (_isExpense) _buildExpenseCategoryGrid(),
                              if (!_isExpense) _buildIncomeCategoryGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Save button
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: _isExpense
                              ? [AppColors.error, const Color(0xFFFF6B6B)]
                              : [AppColors.success, const Color(0xFF52D9A0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isExpense ? AppColors.error : AppColors.success).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _save,
                          borderRadius: BorderRadius.circular(20),
                          child: const Center(
                            child: Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
            prefixIcon: Icon(icon, color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ExpenseCategory.values.map((cat) {
        final isSelected = cat == _selectedExpenseCat;
        return GestureDetector(
          onTap: () => setState(() => _selectedExpenseCat = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(cat.name, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIncomeCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: IncomeCategory.values.map((cat) {
        final isSelected = cat == _selectedIncomeCat;
        return GestureDetector(
          onTap: () => setState(() => _selectedIncomeCat = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.success.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelected ? AppColors.success : Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(cat.name, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/savings_goal.dart';

class SupabaseService {
  SupabaseClient get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      throw StateError('Supabase is not initialized (offline mode)');
    }
  }

  // --- AUTHENTICATION ---

  User? get currentUser {
    try {
      return _client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Stream<AuthState> get authStateChanges {
    try {
      return _client.auth.onAuthStateChange;
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
    return response;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  }) async {
    return await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
  }

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // --- EXPENSES ---

  Future<List<Expense>> getExpenses() async {
    final response = await _client
        .from('expenses')
        .select()
        .eq('user_id', currentUser?.id ?? '')
        .order('date', ascending: false);

    return (response as List).map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> addExpense(Expense expense) async {
    await _client.from('expenses').insert(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    await _client.from('expenses').update(expense.toMap()).eq('id', expense.id);
  }

  Future<void> deleteExpense(String id) async {
    await _client.from('expenses').delete().eq('id', id);
  }

  // --- INCOMES ---

  Future<List<Income>> getIncomes() async {
    final response = await _client
        .from('incomes')
        .select()
        .eq('user_id', currentUser?.id ?? '')
        .order('date', ascending: false);

    return (response as List).map((i) => Income.fromMap(i)).toList();
  }

  Future<void> addIncome(Income income) async {
    await _client.from('incomes').insert(income.toMap());
  }

  Future<void> updateIncome(Income income) async {
    await _client.from('incomes').update(income.toMap()).eq('id', income.id);
  }

  Future<void> deleteIncome(String id) async {
    await _client.from('incomes').delete().eq('id', id);
  }

  // --- SAVINGS GOALS ---

  Future<List<SavingsGoal>> getSavingsGoals() async {
    final response = await _client
        .from('savings_goals')
        .select()
        .eq('user_id', currentUser?.id ?? '');

    return (response as List).map((s) => SavingsGoal.fromMap(s)).toList();
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    await _client.from('savings_goals').insert(goal.toMap());
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    await _client.from('savings_goals').update(goal.toMap()).eq('id', goal.id);
  }

  Future<void> deleteSavingsGoal(String id) async {
    await _client.from('savings_goals').delete().eq('id', id);
  }

  // --- BUDGETS ---
  // Assuming a single budget record per month/year per user
  Future<Map<String, dynamic>?> getBudget(int month, int year) async {
    final response = await _client
        .from('budgets')
        .select()
        .eq('user_id', currentUser?.id ?? '')
        .eq('month', month)
        .eq('year', year)
        .maybeSingle();
    return response;
  }

  Future<void> upsertBudget(double limit, int month, int year) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    await _client.from('budgets').upsert({
      'user_id': userId,
      'limit': limit,
      'month': month,
      'year': year,
    }, onConflict: 'user_id, month, year');
  }
}

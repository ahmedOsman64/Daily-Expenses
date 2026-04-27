import 'package:flutter/material.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/dashboard/dashboard_screen.dart';
import '../ui/screens/expenses/add_expense_screen.dart';
import '../ui/screens/expenses/expense_list_screen.dart';
import '../ui/screens/income/add_income_screen.dart';
import '../ui/screens/analytics/analytics_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/settings/edit_profile_screen.dart';
import '../ui/screens/settings/change_password_screen.dart';
import '../ui/screens/budget/manage_budget_screen.dart';
import '../ui/screens/wallet/wallet_screen.dart';
import '../ui/screens/plan/plan_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String addExpense = '/add-expense';
  static const String addIncome = '/add-income';
  static const String expenseList = '/expense-list';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String wallet = '/wallet';
  static const String manageBudget = '/manage-budget';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String plan = '/plan';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case addExpense:
        return MaterialPageRoute(builder: (_) => const AddExpenseScreen());
      case addIncome:
        return MaterialPageRoute(builder: (_) => const AddIncomeScreen());
      case expenseList:
        return MaterialPageRoute(builder: (_) => const ExpenseListScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case manageBudget:
        return MaterialPageRoute(builder: (_) => const ManageBudgetScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case plan:
        return MaterialPageRoute(builder: (_) => const PlanScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${routeSettings.name}')),
          ),
        );
    }
  }
}

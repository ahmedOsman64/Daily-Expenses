import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/expense_viewmodel.dart';
import 'viewmodels/savings_viewmodel.dart';
import 'theme/theme.dart';
import 'navigation/app_router.dart';
import 'core/constants/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, ExpenseViewModel>(
          create: (_) => ExpenseViewModel(),
          update: (_, auth, expense) => expense!..updateUserId(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthViewModel, SavingsViewModel>(
          create: (_) => SavingsViewModel(),
          update: (_, auth, savings) => savings!..updateUserId(auth.userId),
        ),
      ],
      child: const DailyExpensesApp(),
    ),
  );
}

class DailyExpensesApp extends StatelessWidget {
  const DailyExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.system, // Follows device theme (Dark/Light) automatically
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

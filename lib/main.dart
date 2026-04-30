import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/expense_viewmodel.dart';
import 'viewmodels/savings_viewmodel.dart';
import 'viewmodels/notification_viewmodel.dart';
import 'services/supabase_service.dart';
import 'theme/theme.dart';
import 'navigation/app_router.dart';
import 'core/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ui.channelBuffers.resize('flutter/lifecycle', 100);

  try {
    if (AppConstants.supabaseUrl != 'YOUR_SUPABASE_URL') {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
    }
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SupabaseService()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<SupabaseService>()),
        ),
        // NotificationViewModel must be registered BEFORE ExpenseViewModel
        ChangeNotifierProvider(
          create: (_) => NotificationViewModel(),
        ),
        ChangeNotifierProxyProvider2<AuthViewModel, NotificationViewModel, ExpenseViewModel>(
          create: (context) =>
              ExpenseViewModel(context.read<SupabaseService>()),
          update: (_, auth, notif, expense) =>
              expense!
                ..setNotificationViewModel(notif)
                ..updateUserId(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthViewModel, SavingsViewModel>(
          create: (context) =>
              SavingsViewModel(context.read<SupabaseService>()),
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

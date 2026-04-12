import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'models/budget.dart';
import 'models/savings_state.dart';
import 'theme/theme.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(SavingsStateAdapter());
  
  // Open Boxes
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Budget>('budgets');
  await Hive.openBox<SavingsState>('savings');
  
  runApp(
    const ProviderScope(
      child: ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Expense Tracker',
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}

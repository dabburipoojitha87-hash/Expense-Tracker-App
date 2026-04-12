import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import 'budget_provider.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  final box = Hive.box<Expense>('expenses');
  return ExpenseNotifier(box, ref);
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  final Box<Expense> _box;
  final Ref _ref;

  ExpenseNotifier(this._box, this._ref) : super([]) {
    _loadExpenses();
  }

  void _loadExpenses() {
    state = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addExpense(Expense expense) async {
    await _box.add(expense);
    _ref.read(budgetProvider.notifier).updateSpentAmount(expense.category, expense.amount);
    _loadExpenses();
  }

  Future<void> deleteExpense(Expense expense) async {
    await expense.delete();
    _ref.read(budgetProvider.notifier).updateSpentAmount(expense.category, -expense.amount);
    _loadExpenses();
  }

  Future<void> clearAll() async {
    await _box.clear();
    state = [];
  }
}

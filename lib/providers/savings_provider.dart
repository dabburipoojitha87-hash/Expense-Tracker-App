import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/savings_state.dart';
import 'budget_provider.dart';
import 'expense_provider.dart';

final savingsProvider = StateNotifierProvider<SavingsNotifier, SavingsState>((ref) {
  final box = Hive.box<SavingsState>('savings');
  return SavingsNotifier(box, ref);
});

class SavingsNotifier extends StateNotifier<SavingsState> {
  final Box<SavingsState> _box;
  final Ref _ref;

  SavingsNotifier(this._box, this._ref) : super(SavingsState()) {
    _loadSavings();
  }

  void _loadSavings() {
    if (_box.isEmpty) {
      _box.add(SavingsState(totalAccumulatedSavings: 0.0));
    }
    state = _box.values.first;
  }

  double calculateCurrentCycleSavings() {
    final budgets = _ref.read(budgetProvider);
    return budgets.fold(0, (sum, budget) => sum + budget.savings);
  }

  Future<void> performMonthlyReset() async {
    final currentSavings = calculateCurrentCycleSavings();
    
    // Accumulate savings
    state.totalAccumulatedSavings += currentSavings;
    await state.save();
    
    // Reset expenses and spent amounts
    await _ref.read(expenseProvider.notifier).clearAll();
    await _ref.read(budgetProvider.notifier).resetSpent();
    
    _loadSavings();
  }
}

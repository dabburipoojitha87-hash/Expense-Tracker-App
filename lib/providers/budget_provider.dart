import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  final box = Hive.box<Budget>('budgets');
  return BudgetNotifier(box, ref);
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final Box<Budget> _box;

  BudgetNotifier(this._box, Ref ref) : super([]) {
    _loadBudgets();
  }

  void _loadBudgets() {
    state = _box.values.toList();
    if (state.isEmpty) {
      _initDefaultBudgets();
    }
  }

  void _initDefaultBudgets() {
    final defaults = [
      Budget(category: 'Food', budgetAmount: 500),
      Budget(category: 'Transport', budgetAmount: 200),
      Budget(category: 'Rent', budgetAmount: 1000),
      Budget(category: 'Entertainment', budgetAmount: 150),
      Budget(category: 'Shopping', budgetAmount: 200),
      Budget(category: 'Others', budgetAmount: 100),
    ];
    for (var b in defaults) {
      _box.put(b.category, b);
    }
    state = _box.values.toList();
  }

  Future<void> setBudget(String category, double amount) async {
    final existing = _box.get(category);
    if (existing != null) {
      existing.budgetAmount = amount;
      await existing.save();
    } else {
      await _box.put(category, Budget(category: category, budgetAmount: amount));
    }
    _loadBudgets();
  }

  Future<void> updateSpentAmount(String category, double delta) async {
    final budget = _box.get(category);
    if (budget != null) {
      budget.spentAmount += delta;
      await budget.save();
      _loadBudgets();
    }
  }

  Future<void> resetSpent() async {
    for (var budget in state) {
      budget.spentAmount = 0.0;
      await budget.save();
    }
    _loadBudgets();
  }

  double get totalSpent => state.fold(0, (sum, item) => sum + item.spentAmount);
  double get totalBudget => state.fold(0, (sum, item) => sum + item.budgetAmount);
}

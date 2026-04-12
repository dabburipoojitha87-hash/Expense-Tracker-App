import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/budget_provider.dart';
import '../theme/theme.dart';
import '../widgets/neo_card.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budgets', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.cream,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(budget.category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(LucideIcons.pencil, size: 20),
                        onPressed: () => _showEditBudget(context, ref, budget.category, budget.budgetAmount),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Budget: ₹${budget.budgetAmount.toStringAsFixed(0)}'),
                      Text(
                        'Spent: ₹${budget.spentAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: budget.spentAmount > budget.budgetAmount ? Colors.redAccent : AppTheme.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: budget.budgetAmount > 0 ? (budget.spentAmount / budget.budgetAmount).clamp(0, 1) : 0,
                    backgroundColor: AppTheme.cream,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      budget.spentAmount > budget.budgetAmount ? Colors.redAccent : AppTheme.black,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditBudget(BuildContext context, WidgetRef ref, String category, double currentAmount) {
    final controller = TextEditingController(text: currentAmount.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.black, width: 2),
        ),
        title: Text('Update Budget for $category'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newAmount = double.tryParse(controller.text) ?? currentAmount;
              ref.read(budgetProvider.notifier).setBudget(category, newAmount);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

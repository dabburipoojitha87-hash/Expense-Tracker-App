import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/budget.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/savings_provider.dart';
import '../widgets/neo_card.dart';
import '../widgets/expense_tile.dart';
import '../theme/theme.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    final budgets = ref.watch(budgetProvider);
    final budgetNotifier = ref.watch(budgetProvider.notifier);
    final savingsNotifier = ref.watch(savingsProvider.notifier);
    final savings = ref.watch(savingsProvider);

    final totalSpent = budgetNotifier.totalSpent;
    final totalBudget = budgetNotifier.totalBudget;
    final currentSavings = savingsNotifier.calculateCurrentCycleSavings();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, savings.totalAccumulatedSavings),
              const SizedBox(height: 24),
              _buildSummaryCards(totalSpent, totalBudget, currentSavings),
              const SizedBox(height: 32),
              const Text(
                'Spending Breakdown',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
          _buildChartSection(budgets),
          const SizedBox(height: 24),
          _buildPremiumCard(),
          const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All', style: TextStyle(color: AppTheme.black)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (expenses.isEmpty)
                const Center(child: Text('No expenses yet. Add some!'))
              else
                ...expenses.take(5).map((e) => ExpenseTile(
                      expense: e,
                      onDelete: () => ref.read(expenseProvider.notifier).deleteExpense(e),
                    )),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.black,
        foregroundColor: AppTheme.cream,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
        ),
        label: const Text('Add Expense'),
        icon: const Icon(LucideIcons.plus),
      ),
      bottomNavigationBar: _buildBottomNav(context, ref),
    );
  }

  Widget _buildHeader(BuildContext context, double totalSavings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back,', style: TextStyle(fontSize: 14)),
            const Text(
              'Finance Master',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.black, width: 2),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.piggyBank, size: 16),
              const SizedBox(width: 4),
              const Text(
                '₹ ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                totalSavings.toStringAsFixed(0),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(double spent, double budget, double savings) {
    return Column(
      children: [
        NeoCard(
          color: AppTheme.offWhite,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Spent', style: TextStyle(fontSize: 16)),
                  Text(
                    '₹${spent.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: budget > 0 ? (spent / budget).clamp(0, 1) : 0,
                  minHeight: 12,
                  backgroundColor: AppTheme.cream,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spent > budget ? Colors.redAccent : AppTheme.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget: ₹${budget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
                  Text(
                    'Remaining: ₹${(budget - spent).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: (budget - spent) < 0 ? Colors.redAccent : AppTheme.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(List<Budget> budgets) {
    // ... same as before but wrapping in a nicer layout if needed
    final activeBudgets = budgets.where((b) => b.spentAmount > 0).toList();
    if (activeBudgets.isEmpty) {
      return const NeoCard(
        height: 150,
        child: Center(child: Text('Add your first expense to see the breakdown!')),
      );
    }

    return NeoCard(
      height: 220,
      padding: const EdgeInsets.all(8),
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          sections: activeBudgets.map((b) {
            final index = activeBudgets.indexOf(b);
            return PieChartSectionData(
              value: b.spentAmount,
              title: '', // Hide title for cleaner look
              color: [
                Colors.amberAccent,
                Colors.blueAccent,
                Colors.purpleAccent,
                Colors.greenAccent,
                Colors.orangeAccent,
                Colors.pinkAccent,
              ][index % 6],
              radius: 50,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return NeoCard(
      color: Colors.amberAccent,
      child: Row(
        children: [
          const Icon(LucideIcons.crown, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FINANCIAL INSIGHTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Text('Do not save what is left after spending, but spend what is left after saving.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(context, ref, LucideIcons.layoutDashboard, true),
          _navIcon(context, ref, LucideIcons.wallet, false, onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BudgetScreen()),
          )),
          _navIcon(context, ref, LucideIcons.refreshCcw, false, onTap: () => _showResetDialog(context, ref)),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, WidgetRef ref, IconData icon, bool active, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, color: active ? AppTheme.cream : Colors.grey, size: 24),
      onPressed: onTap,
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.black, width: 2),
        ),
        title: const Text('Reset Monthly Cycle?'),
        content: const Text('This will clear all expenses and reset current spending, but your savings will be added to your lifetime total.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(savingsProvider.notifier).performMonthlyReset();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cycle reset successfully! Total savings updated.')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

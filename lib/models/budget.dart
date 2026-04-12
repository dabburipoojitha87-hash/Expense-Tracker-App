import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  double budgetAmount;

  @HiveField(2)
  double spentAmount;

  Budget({
    required this.category,
    required this.budgetAmount,
    this.spentAmount = 0.0,
  });

  double get remainingAmount => budgetAmount - spentAmount;
  
  // Savings is only positive (Budget - Spent)
  double get savings => (remainingAmount > 0) ? remainingAmount : 0.0;
}

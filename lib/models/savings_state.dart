import 'package:hive/hive.dart';

part 'savings_state.g.dart';

@HiveType(typeId: 2)
class SavingsState extends HiveObject {
  @HiveField(0)
  double totalAccumulatedSavings;

  SavingsState({
    this.totalAccumulatedSavings = 0.0,
  });
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'budget_controller.dart';

part 'budget_overview_provider.g.dart';

class CategoryBudgetStatus {
  final String categoryId;
  final double budgetAmount;
  final double spentAmount;
  final bool rollover;

  CategoryBudgetStatus({
    required this.categoryId,
    required this.budgetAmount,
    required this.spentAmount,
    required this.rollover,
  });

  double get remainingAmount => budgetAmount - spentAmount;
  double get percentUsed => budgetAmount > 0 ? spentAmount / budgetAmount : 0;
}

@riverpod
Future<List<CategoryBudgetStatus>> budgetOverview(Ref ref) async {
  final budgets = await ref.watch(budgetControllerProvider.future);
  final transactions = await ref.watch(transactionControllerProvider.future);

  final now = DateTime.now();
  final currentMonthTransactions = transactions.where((t) =>
      t.type == TransactionType.expense &&
      t.date.month == now.month &&
      t.date.year == now.year).toList();

  // Create a map of categoryId -> spentAmount
  final spentByCategory = <String, double>{};
  for (final t in currentMonthTransactions) {
    spentByCategory[t.categoryId] = (spentByCategory[t.categoryId] ?? 0.0) + t.amount;
  }

  // Map budgets to status, including categories that have spending but no budget
  // For MVP, we'll mostly focus on categories that HAVE a budget.
  return budgets.map((budget) {
    return CategoryBudgetStatus(
      categoryId: budget.categoryId,
      budgetAmount: budget.amount,
      spentAmount: spentByCategory[budget.categoryId] ?? 0.0,
      rollover: budget.rollover,
    );
  }).toList();
}

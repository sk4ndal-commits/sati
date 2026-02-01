import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'budget_controller.dart';
import 'allocation_budget_controller.dart';

part 'budget_overview_provider.g.dart';

class CategoryBudgetStatus {
  final String categoryId;
  final double budgetAmount;
  final double spentAmount;
  final bool rollover;
  final double unplannedPercent;

  CategoryBudgetStatus({
    required this.categoryId,
    required this.budgetAmount,
    required this.spentAmount,
    required this.rollover,
    required this.unplannedPercent,
  });

  double get remainingAmount => budgetAmount - spentAmount;
  double get percentUsed => budgetAmount > 0 ? spentAmount / budgetAmount : 0;
  bool get isFrequentlyUnplanned => unplannedPercent > 0.4;
}

class SavingBudgetStatus {
  final String id;
  final String name;
  final double? targetAmount;
  final double? monthlyAllocation;
  final double totalAllocated;
  final double spentThisMonth;
  final double allocatedThisMonth;

  SavingBudgetStatus({
    required this.id,
    required this.name,
    this.targetAmount,
    this.monthlyAllocation,
    required this.totalAllocated,
    required this.spentThisMonth,
    required this.allocatedThisMonth,
  });

  double get currentBalance => totalAllocated - spentThisMonth;
  double get progress {
    if (targetAmount == null || targetAmount == 0) return 0.0;
    return (totalAllocated - spentThisMonth) / targetAmount!;
  }
}

@riverpod
Future<List<CategoryBudgetStatus>> budgetOverview(Ref ref) async {
  final budgetsFuture = ref.watch(budgetControllerProvider.future);
  final transactionsFuture = ref.watch(transactionControllerProvider.future);

  final budgets = await budgetsFuture;
  final transactions = await transactionsFuture;

  final now = DateTime.now();
  final currentMonthTransactions = transactions.where((t) =>
      t.type == TransactionType.expense &&
      t.allocationBudgetId == null && // Only normal expenses
      t.date.month == now.month &&
      t.date.year == now.year).toList();

  // Create a map of categoryId -> {spentAmount, unplannedAmount}
  final statsByCategory = <String, _CategoryStats>{};
  for (final t in currentMonthTransactions) {
    final stats = statsByCategory.putIfAbsent(t.categoryId, () => _CategoryStats());
    stats.totalSpent += t.amount;
    if (t.planned == false) {
      stats.unplannedSpent += t.amount;
    }
  }

  // Map budgets to status, including categories that have spending but no budget
  // For MVP, we'll mostly focus on categories that HAVE a budget.
  return budgets.map((budget) {
    final stats = statsByCategory[budget.categoryId];
    final totalSpent = stats?.totalSpent ?? 0.0;
    final unplannedSpent = stats?.unplannedSpent ?? 0.0;
    final unplannedPercent = totalSpent > 0 ? unplannedSpent / totalSpent : 0.0;

    return CategoryBudgetStatus(
      categoryId: budget.categoryId,
      budgetAmount: budget.amount,
      spentAmount: totalSpent,
      rollover: budget.rollover,
      unplannedPercent: unplannedPercent,
    );
  }).toList();
}

@riverpod
Future<List<SavingBudgetStatus>> savingBudgetsOverview(Ref ref) async {
  final allocationsFuture = ref.watch(allocationBudgetControllerProvider.future);
  final transactionsFuture = ref.watch(transactionControllerProvider.future);

  final allocations = await allocationsFuture;
  final transactions = await transactionsFuture;

  final now = DateTime.now();

  return allocations.map((allocation) {
    // Cumulative expenses booked against this budget
    final totalSpent = transactions
        .where((t) => t.type == TransactionType.expense && t.allocationBudgetId == allocation.id)
        .fold(0.0, (sum, t) => sum + t.amount);

    // This month's expenses booked against this budget
    final spentThisMonth = transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.allocationBudgetId == allocation.id &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    return SavingBudgetStatus(
      id: allocation.id,
      name: allocation.name,
      targetAmount: allocation.targetAmount,
      monthlyAllocation: allocation.monthlyAllocation,
      totalAllocated: allocation.totalAllocated - totalSpent, 
      spentThisMonth: spentThisMonth,
      allocatedThisMonth: 0,
    );
  }).toList();
}

class _CategoryStats {
  double totalSpent = 0.0;
  double unplannedSpent = 0.0;
}

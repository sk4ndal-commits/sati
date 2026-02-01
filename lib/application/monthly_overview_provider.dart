import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'budget_overview_provider.dart';

part 'monthly_overview_provider.g.dart';

class MonthlyOverviewData {
  final double totalIncome;
  final double totalExpenses;
  final double totalBudgeted;
  final List<CategoryBreakdown> categoryBreakdown;
  final int month;
  final int year;

  MonthlyOverviewData({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalBudgeted,
    required this.categoryBreakdown,
    required this.month,
    required this.year,
  });

  double get savings => totalIncome - totalExpenses;
  double get remainingBudget => totalBudgeted - totalExpenses;
}

class CategoryBreakdown {
  final String categoryId;
  final double amount;
  final double percentage; // relative to total expenses

  CategoryBreakdown({
    required this.categoryId,
    required this.amount,
    required this.percentage,
  });
}

@riverpod
Future<MonthlyOverviewData> monthlyOverview(Ref ref) async {
  final transactions = await ref.watch(transactionControllerProvider.future);
  final budgetOverview = await ref.watch(budgetOverviewProvider.future);

  final now = DateTime.now();
  final currentMonthTransactions = transactions.where((t) =>
      t.date.month == now.month && t.date.year == now.year).toList();

  double totalIncome = 0;
  double totalExpenses = 0;
  final expenseByCategory = <String, double>{};

  for (final t in currentMonthTransactions) {
    if (t.type == TransactionType.income) {
      totalIncome += t.amount;
    } else {
      totalExpenses += t.amount;
      expenseByCategory[t.categoryId] = (expenseByCategory[t.categoryId] ?? 0) + t.amount;
    }
  }

  double totalBudgeted = budgetOverview.fold(0, (sum, b) => sum + b.budgetAmount);

  final breakdown = expenseByCategory.entries.map((e) {
    return CategoryBreakdown(
      categoryId: e.key,
      amount: e.value,
      percentage: totalExpenses > 0 ? e.value / totalExpenses : 0,
    );
  }).toList();

  // Sort by amount descending
  breakdown.sort((a, b) => b.amount.compareTo(a.amount));

  return MonthlyOverviewData(
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    totalBudgeted: totalBudgeted,
    categoryBreakdown: breakdown,
    month: now.month,
    year: now.year,
  );
}

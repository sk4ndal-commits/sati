import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';

part 'trends_provider.g.dart';

class MonthlySpending {
  final DateTime month;
  final double totalExpenses;
  final double totalIncome;
  final Map<String, double> categoryExpenses;
  final Map<String, double> categoryIncome;

  MonthlySpending({
    required this.month,
    required this.totalExpenses,
    required this.totalIncome,
    required this.categoryExpenses,
    required this.categoryIncome,
  });
}

class WeeklySpendingIntent {
  final DateTime weekStart;
  final double plannedAmount;
  final double unplannedAmount;

  WeeklySpendingIntent({
    required this.weekStart,
    required this.plannedAmount,
    required this.unplannedAmount,
  });

  double get totalAmount => plannedAmount + unplannedAmount;
}

@riverpod
Future<List<WeeklySpendingIntent>> weeklyTrendsData(Ref ref) async {
  final transactionsFuture = ref.watch(transactionControllerProvider.future);
  final transactions = await transactionsFuture;

  final now = DateTime.now();
  // Find start of current week (Monday)
  final currentWeekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

  // Last 12 weeks
  final weeks = List.generate(12, (i) {
    return currentWeekStart.subtract(Duration(days: (11 - i) * 7));
  });

  final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();

  return weeks.map((weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekExpenses = expenses.where((t) =>
        (t.date.isAtSameMomentAs(weekStart) || t.date.isAfter(weekStart)) &&
        t.date.isBefore(weekEnd)).toList();

    double planned = 0;
    double unplanned = 0;

    for (final t in weekExpenses) {
      // If planned is null, we treat it gracefully (e.g., as planned or just ignore depending on preference, 
      // but requirements say "Uses intent prompt data only" and "Missing intent data handled gracefully")
      // Usually, if planned is null, it was below threshold and wasn't prompted.
      if (t.planned == true) {
        planned += t.amount;
      } else if (t.planned == false) {
        unplanned += t.amount;
      }
      // If t.planned is null, it's neither explicitly planned nor unplanned via intent prompt.
    }

    return WeeklySpendingIntent(
      weekStart: weekStart,
      plannedAmount: planned,
      unplannedAmount: unplanned,
    );
  }).toList();
}

@riverpod
Future<List<MonthlySpending>> trendsData(Ref ref) async {
  final transactionsFuture = ref.watch(transactionControllerProvider.future);
  final transactions = await transactionsFuture;

  final now = DateTime.now();
  // Fixed time window: last 6 months including current
  final months = List.generate(6, (i) {
    return DateTime(now.year, now.month - (5 - i), 1);
  });

  return months.map((month) {
    final monthTransactions = transactions.where((t) =>
        t.date.month == month.month && t.date.year == month.year).toList();

    double totalExpenses = 0;
    double totalIncome = 0;
    final categoryExpenses = <String, double>{};
    final categoryIncome = <String, double>{};

    for (final t in monthTransactions) {
      if (t.type == TransactionType.expense) {
        totalExpenses += t.amount;
        categoryExpenses[t.categoryId] = (categoryExpenses[t.categoryId] ?? 0) + t.amount;
      } else {
        totalIncome += t.amount;
        categoryIncome[t.categoryId] = (categoryIncome[t.categoryId] ?? 0) + t.amount;
      }
    }

    return MonthlySpending(
      month: month,
      totalExpenses: totalExpenses,
      totalIncome: totalIncome,
      categoryExpenses: categoryExpenses,
      categoryIncome: categoryIncome,
    );
  }).toList();
}

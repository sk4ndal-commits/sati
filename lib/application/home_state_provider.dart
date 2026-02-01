import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'budget_overview_provider.dart';

part 'home_state_provider.g.dart';

class HomeState {
  final double remainingTotalBudget;
  final List<AttentionSignal> signals;

  HomeState({
    required this.remainingTotalBudget,
    required this.signals,
  });
}

enum SignalType {
  budgetNearLimit,
  highUnplannedSpend,
}

class AttentionSignal {
  final SignalType type;
  final String categoryId; // Optional, for budget near limit
  final double? amount; // Optional

  AttentionSignal({
    required this.type,
    this.categoryId = '',
    this.amount,
  });
}

@riverpod
Future<HomeState> homeState(Ref ref) async {
  final budgetOverviewAsync = await ref.watch(budgetOverviewProvider.future);
  final transactions = await ref.watch(transactionControllerProvider.future);

  // 1. Calculate remaining total budget
  double totalRemaining = 0;
  for (final status in budgetOverviewAsync) {
    totalRemaining += status.remainingAmount;
  }

  final signals = <AttentionSignal>[];

  // 2. Attention signals
  // Signal: Budget near limit (>= 80%)
  // We only show the most critical one or a few? Requirement says max 1-2.
  for (final status in budgetOverviewAsync) {
    if (status.percentUsed >= 0.8) {
      signals.add(AttentionSignal(
        type: SignalType.budgetNearLimit,
        categoryId: status.categoryId,
      ));
    }
  }

  // Signal: High unplanned spend this week
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfRange = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

  final weeklyTransactions = transactions.where((t) =>
      t.type == TransactionType.expense &&
      t.date.isAfter(startOfRange.subtract(const Duration(seconds: 1)))).toList();

  final totalWeeklySpend = weeklyTransactions.fold(0.0, (sum, t) => sum + t.amount);
  final unplannedWeeklySpend = weeklyTransactions
      .where((t) => t.planned == false)
      .fold(0.0, (sum, t) => sum + t.amount);

  if (totalWeeklySpend > 0 && (unplannedWeeklySpend / totalWeeklySpend) > 0.3) {
    signals.add(AttentionSignal(
      type: SignalType.highUnplannedSpend,
      amount: unplannedWeeklySpend,
    ));
  }

  // Limit to 2 signals as per requirement
  final limitedSignals = signals.take(2).toList();

  return HomeState(
    remainingTotalBudget: totalRemaining,
    signals: limitedSignals,
  );
}

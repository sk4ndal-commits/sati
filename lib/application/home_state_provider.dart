import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'budget_overview_provider.dart';
import 'settings_controller.dart';
import 'allocation_budget_controller.dart';

part 'home_state_provider.g.dart';

class HomeState {
  final double moneyLeft;
  final double moneyAllocated;
  final List<CategoryBudgetStatus> categorySnapshots;
  final List<AttentionSignal> signals;
  final bool isNewMonthTransition;

  HomeState({
    required this.moneyLeft,
    required this.moneyAllocated,
    required this.categorySnapshots,
    required this.signals,
    this.isNewMonthTransition = false,
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
  final settingsAsync = await ref.watch(settingsControllerProvider.future);
  final allocations = await ref.watch(allocationBudgetControllerProvider.future);

  // 1. Check for month transition
  bool isNewMonthTransition = false;
  final now = DateTime.now();
  if (settingsAsync.lastSeenMonth != null && settingsAsync.lastSeenYear != null) {
    if (settingsAsync.lastSeenMonth != now.month || settingsAsync.lastSeenYear != now.year) {
      isNewMonthTransition = true;
    }
  } else {
    // If it's the very first time, we don't show the "New month" message
    // but we record the current month.
    ref.read(settingsControllerProvider.notifier).updateLastSeenMonth(now.month, now.year);
  }

  // 2. Calculate Money Left = income - expenses (current month)
  final currentMonthTransactions = transactions.where((t) =>
      t.date.month == now.month &&
      t.date.year == now.year).toList();

  final totalIncome = currentMonthTransactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
  
  final totalExpenses = currentMonthTransactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  final moneyLeft = totalIncome - totalExpenses;

  // 3. Calculate Money Allocated for this month
  // Since totalAllocated is cumulative, we need a way to track "this month's" allocation 
  // if we want to show it on Home. The prompt says "Davon zugewiesen: 300 €" 
  // which likely refers to the sum of 'monthlyAllocation' planned for this month 
  // or actual allocations made this month.
  // Requirement: "Home: Optional secondary line below “Money Left”: „Davon zugewiesen: 300 €“"
  // For simplicity and following the requirement "Allocation aggregation logic (monthly)", 
  // I'll sum the 'monthlyAllocation' of all allocation budgets as the "planned/assigned" amount.
  final moneyAllocated = allocations.fold(0.0, (sum, b) => sum + (b.monthlyAllocation ?? 0.0));

  // 4. Category snapshot (Limit to 3-5)
  final categorySnapshots = budgetOverviewAsync.take(5).toList();

  final signals = <AttentionSignal>[];

  // 4. Attention signals
  // Signal: Budget near limit (>= 80%)
  // Priority 1: First category that is >= 80%
  for (final status in budgetOverviewAsync) {
    if (status.percentUsed >= 0.8) {
      signals.add(AttentionSignal(
        type: SignalType.budgetNearLimit,
        categoryId: status.categoryId,
      ));
      break; // Only one signal max, priority order
    }
  }

  // Priority 2: High unplanned spend this week (only if no budget signal)
  if (signals.isEmpty) {
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
  }

  return HomeState(
    moneyLeft: moneyLeft,
    moneyAllocated: moneyAllocated,
    categorySnapshots: categorySnapshots,
    signals: signals,
    isNewMonthTransition: isNewMonthTransition,
  );
}

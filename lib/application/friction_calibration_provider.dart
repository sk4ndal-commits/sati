import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';

part 'friction_calibration_provider.g.dart';

class FrictionState {
  final bool softenPrompt;
  final bool shouldShow;

  FrictionState({
    required this.softenPrompt,
    required this.shouldShow,
  });
}

@riverpod
Future<FrictionState> frictionCalibration(
  Ref ref, {
  required String categoryId,
}) async {
  final transactions = await ref.watch(transactionControllerProvider.future);

  // 1. Logic for softening the prompt
  // Requirement: same category has >70% "planned" over last X entries (let's use X=10)
  final categoryExpenses = transactions
      .where((t) => t.type == TransactionType.expense && t.categoryId == categoryId)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  final lastX = categoryExpenses.take(10).toList();
  bool softenPrompt = false;
  if (lastX.length >= 5) { // Minimum entries to consider it a pattern
    final plannedCount = lastX.where((t) => t.planned == true).length;
    if (plannedCount / lastX.length > 0.7) {
      softenPrompt = true;
    }
  }

  // 2. Logic for reducing frequency if user skips reflection repeatedly
  // Requirement: If user skips reflection repeatedly, prompt frequency temporarily reduces
  // A "skip" is defined as a transaction where the Intent Prompt was shown but neither planned nor feeling was set.
  // Note: We don't have a strict "shown" flag in DB, but we can assume it was shown if amount > threshold.
  // However, threshold is in Settings. For simplicity, we look at all expenses.
  final lastExpenses = transactions
      .where((t) => t.type == TransactionType.expense)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  final last10Expenses = lastExpenses.take(10).toList();
  bool shouldShow = true;
  if (last10Expenses.length >= 5) {
    // Check how many of the last entries have reflection data (planned or feeling)
    // We only count it as a "skip" if BOTH are null.
    final skipCount = last10Expenses.where((t) => t.planned == null && t.feeling == null).length;
    
    // If skipped > 80% of the time, reduce frequency (e.g., only show 50% of the time)
    // To make it deterministic but feel "adaptive", we can use the timestamp or ID.
    if (skipCount / last10Expenses.length > 0.8) {
      // Reduce frequency: only show if the current minute is even, for example.
      // Or use the count of total transactions.
      if (transactions.length % 2 != 0) {
        shouldShow = false;
      }
    }
  }

  return FrictionState(
    softenPrompt: softenPrompt,
    shouldShow: shouldShow,
  );
}

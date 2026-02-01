import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/income_source_entity.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';
import 'income_source_controller.dart';

part 'income_source_stats_provider.g.dart';

class IncomeSourceStats {
  final IncomeSourceEntity source;
  final double actualAmount;
  final double? expectedAmount;

  IncomeSourceStats({
    required this.source,
    required this.actualAmount,
    this.expectedAmount,
  });

  double get difference => (expectedAmount ?? 0) - actualAmount;
  bool get isUnderExpected => expectedAmount != null && actualAmount < expectedAmount!;
}

@riverpod
Future<List<IncomeSourceStats>> incomeSourceStats(Ref ref) async {
  final transactions = await ref.watch(transactionControllerProvider.future);
  final sources = await ref.watch(incomeSourceControllerProvider.future);

  // For MVP, we filter transactions by current month.
  final now = DateTime.now();
  final currentMonthTransactions = transactions.where((t) =>
      t.type == TransactionType.income &&
      t.date.month == now.month &&
      t.date.year == now.year).toList();

  return sources.map((source) {
    final actual = currentMonthTransactions
        .where((t) => t.incomeSourceId == source.id)
        .fold(0.0, (sum, t) => sum + t.amount);

    return IncomeSourceStats(
      source: source,
      actualAmount: actual,
      expectedAmount: source.expectedAmount,
    );
  }).toList();
}

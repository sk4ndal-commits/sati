import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/transaction_entity.dart';
import 'transaction_controller.dart';

part 'weekly_review_provider.g.dart';

class WeeklyReviewData {
  final List<CategorySpend> topCategories;
  final double totalUnplannedSpend;
  final String suggestionKey;
  final String? suggestionParam;
  final Map<int, int> feelingDistribution; // feeling (1-5) -> count
  final String intentSummaryKey;

  WeeklyReviewData({
    required this.topCategories,
    required this.totalUnplannedSpend,
    required this.suggestionKey,
    this.suggestionParam,
    required this.feelingDistribution,
    required this.intentSummaryKey,
  });
}

class CategorySpend {
  final String categoryId;
  final double amount;

  CategorySpend(this.categoryId, this.amount);
}

@riverpod
Future<WeeklyReviewData> weeklyReview(Ref ref) async {
  final transactions = await ref.watch(transactionControllerProvider.future);

  final now = DateTime.now();
  // Find the start of the current week (Monday)
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfRange = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

  final weeklyTransactions = transactions.where((t) => 
    t.type == TransactionType.expense && 
    t.date.isAfter(startOfRange.subtract(const Duration(seconds: 1)))
  ).toList();

  // 1. Top 3 categories
  final spendByCategory = <String, double>{};
  for (final t in weeklyTransactions) {
    spendByCategory[t.categoryId] = (spendByCategory[t.categoryId] ?? 0.0) + t.amount;
  }

  final sortedCategories = spendByCategory.entries
      .map((e) => CategorySpend(e.key, e.value))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  final top3 = sortedCategories.take(3).toList();

  // 2. Total unplanned spend & Intent metadata
  final unplannedTransactions = weeklyTransactions.where((t) => t.planned == false).toList();
  final totalUnplanned = unplannedTransactions.fold(0.0, (sum, t) => sum + t.amount);

  final feelingDistribution = <int, int>{};
  double totalFeeling = 0;
  int feelingCount = 0;

  for (final t in unplannedTransactions) {
    if (t.feeling != null) {
      feelingDistribution[t.feeling!] = (feelingDistribution[t.feeling!] ?? 0) + 1;
      totalFeeling += t.feeling!;
      feelingCount++;
    }
  }

  String intentSummaryKey = 'noUnplannedData';
  if (feelingCount > 0) {
    final avgFeeling = totalFeeling / feelingCount;
    if (avgFeeling < 2.5) {
      intentSummaryKey = 'avgFeelingNegative';
    } else if (avgFeeling <= 3.5) {
      intentSummaryKey = 'avgFeelingNeutral';
    } else {
      intentSummaryKey = 'avgFeelingPositive';
    }
  }

  // 3. Rule-based suggestion
  String suggestionKey = 'suggestionGeneric';
  String? suggestionParam;

  if (totalUnplanned > 0 && totalUnplanned > (spendByCategory.values.fold(0.0, (s, a) => s + a) * 0.3)) {
    suggestionKey = 'suggestionHighUnplanned';
  } else if (top3.isNotEmpty && top3.first.amount > 0) {
    suggestionKey = 'suggestionReduceTop';
    suggestionParam = top3.first.categoryId;
  }

  return WeeklyReviewData(
    topCategories: top3,
    totalUnplannedSpend: totalUnplanned,
    suggestionKey: suggestionKey,
    suggestionParam: suggestionParam,
    feelingDistribution: feelingDistribution,
    intentSummaryKey: intentSummaryKey,
  );
}

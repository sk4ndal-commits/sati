import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/weekly_review_provider.dart';
import '../../l10n/app_localizations.dart';
import 'budget_overview_screen.dart';

class WeeklyReviewScreen extends ConsumerWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reviewAsync = ref.watch(weeklyReviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weeklyReview),
      ),
      body: reviewAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.weeklyReviewDescription,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.topCategories),
            ...data.topCategories.map((cat) => ListTile(
                  title: Text(_getCategoryName(cat.categoryId, l10n)),
                  trailing: Text('${cat.amount.toStringAsFixed(2)} €'),
                )),
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.unplannedSpend),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.unplannedSpend),
                    Text(
                      '${data.totalUnplannedSpend.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: data.totalUnplannedSpend > 0 ? Colors.orange : null,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (data.totalUnplannedSpend > 0) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.feelingDistribution,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      _FeelingBarChart(distribution: data.feelingDistribution),
                      const SizedBox(height: 16),
                      Text(
                        _getIntentSummaryText(data.intentSummaryKey, l10n),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.suggestions),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _getSuggestionText(data, l10n),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _ClosureActions(l10n: l10n),
            const SizedBox(height: 16),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _getCategoryName(String id, AppLocalizations l10n) {
    switch (id) {
      case 'food': return l10n.categoryFood;
      case 'transport': return l10n.categoryTransport;
      case 'leisure': return l10n.categoryLeisure;
      case 'housing': return l10n.categoryHousing;
      case 'salary': return l10n.categorySalary;
      default: return l10n.categoryOther;
    }
  }

  String _getSuggestionText(WeeklyReviewData data, AppLocalizations l10n) {
    switch (data.suggestionKey) {
      case 'suggestionHighUnplanned':
        return l10n.suggestionHighUnplanned;
      case 'suggestionReduceTop':
        final categoryName = _getCategoryName(data.suggestionParam ?? 'other', l10n);
        return l10n.suggestionReduceTop(categoryName);
      default:
        return l10n.suggestionGeneric;
    }
  }

  String _getIntentSummaryText(String key, AppLocalizations l10n) {
    switch (key) {
      case 'avgFeelingNegative':
        return l10n.avgFeelingNegative;
      case 'avgFeelingNeutral':
        return l10n.avgFeelingNeutral;
      case 'avgFeelingPositive':
        return l10n.avgFeelingPositive;
      default:
        return l10n.noUnplannedData;
    }
  }
}

class _FeelingBarChart extends StatelessWidget {
  final Map<int, int> distribution;

  const _FeelingBarChart({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final maxCount = distribution.values.fold(0, (max, count) => count > max ? count : max);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        final feeling = index + 1;
        final count = distribution[feeling] ?? 0;
        final heightFactor = maxCount > 0 ? count / maxCount : 0.0;

        return Column(
          children: [
            Container(
              width: 30,
              height: 60 * heightFactor,
              decoration: BoxDecoration(
                color: _getFeelingColor(feeling),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Text(feeling.toString()),
          ],
        );
      }),
    );
  }

  Color _getFeelingColor(int feeling) {
    switch (feeling) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.yellow.shade300;
      case 4:
        return Colors.lightGreen.shade300;
      case 5:
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }
}

class _ClosureActions extends StatelessWidget {
  final AppLocalizations l10n;

  const _ClosureActions({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BudgetOverviewScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(l10n.adjustBudget),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(
            l10n.nothingToChange,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/monthly_overview_provider.dart';
import '../../l10n/app_localizations.dart';

class MonthlyOverviewScreen extends ConsumerWidget {
  const MonthlyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final overviewAsync = ref.watch(monthlyOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monthlyOverview),
      ),
      body: overviewAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SummaryCard(data: data),
            const SizedBox(height: 24),
            _AllocationSection(data: data),
            const SizedBox(height: 24),
            _CategoryBreakdownSection(breakdown: data.categoryBreakdown),
            const SizedBox(height: 24),
            _BudgetStatusCard(data: data),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final MonthlyOverviewData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.incomeVsExpenses, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _ValueRow(
              label: l10n.income,
              value: data.totalIncome,
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 8),
            _ValueRow(
              label: l10n.expense,
              value: data.totalExpenses,
              color: const Color(0xFF965F5F),
            ),
            const Divider(height: 24),
            _ValueRow(
              label: l10n.savings,
              value: data.savings,
              valueStyle: theme.textTheme.titleLarge?.copyWith(
                color: data.savings >= 0 ? const Color(0xFF2E7D32) : const Color(0xFF965F5F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdownSection extends StatelessWidget {
  final List<CategoryBreakdown> breakdown;

  const _CategoryBreakdownSection({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l10n.categoryBreakdown, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        if (breakdown.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No expenses this month.'),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: breakdown.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = breakdown[index];
                return ListTile(
                  title: Text(_getCategoryName(item.categoryId, l10n)),
                  subtitle: Text(l10n.ofTotal((item.percentage * 100).toInt())),
                  trailing: Text(
                    '${item.amount.toStringAsFixed(2)} €',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
      ],
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
}

class _AllocationSection extends StatelessWidget {
  final MonthlyOverviewData data;

  const _AllocationSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l10n.allocationBudgets, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        if (data.allocations.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No saving goals defined yet.'),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _ValueRow(
                    label: l10n.monthlyAllocation,
                    value: data.totalAllocatedThisMonth,
                    color: theme.colorScheme.primary,
                  ),
                  const Divider(height: 24),
                  ...data.allocations.map((allocation) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(allocation.name),
                            if (allocation.targetAmount != null)
                              Text(
                                '${allocation.totalAllocated.toStringAsFixed(0)} / ${allocation.targetAmount!.toStringAsFixed(0)} €',
                                style: theme.textTheme.bodySmall,
                              )
                            else
                              Text('${allocation.totalAllocated.toStringAsFixed(0)} €'),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _BudgetStatusCard extends StatelessWidget {
  final MonthlyOverviewData data;

  const _BudgetStatusCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.budgetStatus, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _ValueRow(label: l10n.totalBudgeted, value: data.totalBudgeted),
            const SizedBox(height: 8),
            _ValueRow(label: l10n.expense, value: data.totalExpenses),
            const Divider(height: 24),
            _ValueRow(
              label: l10n.remaining,
              value: data.remainingBudget,
              valueStyle: theme.textTheme.titleLarge?.copyWith(
                color: data.remainingBudget >= 0 ? theme.colorScheme.primary : const Color(0xFF965F5F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;
  final TextStyle? valueStyle;

  const _ValueRow({
    required this.label,
    required this.value,
    this.color,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '${value.toStringAsFixed(2)} €',
          style: valueStyle ?? TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

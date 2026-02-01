import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/trends_provider.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/simple_charts.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  ConsumerState<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends ConsumerState<TrendsScreen> {
  String? _selectedCategoryId;
  bool _showIncomeCategories = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final trendsDataAsync = ref.watch(trendsDataProvider);
    final weeklyTrendsAsync = ref.watch(weeklyTrendsDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trends),
        automaticallyImplyLeading: false,
      ),
      body: trendsDataAsync.when(
        data: (data) {
          if (data.every((m) => m.totalExpenses == 0 && m.totalIncome == 0)) {
            return Center(
              child: Text(l10n.noTrendData),
            );
          }

          final allCategories = _showIncomeCategories
              ? data.expand((m) => m.categoryIncome.keys).toSet().toList()
              : data.expand((m) => m.categoryExpenses.keys).toSet().toList();
          
          if (_selectedCategoryId == null && allCategories.isNotEmpty) {
            _selectedCategoryId = allCategories.first;
          } else if (_selectedCategoryId != null && !allCategories.contains(_selectedCategoryId) && allCategories.isNotEmpty) {
            _selectedCategoryId = allCategories.first;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  context,
                  l10n.incomeVsExpensesTrend,
                  l10n.incomeVsExpensesTrendDescription,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ComparisonBarChart(
                      values1: data.map((m) => m.totalIncome).toList(),
                      values2: data.map((m) => m.totalExpenses).toList(),
                      labels: data.map((m) => m.month).toList(),
                      label1: l10n.income,
                      label2: l10n.expense,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  context,
                  l10n.plannedVsUnplanned,
                  l10n.plannedVsUnplannedDescription,
                ),
                const SizedBox(height: 16),
                weeklyTrendsAsync.when(
                  data: (weeklyData) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StackedBarChart(
                        values1: weeklyData.map((w) => w.plannedAmount).toList(),
                        values2: weeklyData.map((w) => w.unplannedAmount).toList(),
                        labels: weeklyData.map((w) => w.weekStart).toList(),
                        label1: l10n.planned,
                        label2: l10n.unplanned,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  context,
                  l10n.categoryTrend,
                  l10n.categoryTrendDescription,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(l10n.expense),
                      selected: !_showIncomeCategories,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _showIncomeCategories = false;
                            _selectedCategoryId = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(l10n.income),
                      selected: _showIncomeCategories,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _showIncomeCategories = true;
                            _selectedCategoryId = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (allCategories.isNotEmpty) ...[
                  DropdownButton<String>(
                    value: _selectedCategoryId,
                    isExpanded: true,
                    items: allCategories.map((id) {
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(_getCategoryName(id, l10n)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SimpleLineChart(
                        values: data.map((m) {
                          final map = _showIncomeCategories ? m.categoryIncome : m.categoryExpenses;
                          return map[_selectedCategoryId] ?? 0.0;
                        }).toList(),
                        labels: data.map((m) => m.month).toList(),
                        lineColor: _showIncomeCategories ? const Color(0xFF2E7D32) : const Color(0xFF6B8E8E),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  String _getCategoryName(String id, AppLocalizations l10n) {
    switch (id) {
      case 'food':
        return l10n.categoryFood;
      case 'transport':
        return l10n.categoryTransport;
      case 'leisure':
        return l10n.categoryLeisure;
      case 'housing':
        return l10n.categoryHousing;
      case 'salary':
        return l10n.categorySalary;
      default:
        return l10n.categoryOther;
    }
  }
}

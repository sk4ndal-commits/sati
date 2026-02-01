import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/budget_controller.dart';
import '../../application/budget_overview_provider.dart';
import '../../l10n/app_localizations.dart';

class BudgetOverviewScreen extends ConsumerWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetOverviewAsync = ref.watch(budgetOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
      ),
      body: budgetOverviewAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(child: Text(l10n.noBudgets));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final status = budgets[index];
              return _BudgetCard(status: status);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref, [CategoryBudgetStatus? existing]) {
    _showAddBudgetDialogStatic(context, ref, existing);
  }

  static void _showAddBudgetDialogStatic(BuildContext context, WidgetRef ref, [CategoryBudgetStatus? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController(
      text: existing?.budgetAmount.toString() ?? '',
    );
    String categoryId = existing?.categoryId ?? 'food';
    bool rollover = existing?.rollover ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existing == null ? l10n.addBudget : l10n.editBudget),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (existing == null)
                DropdownButtonFormField<String>(
                  initialValue: categoryId,
                  decoration: InputDecoration(labelText: l10n.category),
                  items: [
                    DropdownMenuItem(value: 'food', child: Text(l10n.categoryFood)),
                    DropdownMenuItem(value: 'transport', child: Text(l10n.categoryTransport)),
                    DropdownMenuItem(value: 'leisure', child: Text(l10n.categoryLeisure)),
                    DropdownMenuItem(value: 'housing', child: Text(l10n.categoryHousing)),
                    DropdownMenuItem(value: 'other', child: Text(l10n.categoryOther)),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => categoryId = val);
                  },
                ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: l10n.amount),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              SwitchListTile(
                title: Text(l10n.rollover),
                value: rollover,
                onChanged: (val) => setState(() => rollover = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null) {
                  ref.read(budgetControllerProvider.notifier).setBudget(
                        categoryId: categoryId,
                        amount: amount,
                        rollover: rollover,
                      );
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  final CategoryBudgetStatus status;

  const _BudgetCard({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoryName = _getCategoryName(status.categoryId, l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(categoryName, style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => BudgetOverviewScreen._showAddBudgetDialogStatic(context, ref, status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: status.percentUsed.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              color: status.percentUsed > 1.0 ? Colors.red : Colors.teal,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.spent}: ${status.spentAmount.toStringAsFixed(2)} €'),
                Text('${l10n.remaining}: ${status.remainingAmount.toStringAsFixed(2)} €'),
              ],
            ),
            Text('${l10n.expected}: ${status.budgetAmount.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
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
}

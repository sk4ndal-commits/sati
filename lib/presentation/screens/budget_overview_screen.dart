import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/budget_controller.dart';
import '../../application/budget_overview_provider.dart';
import '../../application/allocation_budget_controller.dart';
import '../../domain/entities/allocation_budget_entity.dart';
import '../../l10n/app_localizations.dart';

class BudgetOverviewScreen extends ConsumerWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetOverviewAsync = ref.watch(budgetOverviewProvider);
    final allocationBudgetsAsync = ref.watch(allocationBudgetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, l10n.expenses),
            budgetOverviewAsync.when(
              data: (budgets) {
                if (budgets.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text(l10n.noBudgets)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 24),
            _buildSectionHeader(context, l10n.allocationBudgets),
            allocationBudgetsAsync.when(
              data: (allocations) {
                if (allocations.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text(l10n.noAllocations)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: allocations.length,
                  itemBuilder: (context, index) {
                    final allocation = allocations[index];
                    return _AllocationCard(allocation: allocation);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'budget_fab',
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text(l10n.addBudget),
              onTap: () {
                Navigator.pop(context);
                _showAddBudgetDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: Text(l10n.addAllocation),
              onTap: () {
                Navigator.pop(context);
                _showAddAllocationDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAllocationDialog(BuildContext context, WidgetRef ref, [AllocationBudgetEntity? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final targetController = TextEditingController(text: existing?.targetAmount?.toString() ?? '');
    final monthlyController = TextEditingController(text: existing?.monthlyAllocation?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? l10n.addAllocation : l10n.editAllocation),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.name),
              ),
              TextField(
                controller: targetController,
                decoration: InputDecoration(labelText: '${l10n.targetAmount} (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: monthlyController,
                decoration: InputDecoration(labelText: '${l10n.monthlyAllocation} (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                if (existing == null) {
                  ref.read(allocationBudgetControllerProvider.notifier).addAllocationBudget(
                        name: nameController.text,
                        targetAmount: double.tryParse(targetController.text),
                        monthlyAllocation: double.tryParse(monthlyController.text),
                      );
                } else {
                  ref.read(allocationBudgetControllerProvider.notifier).updateAllocationBudget(
                        existing.copyWith(
                          name: nameController.text,
                          targetAmount: double.tryParse(targetController.text),
                          monthlyAllocation: double.tryParse(monthlyController.text),
                        ),
                      );
                }
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
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
          content: SingleChildScrollView(
            child: Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName, style: Theme.of(context).textTheme.titleMedium),
                    if (status.unplannedPercent > 0.4)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline, size: 14, color: Color(0xFF8A7A5F)),
                            const SizedBox(width: 4),
                            Text(
                              status.unplannedPercent > 0.6
                                  ? l10n.frequentlyUnplanned
                                  : l10n.percentUnplanned((status.unplannedPercent * 100).toInt()),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF8A7A5F),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => BudgetOverviewScreen._showAddBudgetDialogStatic(context, ref, status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: status.percentUsed.clamp(0.0, 1.0)),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: status.percentUsed > 1.0 ? const Color(0xFF965F5F) : Theme.of(context).colorScheme.primary,
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${l10n.spent}: ${status.spentAmount.toStringAsFixed(2)} €',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.remaining}: ${status.remainingAmount.toStringAsFixed(2)} €',
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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

class _AllocationCard extends ConsumerWidget {
  final AllocationBudgetEntity allocation;

  const _AllocationCard({required this.allocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(allocation.name, style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: () => _showAllocateDialog(context, ref),
                      tooltip: l10n.allocate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditDialog(context, ref),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (allocation.targetAmount != null && allocation.targetAmount! > 0) ...[
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: allocation.progress.clamp(0.0, 1.0)),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.allocated}: ${allocation.totalAllocated.toStringAsFixed(2)} €',
                  style: theme.textTheme.bodyMedium,
                ),
                if (allocation.targetAmount != null)
                  Text(
                    '${l10n.targetAmount}: ${allocation.targetAmount!.toStringAsFixed(2)} €',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
              ],
            ),
            if (allocation.monthlyAllocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${l10n.monthlyAllocation}: ${allocation.monthlyAllocation!.toStringAsFixed(2)} €',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAllocateDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.allocate),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.amountToAllocate),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(allocationBudgetControllerProvider.notifier).allocateAmount(allocation.id, amount);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    // We can't call _showAddAllocationDialog directly because it's in BudgetOverviewScreen
    // but we are in _AllocationCard. Since BudgetOverviewScreen is the parent, 
    // it would be better to pass the callback or use a static method.
    // For now, let's use a simple way to find the screen's method if possible, 
    // or just reimplement the dialog here.
    // Better: Make it static in BudgetOverviewScreen.
    _BudgetOverviewScreenHelper.showAddAllocationDialog(context, ref, allocation);
  }
}

class _BudgetOverviewScreenHelper {
  static void showAddAllocationDialog(BuildContext context, WidgetRef ref, [AllocationBudgetEntity? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final targetController = TextEditingController(text: existing?.targetAmount?.toString() ?? '');
    final monthlyController = TextEditingController(text: existing?.monthlyAllocation?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? l10n.addAllocation : l10n.editAllocation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            TextField(
              controller: targetController,
              decoration: InputDecoration(labelText: '${l10n.targetAmount} (optional)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: monthlyController,
              decoration: InputDecoration(labelText: '${l10n.monthlyAllocation} (optional)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          if (existing != null)
            TextButton(
              onPressed: () {
                ref.read(allocationBudgetControllerProvider.notifier).deleteAllocationBudget(existing.id);
                Navigator.pop(context);
              },
              child: Text(MaterialLocalizations.of(context).deleteButtonTooltip, style: const TextStyle(color: Colors.red)),
            ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                if (existing == null) {
                  ref.read(allocationBudgetControllerProvider.notifier).addAllocationBudget(
                        name: nameController.text,
                        targetAmount: double.tryParse(targetController.text),
                        monthlyAllocation: double.tryParse(monthlyController.text),
                      );
                } else {
                  ref.read(allocationBudgetControllerProvider.notifier).updateAllocationBudget(
                        existing.copyWith(
                          name: nameController.text,
                          targetAmount: double.tryParse(targetController.text),
                          monthlyAllocation: double.tryParse(monthlyController.text),
                        ),
                      );
                }
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/income_source_controller.dart';
import '../../application/income_source_stats_provider.dart';
import '../../l10n/app_localizations.dart';

class IncomeSourcesScreen extends ConsumerWidget {
  const IncomeSourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sourcesAsync = ref.watch(incomeSourceControllerProvider);
    final statsAsync = ref.watch(incomeSourceStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.incomeSources),
      ),
      body: sourcesAsync.when(
        data: (sources) {
          if (sources.isEmpty) {
            return Center(child: Text(l10n.noIncomeSources));
          }
          return ListView.builder(
            itemCount: sources.length,
            itemBuilder: (context, index) {
              final source = sources[index];
              final stats = statsAsync.value?.firstWhere((s) => s.source.id == source.id);
              
              return ListTile(
                title: Text(source.name),
                subtitle: Text(
                  '${l10n.actual}: ${stats?.actualAmount.toStringAsFixed(2) ?? "0.00"} € / '
                  '${l10n.expected}: ${source.expectedAmount?.toStringAsFixed(2) ?? "-"} €',
                ),
                trailing: stats?.isUnderExpected == true
                    ? const Icon(Icons.info_outline, color: Color(0xFF8A7A5F))
                    : null,
                onLongPress: () {
                   ref.read(incomeSourceControllerProvider.notifier).deleteIncomeSource(source.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'income_source_fab',
        onPressed: () => _showAddSourceDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSourceDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String? cadence = 'monthly';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addIncomeSource),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.sourceName),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: l10n.expectedAmount),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              DropdownButtonFormField<String>(
                initialValue: cadence,
                items: [
                  DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                  DropdownMenuItem(value: 'weekly', child: Text(l10n.weekly)),
                ],
                onChanged: (val) => cadence = val,
                decoration: InputDecoration(labelText: l10n.cadence),
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
              final name = nameController.text;
              final amount = double.tryParse(amountController.text);
              if (name.isNotEmpty) {
                ref.read(incomeSourceControllerProvider.notifier).addIncomeSource(
                      name: name,
                      expectedAmount: amount,
                      cadence: cadence,
                    );
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

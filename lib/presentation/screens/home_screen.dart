import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../application/transaction_controller.dart';
import 'transaction_entry_screen.dart';
import 'income_sources_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.wallet),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const IncomeSourcesScreen()),
              );
            },
            tooltip: l10n.incomeSources,
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => transactions.isEmpty
            ? Center(child: Text(l10n.noTransactions))
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text('${transaction.amount.toStringAsFixed(2)} €'),
                  subtitle: Text(transaction.categoryId),
                  trailing: Text('${transaction.date.day}.${transaction.date.month}.${transaction.date.year}'),
                );
              },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TransactionEntryScreen(),
            ),
          );
        },
        tooltip: l10n.addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/home_state_provider.dart';
import '../../application/notification_service.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../l10n/app_localizations.dart';
import '../../application/transaction_controller.dart';
import 'transaction_entry_screen.dart';
import 'income_sources_screen.dart';
import 'budget_overview_screen.dart';
import 'settings_screen.dart';
import 'weekly_review_screen.dart';
import 'monthly_overview_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final notifier = ref.read(notificationServiceProvider.notifier);
    await notifier.init();
    await notifier.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeStateProvider);
    final transactionsAsync = ref.watch(transactionControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MonthlyOverviewScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BudgetOverviewScreen()),
              );
            },
            tooltip: l10n.budgets,
          ),
          IconButton(
            icon: const Icon(Icons.wallet),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const IncomeSourcesScreen()),
              );
            },
            tooltip: l10n.incomeSources,
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const WeeklyReviewScreen()),
              );
            },
            tooltip: l10n.weeklyReview,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: homeStateAsync.when(
        data: (homeState) => transactionsAsync.when(
          data: (transactions) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _StateCard(homeState: homeState),
              ),
              if (homeState.signals.isNotEmpty)
                SliverToBoxAdapter(
                  child: _AttentionSignals(signals: homeState.signals),
                ),
              if (transactions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(l10n.noTransactions)),
                )
              else
                _TransactionList(transactions: transactions),
            ],
          ),
          loading: () => const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Error: $err')),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.large(
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

class _StateCard extends StatelessWidget {
  final HomeState homeState;

  const _StateCard({required this.homeState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '${homeState.remainingTotalBudget.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.remainingTotalBudget,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              l10n.forThisMonth,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttentionSignals extends StatelessWidget {
  final List<AttentionSignal> signals;

  const _AttentionSignals({required this.signals});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: signals.map((signal) => _SignalItem(signal: signal)).toList(),
    );
  }
}

class _SignalItem extends StatelessWidget {
  final AttentionSignal signal;

  const _SignalItem({required this.signal});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String text = '';
    IconData icon = Icons.info_outline;
    Color color = Theme.of(context).colorScheme.secondary;

    switch (signal.type) {
      case SignalType.budgetNearLimit:
        text = l10n.budgetNearLimitSignal(_getCategoryName(signal.categoryId, l10n));
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case SignalType.highUnplannedSpend:
        text = l10n.highUnplannedWeekly(signal.amount?.toStringAsFixed(2) ?? '0');
        icon = Icons.bolt;
        color = Colors.deepOrange;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: color.withAlpha(25), // ~0.1 opacity
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
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

class _TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Group transactions by day
    final sorted = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    
    final grouped = <DateTime, List<TransactionEntity>>{};
    for (final t in sorted) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      grouped.putIfAbsent(date, () => []).add(t);
    }

    final dates = grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final date = dates[index];
          final dayTransactions = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  DateFormat.yMMMMd().format(date),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...dayTransactions.map((t) => _TransactionTile(transaction: t)),
            ],
          );
        },
        childCount: dates.length,
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isExpense = transaction.type == TransactionType.expense;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isExpense ? Colors.red[50] : Colors.green[50],
        child: Icon(
          isExpense ? Icons.remove : Icons.add,
          color: isExpense ? Colors.red : Colors.green,
        ),
      ),
      title: Text(
        '${transaction.amount.toStringAsFixed(2)} €',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text(_getCategoryName(transaction.categoryId, l10n)),
          if (transaction.planned != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: transaction.planned! ? Colors.blue[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transaction.planned! ? l10n.planned : l10n.unplanned,
                style: TextStyle(
                  fontSize: 10,
                  color: transaction.planned! ? Colors.blue[800] : Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: transaction.feeling != null
          ? _getFeelingIcon(transaction.feeling!)
          : null,
    );
  }

  Widget _getFeelingIcon(int feeling) {
    IconData icon;
    Color color;
    switch (feeling) {
      case 1: icon = Icons.sentiment_very_dissatisfied; color = Colors.red; break;
      case 2: icon = Icons.sentiment_dissatisfied; color = Colors.orange; break;
      case 3: icon = Icons.sentiment_neutral; color = Colors.amber; break;
      case 4: icon = Icons.sentiment_satisfied; color = Colors.lightGreen; break;
      case 5: icon = Icons.sentiment_very_satisfied; color = Colors.green; break;
      default: icon = Icons.sentiment_neutral; color = Colors.grey;
    }
    return Icon(icon, color: color, size: 20);
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

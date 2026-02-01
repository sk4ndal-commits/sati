import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/home_state_provider.dart';
import '../../application/notification_service.dart';
import '../../application/budget_overview_provider.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../l10n/app_localizations.dart';
import '../../application/settings_controller.dart';
import '../../application/transaction_controller.dart';
import 'transaction_entry_screen.dart';
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

  void _showNewMonthGreeting(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.newMonthGreeting),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Just dismiss
          },
        ),
      ),
    ).closed.then((_) {
      // Update last seen month after snackbar is closed (or dismissed)
      final now = DateTime.now();
      ref.read(settingsControllerProvider.notifier).updateLastSeenMonth(now.month, now.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeStateProvider);
    final transactionsAsync = ref.watch(transactionControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(homeStateProvider, (previous, next) {
      next.whenData((state) {
        if (state.isNewMonthTransition) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNewMonthGreeting(context, ref);
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.visibility_outlined),
            tooltip: l10n.reflect,
            onSelected: (value) {
              if (value == 'weekly') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WeeklyReviewScreen()),
                );
              } else if (value == 'monthly') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MonthlyOverviewScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'weekly',
                child: Text(l10n.weeklyReview),
              ),
              PopupMenuItem(
                value: 'monthly',
                child: Text(l10n.monthlyOverview),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BudgetOverviewScreen()),
              );
            },
            tooltip: l10n.budgets,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
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
                child: _MoneyLeftLayer(moneyLeft: homeState.moneyLeft),
              ),
              if (homeState.categorySnapshots.isNotEmpty)
                SliverToBoxAdapter(
                  child: _CategorySnapshotLayer(snapshots: homeState.categorySnapshots),
                ),
              if (homeState.signals.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _SignalItem(signal: homeState.signals.first),
                  ),
                ),
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

class _MoneyLeftLayer extends StatelessWidget {
  final double moneyLeft;

  const _MoneyLeftLayer({required this.moneyLeft});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        children: [
          Text(
            '${moneyLeft.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.moneyLeft,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategorySnapshotLayer extends StatelessWidget {
  final List<CategoryBudgetStatus> snapshots;

  const _CategorySnapshotLayer({required this.snapshots});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        ...snapshots.map((status) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: _CategorySnapshotItem(status: status),
            )),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BudgetOverviewScreen()),
            );
          },
          child: Text(l10n.viewAllBudgets),
        ),
      ],
    );
  }
}

class _CategorySnapshotItem extends StatelessWidget {
  final CategoryBudgetStatus status;

  const _CategorySnapshotItem({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getCategoryName(status.categoryId, l10n),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${status.spentAmount.toStringAsFixed(0)} / ${status.budgetAmount.toStringAsFixed(0)} €',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: status.percentUsed.clamp(0.0, 1.0),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
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
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Group transactions by day
    final sorted = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    final grouped = <DateTime, List<TransactionEntity>>{};
    // Ensure "Today" is always present in the map
    grouped[today] = [];

    for (final t in sorted) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      grouped.putIfAbsent(date, () => []).add(t);
    }

    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final date = dates[index];
          final dayTransactions = grouped[date]!;
          final isToday = date.isAtSameMomentAs(today);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  isToday ? l10n.today : DateFormat.yMMMMd().format(date),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (isToday && dayTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.noTransactionsToday,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                )
              else
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

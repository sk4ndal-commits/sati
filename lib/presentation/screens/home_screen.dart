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
import 'main_navigation_screen.dart';

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
        content: Text(
          l10n.newMonthGreeting,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Theme.of(context).colorScheme.primary,
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
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            l10n.appTitle,
            style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  letterSpacing: 0.5,
                ),
          ),
        ),
      ),
      body: homeStateAsync.when(
        data: (homeState) => transactionsAsync.when(
          data: (transactions) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _MoneyLeftLayer(
                  moneyLeft: homeState.moneyLeft,
                  moneyAllocated: homeState.moneyAllocated,
                ),
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
        heroTag: 'home_fab',
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
  final double moneyAllocated;

  const _MoneyLeftLayer({
    required this.moneyLeft,
    required this.moneyAllocated,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, bottom: 40.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Text(
            '${moneyLeft.toStringAsFixed(2)} €',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 56,
                  letterSpacing: -1.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.moneyLeft,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  letterSpacing: 0.5,
                ),
          ),
          if (moneyAllocated > 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.moneyAllocatedInfo('${moneyAllocated.toStringAsFixed(0)} €'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategorySnapshotLayer extends ConsumerWidget {
  final List<CategoryBudgetStatus> snapshots;

  const _CategorySnapshotLayer({required this.snapshots});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: snapshots
                .map((status) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _CategorySnapshotItem(status: status),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            ref.read(navigationIndexProvider.notifier).setIndex(1);
          },
          child: Text(
            l10n.viewAllBudgets,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${status.spentAmount.toStringAsFixed(0)} / ${status.budgetAmount.toStringAsFixed(0)} €',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            );
          },
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
        icon = Icons.info_outline;
        color = const Color(0xFF9E773B); // Desaturated/Neutral Gold/Ochre
        break;
      case SignalType.highUnplannedSpend:
        text = l10n.highUnplannedWeekly(signal.amount?.toStringAsFixed(2) ?? '0');
        icon = Icons.info_outline;
        color = const Color(0xFF8A7A5F); // Muted Taupe/Neutral
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
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                child: Text(
                  isToday ? l10n.today : DateFormat.yMMMMd().format(date),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              if (isToday && dayTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    l10n.noTransactionsToday,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
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

class _TransactionTile extends ConsumerWidget {
  final TransactionEntity transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isExpense = transaction.type == TransactionType.expense;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        onDismissed: (_) {
          ref.read(transactionControllerProvider.notifier).deleteTransaction(transaction.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.transactionDeleted),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: isExpense ? const Color(0xFFF2EDED) : const Color(0xFFEAF5EA),
            child: Icon(
              isExpense ? Icons.remove : Icons.add,
              size: 18,
              color: isExpense ? const Color(0xFF965F5F) : const Color(0xFF2E7D32),
            ),
          ),
          title: Text(
            '${transaction.amount.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          subtitle: Row(
            children: [
              Text(
                _getCategoryName(transaction.categoryId, l10n),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              if (transaction.planned != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: transaction.planned! ? const Color(0xFFDDE6ED) : const Color(0xFFEBE5C5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.planned! ? l10n.planned : l10n.unplanned,
                    style: TextStyle(
                      fontSize: 9,
                      color: transaction.planned! ? const Color(0xFF5D7A8C) : const Color(0xFF8A7A5F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          trailing: transaction.feeling != null
              ? _getFeelingIcon(transaction.feeling!)
              : null,
        ),
      ),
    );
  }

  Widget _getFeelingIcon(int feeling) {
    IconData icon;
    Color color;
    switch (feeling) {
      case 1: icon = Icons.sentiment_very_dissatisfied; color = const Color(0xFF965F5F); break;
      case 2: icon = Icons.sentiment_dissatisfied; color = const Color(0xFFB58D67); break;
      case 3: icon = Icons.sentiment_neutral; color = const Color(0xFFC4B680); break;
      case 4: icon = Icons.sentiment_satisfied; color = const Color(0xFF8BA670); break;
      case 5: icon = Icons.sentiment_very_satisfied; color = const Color(0xFF4D8D8D); break;
      default: icon = Icons.sentiment_neutral; color = const Color(0xFF9E9E9E);
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

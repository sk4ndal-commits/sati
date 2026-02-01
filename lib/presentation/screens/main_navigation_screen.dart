import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'budget_overview_screen.dart';
import 'trends_screen.dart';
import 'review_hub_screen.dart';
import 'settings_screen.dart';

part 'main_navigation_screen.g.dart';

@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomeScreen(),
          BudgetOverviewScreen(),
          TrendsScreen(),
          ReviewHubScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).setIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pie_chart_outline),
            activeIcon: const Icon(Icons.pie_chart),
            label: l10n.budgets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            activeIcon: const Icon(Icons.analytics),
            label: l10n.trends,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.visibility_outlined),
            activeIcon: const Icon(Icons.visibility),
            label: l10n.reflect,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

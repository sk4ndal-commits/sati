import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'budget_overview_provider.dart';
import 'notification_service.dart';
import '../l10n/app_localizations.dart';

part 'budget_threshold_service.g.dart';

@riverpod
class BudgetThresholdService extends _$BudgetThresholdService {
  // Track notified categories for the current month to avoid spam.
  // Format: "year-month-categoryId"
  final Set<String> _notifiedCategories = {};

  @override
  void build() {}

  Future<void> checkThresholds(AppLocalizations l10n) async {
    final notificationService = ref.read(notificationServiceProvider.notifier);
    final overview = await ref.read(budgetOverviewProvider.future);
    
    if (!ref.mounted) return;
    
    final now = DateTime.now();
    final monthKeyPrefix = "${now.year}-${now.month}";

    for (final status in overview) {
      if (status.percentUsed >= 0.8) {
        final key = "$monthKeyPrefix-${status.categoryId}";
        if (!_notifiedCategories.contains(key)) {
          final categoryName = _getCategoryName(status.categoryId, l10n);
          
          await notificationService.showNotification(
            id: status.categoryId.hashCode,
            title: l10n.budgetAlertTitle,
            body: l10n.budgetAlertBody(categoryName, (status.percentUsed * 100).toInt()),
          );
          
          _notifiedCategories.add(key);
        }
      }
    }
  }

  String _getCategoryName(String categoryId, AppLocalizations l10n) {
    switch (categoryId) {
      case 'food': return l10n.categoryFood;
      case 'transport': return l10n.categoryTransport;
      case 'leisure': return l10n.categoryLeisure;
      case 'housing': return l10n.categoryHousing;
      case 'salary': return l10n.categorySalary;
      default: return l10n.categoryOther;
    }
  }
}

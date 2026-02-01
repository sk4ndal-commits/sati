import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/budget_entity.dart';
import 'providers.dart';

part 'budget_controller.g.dart';

@riverpod
class BudgetController extends _$BudgetController {
  @override
  FutureOr<List<BudgetEntity>> build() async {
    final now = DateTime.now();
    return _fetchBudgets(now.month, now.year);
  }

  Future<List<BudgetEntity>> _fetchBudgets(int month, int year) async {
    final repository = ref.watch(budgetRepositoryProvider);
    return repository.getBudgets(month, year);
  }

  Future<void> setBudget({
    required String categoryId,
    required double amount,
    bool rollover = false,
  }) async {
    final now = DateTime.now();
    final repository = ref.read(budgetRepositoryProvider);
    
    // Check if budget for this category and month already exists
    final currentBudgets = await repository.getBudgets(now.month, now.year);
    final existingBudget = currentBudgets.cast<BudgetEntity?>().firstWhere(
      (b) => b?.categoryId == categoryId,
      orElse: () => null,
    );

    final budget = BudgetEntity(
      id: existingBudget?.id ?? const Uuid().v4(),
      categoryId: categoryId,
      amount: amount,
      rollover: rollover,
      month: now.month,
      year: now.year,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveBudget(budget);
      return _fetchBudgets(now.month, now.year);
    });
  }
}

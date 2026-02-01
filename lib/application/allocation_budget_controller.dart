import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/allocation_budget_entity.dart';
import 'providers.dart';

part 'allocation_budget_controller.g.dart';

@riverpod
class AllocationBudgetController extends _$AllocationBudgetController {
  @override
  FutureOr<List<AllocationBudgetEntity>> build() async {
    final repository = ref.watch(allocationBudgetRepositoryProvider);
    return repository.getAllocationBudgets();
  }

  Future<void> addAllocationBudget({
    required String name,
    double? targetAmount,
    double? monthlyAllocation,
  }) async {
    state = const AsyncValue.loading();
    final now = DateTime.now();
    final budget = AllocationBudgetEntity(
      id: const Uuid().v4(),
      name: name,
      targetAmount: targetAmount,
      monthlyAllocation: monthlyAllocation,
      totalAllocated: 0.0,
      createdAt: now,
      updatedAt: now,
    );

    final repository = ref.read(allocationBudgetRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.upsertAllocationBudget(budget);
      return repository.getAllocationBudgets();
    });
  }

  Future<void> updateAllocationBudget(AllocationBudgetEntity budget) async {
    state = const AsyncValue.loading();
    final repository = ref.read(allocationBudgetRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final updated = budget.copyWith(updatedAt: DateTime.now());
      await repository.upsertAllocationBudget(updated);
      return repository.getAllocationBudgets();
    });
  }

  Future<void> allocateAmount(String id, double amount) async {
    final current = state.value;
    if (current == null) return;

    final budgetIndex = current.indexWhere((b) => b.id == id);
    if (budgetIndex == -1) return;

    final budget = current[budgetIndex];
    final updated = budget.copyWith(
      totalAllocated: budget.totalAllocated + amount,
      updatedAt: DateTime.now(),
    );

    state = const AsyncValue.loading();
    final repository = ref.read(allocationBudgetRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.upsertAllocationBudget(updated);
      return repository.getAllocationBudgets();
    });
  }

  Future<void> deleteAllocationBudget(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(allocationBudgetRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.deleteAllocationBudget(id);
      return repository.getAllocationBudgets();
    });
  }
}

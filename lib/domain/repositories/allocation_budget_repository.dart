import '../entities/allocation_budget_entity.dart';

abstract class AllocationBudgetRepository {
  Future<List<AllocationBudgetEntity>> getAllocationBudgets();
  Future<void> upsertAllocationBudget(AllocationBudgetEntity budget);
  Future<void> deleteAllocationBudget(String id);
}

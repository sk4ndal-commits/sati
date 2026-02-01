import 'package:drift/drift.dart';
import '../../domain/entities/allocation_budget_entity.dart';
import '../../domain/repositories/allocation_budget_repository.dart';
import '../database/app_database.dart';

class DriftAllocationBudgetRepository implements AllocationBudgetRepository {
  final AppDatabase _db;

  DriftAllocationBudgetRepository(this._db);

  @override
  Future<List<AllocationBudgetEntity>> getAllocationBudgets() async {
    final rows = await _db.select(_db.allocationBudgetTable).get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<void> upsertAllocationBudget(AllocationBudgetEntity budget) async {
    await _db.into(_db.allocationBudgetTable).insertOnConflictUpdate(
          AllocationBudgetTableCompanion.insert(
            id: budget.id,
            name: budget.name,
            targetAmount: Value(budget.targetAmount),
            monthlyAllocation: Value(budget.monthlyAllocation),
            totalAllocated: Value(budget.totalAllocated),
            createdAt: budget.createdAt,
            updatedAt: budget.updatedAt,
          ),
        );
  }

  @override
  Future<void> deleteAllocationBudget(String id) async {
    await (_db.delete(_db.allocationBudgetTable)..where((t) => t.id.equals(id))).go();
  }

  AllocationBudgetEntity _mapToEntity(AllocationBudgetTableData data) {
    return AllocationBudgetEntity(
      id: data.id,
      name: data.name,
      targetAmount: data.targetAmount,
      monthlyAllocation: data.monthlyAllocation,
      totalAllocated: data.totalAllocated,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}

import 'package:drift/drift.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../database/app_database.dart';

class DriftBudgetRepository implements BudgetRepository {
  final AppDatabase _db;

  DriftBudgetRepository(this._db);

  @override
  Future<List<BudgetEntity>> getBudgets(int month, int year) async {
    final query = _db.select(_db.budgetTable)
      ..where((t) => t.month.equals(month) & t.year.equals(year));
    final rows = await query.get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<List<BudgetEntity>> getAllBudgets() async {
    final rows = await _db.select(_db.budgetTable).get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<void> saveBudget(BudgetEntity budget) async {
    await _db.into(_db.budgetTable).insertOnConflictUpdate(
          BudgetTableCompanion.insert(
            id: budget.id,
            categoryId: budget.categoryId,
            amount: budget.amount,
            rollover: Value(budget.rollover),
            month: budget.month,
            year: budget.year,
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> deleteBudget(String id) async {
    await (_db.delete(_db.budgetTable)..where((t) => t.id.equals(id))).go();
  }

  BudgetEntity _mapToEntity(BudgetTableData data) {
    return BudgetEntity(
      id: data.id,
      categoryId: data.categoryId,
      amount: data.amount,
      rollover: data.rollover,
      month: data.month,
      year: data.year,
    );
  }
}

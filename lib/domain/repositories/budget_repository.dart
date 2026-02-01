import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getBudgets(int month, int year);
  Future<List<BudgetEntity>> getAllBudgets();
  Future<void> saveBudget(BudgetEntity budget);
  Future<void> deleteBudget(String id);
}

import '../entities/income_source_entity.dart';

abstract class IncomeSourceRepository {
  Future<List<IncomeSourceEntity>> getAllIncomeSources();
  Future<void> saveIncomeSource(IncomeSourceEntity source);
  Future<void> deleteIncomeSource(String id);
}

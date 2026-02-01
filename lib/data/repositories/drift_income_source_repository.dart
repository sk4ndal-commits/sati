import '../../domain/entities/income_source_entity.dart';
import '../../domain/repositories/income_source_repository.dart';
import '../database/app_database.dart';

class DriftIncomeSourceRepository implements IncomeSourceRepository {
  final AppDatabase _db;

  DriftIncomeSourceRepository(this._db);

  @override
  Future<List<IncomeSourceEntity>> getAllIncomeSources() async {
    final rows = await _db.select(_db.incomeSourceTable).get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<void> saveIncomeSource(IncomeSourceEntity source) async {
    await _db.into(_db.incomeSourceTable).insertOnConflictUpdate(
          IncomeSourceTableData(
            id: source.id,
            name: source.name,
            expectedAmount: source.expectedAmount,
            cadence: source.cadence,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> deleteIncomeSource(String id) async {
    await (_db.delete(_db.incomeSourceTable)..where((t) => t.id.equals(id))).go();
  }

  IncomeSourceEntity _mapToEntity(IncomeSourceTableData data) {
    return IncomeSourceEntity(
      id: data.id,
      name: data.name,
      expectedAmount: data.expectedAmount,
      cadence: data.cadence,
    );
  }
}

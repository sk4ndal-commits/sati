import 'package:drift/drift.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../database/app_database.dart';

class DriftTransactionRepository implements TransactionRepository {
  final AppDatabase _db;

  DriftTransactionRepository(this._db);

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final rows = await _db.select(_db.transactionTable).get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await _db.into(_db.transactionTable).insert(
          TransactionTableCompanion.insert(
            id: transaction.id,
            amount: transaction.amount,
            type: transaction.type.name,
            categoryId: transaction.categoryId,
            date: transaction.date,
            note: Value(transaction.note),
            incomeSourceId: Value(transaction.incomeSourceId),
            planned: Value(transaction.planned),
            feeling: Value(transaction.feeling),
          ),
        );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await (_db.delete(_db.transactionTable)..where((t) => t.id.equals(id))).go();
  }

  TransactionEntity _mapToEntity(TransactionTableData data) {
    return TransactionEntity(
      id: data.id,
      amount: data.amount,
      type: TransactionType.values.byName(data.type),
      categoryId: data.categoryId,
      date: data.date,
      note: data.note,
      incomeSourceId: data.incomeSourceId,
      planned: data.planned,
      feeling: data.feeling,
    );
  }
}

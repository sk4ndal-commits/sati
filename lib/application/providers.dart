import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database/app_database.dart';
import '../data/repositories/drift_transaction_repository.dart';
import '../data/repositories/drift_income_source_repository.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/repositories/income_source_repository.dart';

part 'providers.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTransactionRepository(db);
}

@riverpod
IncomeSourceRepository incomeSourceRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftIncomeSourceRepository(db);
}

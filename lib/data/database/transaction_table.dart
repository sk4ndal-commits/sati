import 'package:drift/drift.dart';
import 'income_source_table.dart';

@DataClassName('TransactionTableData')
class TransactionTable extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'expense' or 'income'
  TextColumn get categoryId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get incomeSourceId => text().nullable().references(IncomeSourceTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

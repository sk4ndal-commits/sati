import 'package:drift/drift.dart';

@DataClassName('IncomeSourceTableData')
class IncomeSourceTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get expectedAmount => real().nullable()();
  TextColumn get cadence => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

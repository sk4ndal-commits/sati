import 'package:drift/drift.dart';

@DataClassName('BudgetTableData')
class BudgetTable extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  RealColumn get amount => real()();
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();
  IntColumn get month => integer()(); // 1-12
  IntColumn get year => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

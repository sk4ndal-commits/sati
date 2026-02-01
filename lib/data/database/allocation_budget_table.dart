import 'package:drift/drift.dart';

@DataClassName('AllocationBudgetTableData')
class AllocationBudgetTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real().nullable()();
  RealColumn get monthlyAllocation => real().nullable()();
  RealColumn get totalAllocated => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

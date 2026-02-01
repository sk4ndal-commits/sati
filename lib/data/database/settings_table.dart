import 'package:drift/drift.dart';

@DataClassName('SettingsTableData')
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get intentPromptEnabled => boolean().withDefault(const Constant(true))();
  RealColumn get intentPromptThreshold => real().withDefault(const Constant(50.0))();
}

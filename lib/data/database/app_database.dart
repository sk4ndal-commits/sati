import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'transaction_table.dart';
import 'income_source_table.dart';
import 'budget_table.dart';
import 'settings_table.dart';
import 'allocation_budget_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TransactionTable, IncomeSourceTable, BudgetTable, SettingsTable, AllocationBudgetTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(incomeSourceTable);
            await m.addColumn(transactionTable, transactionTable.incomeSourceId);
          }
          if (from < 3) {
            await m.createTable(budgetTable);
          }
          if (from < 4) {
            await m.createTable(settingsTable);
            await m.addColumn(transactionTable, transactionTable.planned);
            await m.addColumn(transactionTable, transactionTable.feeling);
          }
          if (from < 5) {
            // Check if settingsTable exists (it should if from >= 4, but let's be safe)
            // If from == 4, the table was created but might be missing the new columns 
            // if they were added to the class without a schema bump.
            await m.addColumn(settingsTable, settingsTable.lastSeenMonth);
            await m.addColumn(settingsTable, settingsTable.lastSeenYear);
          }
          if (from < 6) {
            await m.addColumn(settingsTable, settingsTable.hasSeenOnboarding);
          }
          if (from < 7) {
            await m.createTable(allocationBudgetTable);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // Optional: pre-populate categories or default data
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}

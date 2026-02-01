import 'package:drift/drift.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';

class DriftSettingsRepository implements SettingsRepository {
  final AppDatabase _db;

  DriftSettingsRepository(this._db);

  @override
  Future<SettingsEntity> getSettings() async {
    final row = await _db.select(_db.settingsTable).getSingleOrNull();
    if (row == null) {
      // Return default settings
      return SettingsEntity(
        intentPromptEnabled: true,
        intentPromptThreshold: 50.0,
        hasSeenOnboarding: false,
      );
    }
    return SettingsEntity(
      intentPromptEnabled: row.intentPromptEnabled,
      intentPromptThreshold: row.intentPromptThreshold,
      lastSeenMonth: row.lastSeenMonth,
      lastSeenYear: row.lastSeenYear,
      hasSeenOnboarding: row.hasSeenOnboarding,
    );
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    final existing = await _db.select(_db.settingsTable).getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.settingsTable).insert(
            SettingsTableCompanion.insert(
              intentPromptEnabled: Value(settings.intentPromptEnabled),
              intentPromptThreshold: Value(settings.intentPromptThreshold),
              lastSeenMonth: Value(settings.lastSeenMonth),
              lastSeenYear: Value(settings.lastSeenYear),
              hasSeenOnboarding: Value(settings.hasSeenOnboarding),
            ),
          );
    } else {
      await (_db.update(_db.settingsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        SettingsTableCompanion(
          intentPromptEnabled: Value(settings.intentPromptEnabled),
          intentPromptThreshold: Value(settings.intentPromptThreshold),
          lastSeenMonth: Value(settings.lastSeenMonth),
          lastSeenYear: Value(settings.lastSeenYear),
          hasSeenOnboarding: Value(settings.hasSeenOnboarding),
        ),
      );
    }
  }
}

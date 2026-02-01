import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/settings_entity.dart';
import 'providers.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<SettingsEntity> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateSettings(SettingsEntity settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).updateSettings(settings);
      return settings;
    });
  }

  Future<void> toggleIntentPrompt(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    await updateSettings(SettingsEntity(
      intentPromptEnabled: enabled,
      intentPromptThreshold: current.intentPromptThreshold,
    ));
  }

  Future<void> setThreshold(double threshold) async {
    final current = state.value;
    if (current == null) return;
    await updateSettings(SettingsEntity(
      intentPromptEnabled: current.intentPromptEnabled,
      intentPromptThreshold: threshold,
    ));
  }
}

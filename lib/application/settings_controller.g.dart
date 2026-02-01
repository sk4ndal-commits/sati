// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsController)
const settingsControllerProvider = SettingsControllerProvider._();

final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, SettingsEntity> {
  const SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'4232b6836bbc203b8f17f7be4e84c376601bbb54';

abstract class _$SettingsController extends $AsyncNotifier<SettingsEntity> {
  FutureOr<SettingsEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SettingsEntity>, SettingsEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsEntity>, SettingsEntity>,
              AsyncValue<SettingsEntity>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

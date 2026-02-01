// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friction_calibration_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(frictionCalibration)
const frictionCalibrationProvider = FrictionCalibrationFamily._();

final class FrictionCalibrationProvider
    extends
        $FunctionalProvider<
          AsyncValue<FrictionState>,
          FrictionState,
          FutureOr<FrictionState>
        >
    with $FutureModifier<FrictionState>, $FutureProvider<FrictionState> {
  const FrictionCalibrationProvider._({
    required FrictionCalibrationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'frictionCalibrationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$frictionCalibrationHash();

  @override
  String toString() {
    return r'frictionCalibrationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FrictionState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FrictionState> create(Ref ref) {
    final argument = this.argument as String;
    return frictionCalibration(ref, categoryId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FrictionCalibrationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$frictionCalibrationHash() =>
    r'983935d7283f145b749afb60e161bce81c59c107';

final class FrictionCalibrationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FrictionState>, String> {
  const FrictionCalibrationFamily._()
    : super(
        retry: null,
        name: r'frictionCalibrationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FrictionCalibrationProvider call({required String categoryId}) =>
      FrictionCalibrationProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'frictionCalibrationProvider';
}

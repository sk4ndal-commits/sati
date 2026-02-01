// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_source_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IncomeSourceController)
const incomeSourceControllerProvider = IncomeSourceControllerProvider._();

final class IncomeSourceControllerProvider
    extends
        $AsyncNotifierProvider<
          IncomeSourceController,
          List<IncomeSourceEntity>
        > {
  const IncomeSourceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourceControllerHash();

  @$internal
  @override
  IncomeSourceController create() => IncomeSourceController();
}

String _$incomeSourceControllerHash() =>
    r'42687cec4cb45877da458043ed10f71808ba58c2';

abstract class _$IncomeSourceController
    extends $AsyncNotifier<List<IncomeSourceEntity>> {
  FutureOr<List<IncomeSourceEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<IncomeSourceEntity>>,
              List<IncomeSourceEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<IncomeSourceEntity>>,
                List<IncomeSourceEntity>
              >,
              AsyncValue<List<IncomeSourceEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

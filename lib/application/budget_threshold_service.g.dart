// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_threshold_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetThresholdService)
const budgetThresholdServiceProvider = BudgetThresholdServiceProvider._();

final class BudgetThresholdServiceProvider
    extends $NotifierProvider<BudgetThresholdService, void> {
  const BudgetThresholdServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetThresholdServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetThresholdServiceHash();

  @$internal
  @override
  BudgetThresholdService create() => BudgetThresholdService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$budgetThresholdServiceHash() =>
    r'a2fce80ed8e575b8c1e750a322b1389cb374ab5d';

abstract class _$BudgetThresholdService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

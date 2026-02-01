// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_budget_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AllocationBudgetController)
const allocationBudgetControllerProvider =
    AllocationBudgetControllerProvider._();

final class AllocationBudgetControllerProvider
    extends
        $AsyncNotifierProvider<
          AllocationBudgetController,
          List<AllocationBudgetEntity>
        > {
  const AllocationBudgetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allocationBudgetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allocationBudgetControllerHash();

  @$internal
  @override
  AllocationBudgetController create() => AllocationBudgetController();
}

String _$allocationBudgetControllerHash() =>
    r'b3a0de9c7a5088a7b0c874f247998359957bb4a8';

abstract class _$AllocationBudgetController
    extends $AsyncNotifier<List<AllocationBudgetEntity>> {
  FutureOr<List<AllocationBudgetEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AllocationBudgetEntity>>,
              List<AllocationBudgetEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AllocationBudgetEntity>>,
                List<AllocationBudgetEntity>
              >,
              AsyncValue<List<AllocationBudgetEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

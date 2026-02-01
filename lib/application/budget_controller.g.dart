// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetController)
const budgetControllerProvider = BudgetControllerProvider._();

final class BudgetControllerProvider
    extends $AsyncNotifierProvider<BudgetController, List<BudgetEntity>> {
  const BudgetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetControllerHash();

  @$internal
  @override
  BudgetController create() => BudgetController();
}

String _$budgetControllerHash() => r'771927a18ff10878c531cbafa67582f80c023c1b';

abstract class _$BudgetController extends $AsyncNotifier<List<BudgetEntity>> {
  FutureOr<List<BudgetEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<BudgetEntity>>, List<BudgetEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BudgetEntity>>, List<BudgetEntity>>,
              AsyncValue<List<BudgetEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetOverview)
const budgetOverviewProvider = BudgetOverviewProvider._();

final class BudgetOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryBudgetStatus>>,
          List<CategoryBudgetStatus>,
          FutureOr<List<CategoryBudgetStatus>>
        >
    with
        $FutureModifier<List<CategoryBudgetStatus>>,
        $FutureProvider<List<CategoryBudgetStatus>> {
  const BudgetOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetOverviewHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryBudgetStatus>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryBudgetStatus>> create(Ref ref) {
    return budgetOverview(ref);
  }
}

String _$budgetOverviewHash() => r'8670c9db6e6806be6f0a1116a41e419e3f217b8b';

@ProviderFor(savingBudgetsOverview)
const savingBudgetsOverviewProvider = SavingBudgetsOverviewProvider._();

final class SavingBudgetsOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavingBudgetStatus>>,
          List<SavingBudgetStatus>,
          FutureOr<List<SavingBudgetStatus>>
        >
    with
        $FutureModifier<List<SavingBudgetStatus>>,
        $FutureProvider<List<SavingBudgetStatus>> {
  const SavingBudgetsOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingBudgetsOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingBudgetsOverviewHash();

  @$internal
  @override
  $FutureProviderElement<List<SavingBudgetStatus>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SavingBudgetStatus>> create(Ref ref) {
    return savingBudgetsOverview(ref);
  }
}

String _$savingBudgetsOverviewHash() =>
    r'3ad869665dac3751b6f0677984e32570cd0f5aea';

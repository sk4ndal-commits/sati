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

String _$budgetOverviewHash() => r'0bda9a16da5937d1df3f1fa4d6aa6f69324e4455';

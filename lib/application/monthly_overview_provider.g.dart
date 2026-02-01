// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monthlyOverview)
const monthlyOverviewProvider = MonthlyOverviewProvider._();

final class MonthlyOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyOverviewData>,
          MonthlyOverviewData,
          FutureOr<MonthlyOverviewData>
        >
    with
        $FutureModifier<MonthlyOverviewData>,
        $FutureProvider<MonthlyOverviewData> {
  const MonthlyOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyOverviewHash();

  @$internal
  @override
  $FutureProviderElement<MonthlyOverviewData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyOverviewData> create(Ref ref) {
    return monthlyOverview(ref);
  }
}

String _$monthlyOverviewHash() => r'b6c16ed22cdde8cd1c0ad8861b0c7e66725da295';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weeklyTrendsData)
const weeklyTrendsDataProvider = WeeklyTrendsDataProvider._();

final class WeeklyTrendsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeeklySpendingIntent>>,
          List<WeeklySpendingIntent>,
          FutureOr<List<WeeklySpendingIntent>>
        >
    with
        $FutureModifier<List<WeeklySpendingIntent>>,
        $FutureProvider<List<WeeklySpendingIntent>> {
  const WeeklyTrendsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyTrendsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyTrendsDataHash();

  @$internal
  @override
  $FutureProviderElement<List<WeeklySpendingIntent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklySpendingIntent>> create(Ref ref) {
    return weeklyTrendsData(ref);
  }
}

String _$weeklyTrendsDataHash() => r'499473481ceae98e21a735067ffdbfab3fd38529';

@ProviderFor(trendsData)
const trendsDataProvider = TrendsDataProvider._();

final class TrendsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlySpending>>,
          List<MonthlySpending>,
          FutureOr<List<MonthlySpending>>
        >
    with
        $FutureModifier<List<MonthlySpending>>,
        $FutureProvider<List<MonthlySpending>> {
  const TrendsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendsDataHash();

  @$internal
  @override
  $FutureProviderElement<List<MonthlySpending>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlySpending>> create(Ref ref) {
    return trendsData(ref);
  }
}

String _$trendsDataHash() => r'681e963cea1805a0ebb045081e4fda193c6f81a3';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_source_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(incomeSourceStats)
const incomeSourceStatsProvider = IncomeSourceStatsProvider._();

final class IncomeSourceStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IncomeSourceStats>>,
          List<IncomeSourceStats>,
          FutureOr<List<IncomeSourceStats>>
        >
    with
        $FutureModifier<List<IncomeSourceStats>>,
        $FutureProvider<List<IncomeSourceStats>> {
  const IncomeSourceStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourceStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourceStatsHash();

  @$internal
  @override
  $FutureProviderElement<List<IncomeSourceStats>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IncomeSourceStats>> create(Ref ref) {
    return incomeSourceStats(ref);
  }
}

String _$incomeSourceStatsHash() => r'1c0fdd0153da5f2604a7e66c82af43e64b7abefb';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weeklyReview)
const weeklyReviewProvider = WeeklyReviewProvider._();

final class WeeklyReviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyReviewData>,
          WeeklyReviewData,
          FutureOr<WeeklyReviewData>
        >
    with $FutureModifier<WeeklyReviewData>, $FutureProvider<WeeklyReviewData> {
  const WeeklyReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyReviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyReviewHash();

  @$internal
  @override
  $FutureProviderElement<WeeklyReviewData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklyReviewData> create(Ref ref) {
    return weeklyReview(ref);
  }
}

String _$weeklyReviewHash() => r'bea2de62a92dbadebbbe26865c8e5f6549fbf080';

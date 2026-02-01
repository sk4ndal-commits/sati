// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeState)
const homeStateProvider = HomeStateProvider._();

final class HomeStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeState>,
          HomeState,
          FutureOr<HomeState>
        >
    with $FutureModifier<HomeState>, $FutureProvider<HomeState> {
  const HomeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeStateHash();

  @$internal
  @override
  $FutureProviderElement<HomeState> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HomeState> create(Ref ref) {
    return homeState(ref);
  }
}

String _$homeStateHash() => r'474c7886a26ac206ce749521d2c6e451a49847e9';

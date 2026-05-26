// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimento_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alimentoRemoteDataSource)
final alimentoRemoteDataSourceProvider = AlimentoRemoteDataSourceProvider._();

final class AlimentoRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AlimentoRemoteDataSource,
          AlimentoRemoteDataSource,
          AlimentoRemoteDataSource
        >
    with $Provider<AlimentoRemoteDataSource> {
  AlimentoRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alimentoRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alimentoRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AlimentoRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlimentoRemoteDataSource create(Ref ref) {
    return alimentoRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlimentoRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlimentoRemoteDataSource>(value),
    );
  }
}

String _$alimentoRemoteDataSourceHash() =>
    r'a855d7994b5c2f84fb36e15f4ae46bff28a50408';

@ProviderFor(alimentoRepository)
final alimentoRepositoryProvider = AlimentoRepositoryProvider._();

final class AlimentoRepositoryProvider
    extends
        $FunctionalProvider<
          AlimentoRepository,
          AlimentoRepository,
          AlimentoRepository
        >
    with $Provider<AlimentoRepository> {
  AlimentoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alimentoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alimentoRepositoryHash();

  @$internal
  @override
  $ProviderElement<AlimentoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlimentoRepository create(Ref ref) {
    return alimentoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlimentoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlimentoRepository>(value),
    );
  }
}

String _$alimentoRepositoryHash() =>
    r'e19b1de65ebb9508658f08a31151ac829311fc0d';

@ProviderFor(AlimentosCache)
final alimentosCacheProvider = AlimentosCacheProvider._();

final class AlimentosCacheProvider
    extends $AsyncNotifierProvider<AlimentosCache, List<Alimento>> {
  AlimentosCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alimentosCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alimentosCacheHash();

  @$internal
  @override
  AlimentosCache create() => AlimentosCache();
}

String _$alimentosCacheHash() => r'8dfa4ad8af045e6b25eee6667f1657d862922cea';

abstract class _$AlimentosCache extends $AsyncNotifier<List<Alimento>> {
  FutureOr<List<Alimento>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Alimento>>, List<Alimento>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Alimento>>, List<Alimento>>,
              AsyncValue<List<Alimento>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

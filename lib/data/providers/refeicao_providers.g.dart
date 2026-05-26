// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refeicao_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refeicaoRemoteDataSource)
final refeicaoRemoteDataSourceProvider = RefeicaoRemoteDataSourceProvider._();

final class RefeicaoRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          RefeicaoRemoteDataSource,
          RefeicaoRemoteDataSource,
          RefeicaoRemoteDataSource
        >
    with $Provider<RefeicaoRemoteDataSource> {
  RefeicaoRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refeicaoRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refeicaoRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<RefeicaoRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefeicaoRemoteDataSource create(Ref ref) {
    return refeicaoRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefeicaoRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefeicaoRemoteDataSource>(value),
    );
  }
}

String _$refeicaoRemoteDataSourceHash() =>
    r'b570898e5932e02b6de4b3ebbb2daeae6517b9ae';

@ProviderFor(refeicaoRepository)
final refeicaoRepositoryProvider = RefeicaoRepositoryProvider._();

final class RefeicaoRepositoryProvider
    extends
        $FunctionalProvider<
          RefeicaoRepository,
          RefeicaoRepository,
          RefeicaoRepository
        >
    with $Provider<RefeicaoRepository> {
  RefeicaoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refeicaoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refeicaoRepositoryHash();

  @$internal
  @override
  $ProviderElement<RefeicaoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefeicaoRepository create(Ref ref) {
    return refeicaoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefeicaoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefeicaoRepository>(value),
    );
  }
}

String _$refeicaoRepositoryHash() =>
    r'e3b6b98e16186c9f4673da74b7f9048555f3180e';

@ProviderFor(perfilStatus)
final perfilStatusProvider = PerfilStatusProvider._();

final class PerfilStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<PerfilStatusModel>,
          PerfilStatusModel,
          FutureOr<PerfilStatusModel>
        >
    with
        $FutureModifier<PerfilStatusModel>,
        $FutureProvider<PerfilStatusModel> {
  PerfilStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'perfilStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$perfilStatusHash();

  @$internal
  @override
  $FutureProviderElement<PerfilStatusModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PerfilStatusModel> create(Ref ref) {
    return perfilStatus(ref);
  }
}

String _$perfilStatusHash() => r'52d0e5dccc2a327ce3fdab17e12dfe10a2b6b26a';

@ProviderFor(OfflineQueue)
final offlineQueueProvider = OfflineQueueProvider._();

final class OfflineQueueProvider
    extends $AsyncNotifierProvider<OfflineQueue, List<RefeicaoPendente>> {
  OfflineQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineQueueHash();

  @$internal
  @override
  OfflineQueue create() => OfflineQueue();
}

String _$offlineQueueHash() => r'7d1994c8cb63d76e6e997218f0c7be559d926fb7';

abstract class _$OfflineQueue extends $AsyncNotifier<List<RefeicaoPendente>> {
  FutureOr<List<RefeicaoPendente>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<RefeicaoPendente>>, List<RefeicaoPendente>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RefeicaoPendente>>,
                List<RefeicaoPendente>
              >,
              AsyncValue<List<RefeicaoPendente>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider para indicar status de sincronização

@ProviderFor(SyncStatus)
final syncStatusProvider = SyncStatusProvider._();

/// Provider para indicar status de sincronização
final class SyncStatusProvider
    extends $NotifierProvider<SyncStatus, SyncState> {
  /// Provider para indicar status de sincronização
  SyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  SyncStatus create() => SyncStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncStatusHash() => r'21edae89b5b9283ebf52e73c64bbfbe85dd835f8';

/// Provider para indicar status de sincronização

abstract class _$SyncStatus extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

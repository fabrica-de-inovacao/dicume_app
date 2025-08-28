// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refeicao_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$refeicaoRemoteDataSourceHash() =>
    r'b570898e5932e02b6de4b3ebbb2daeae6517b9ae';

/// See also [refeicaoRemoteDataSource].
@ProviderFor(refeicaoRemoteDataSource)
final refeicaoRemoteDataSourceProvider =
    AutoDisposeProvider<RefeicaoRemoteDataSource>.internal(
      refeicaoRemoteDataSource,
      name: r'refeicaoRemoteDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$refeicaoRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefeicaoRemoteDataSourceRef =
    AutoDisposeProviderRef<RefeicaoRemoteDataSource>;
String _$refeicaoRepositoryHash() =>
    r'e3b6b98e16186c9f4673da74b7f9048555f3180e';

/// See also [refeicaoRepository].
@ProviderFor(refeicaoRepository)
final refeicaoRepositoryProvider =
    AutoDisposeProvider<RefeicaoRepository>.internal(
      refeicaoRepository,
      name: r'refeicaoRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$refeicaoRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefeicaoRepositoryRef = AutoDisposeProviderRef<RefeicaoRepository>;
String _$perfilStatusHash() => r'52d0e5dccc2a327ce3fdab17e12dfe10a2b6b26a';

/// See also [perfilStatus].
@ProviderFor(perfilStatus)
final perfilStatusProvider =
    AutoDisposeFutureProvider<PerfilStatusModel>.internal(
      perfilStatus,
      name: r'perfilStatusProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$perfilStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PerfilStatusRef = AutoDisposeFutureProviderRef<PerfilStatusModel>;
String _$offlineQueueHash() => r'7d1994c8cb63d76e6e997218f0c7be559d926fb7';

/// See also [OfflineQueue].
@ProviderFor(OfflineQueue)
final offlineQueueProvider = AutoDisposeAsyncNotifierProvider<
  OfflineQueue,
  List<RefeicaoPendente>
>.internal(
  OfflineQueue.new,
  name: r'offlineQueueProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$offlineQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OfflineQueue = AutoDisposeAsyncNotifier<List<RefeicaoPendente>>;
String _$syncStatusHash() => r'21edae89b5b9283ebf52e73c64bbfbe85dd835f8';

/// Provider para indicar status de sincronização
///
/// Copied from [SyncStatus].
@ProviderFor(SyncStatus)
final syncStatusProvider =
    AutoDisposeNotifierProvider<SyncStatus, SyncState>.internal(
      SyncStatus.new,
      name: r'syncStatusProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$syncStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncStatus = AutoDisposeNotifier<SyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

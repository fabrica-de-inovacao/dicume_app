// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimento_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alimentoRemoteDataSourceHash() =>
    r'a855d7994b5c2f84fb36e15f4ae46bff28a50408';

/// See also [alimentoRemoteDataSource].
@ProviderFor(alimentoRemoteDataSource)
final alimentoRemoteDataSourceProvider =
    AutoDisposeProvider<AlimentoRemoteDataSource>.internal(
      alimentoRemoteDataSource,
      name: r'alimentoRemoteDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$alimentoRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlimentoRemoteDataSourceRef =
    AutoDisposeProviderRef<AlimentoRemoteDataSource>;
String _$alimentoRepositoryHash() =>
    r'e19b1de65ebb9508658f08a31151ac829311fc0d';

/// See also [alimentoRepository].
@ProviderFor(alimentoRepository)
final alimentoRepositoryProvider =
    AutoDisposeProvider<AlimentoRepository>.internal(
      alimentoRepository,
      name: r'alimentoRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$alimentoRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlimentoRepositoryRef = AutoDisposeProviderRef<AlimentoRepository>;
String _$alimentosCacheHash() => r'9430a961cfea5b1db4dfb500db1d3e08b06c35dc';

/// See also [AlimentosCache].
@ProviderFor(AlimentosCache)
final alimentosCacheProvider =
    AutoDisposeAsyncNotifierProvider<AlimentosCache, List<Object?>>.internal(
      AlimentosCache.new,
      name: r'alimentosCacheProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$alimentosCacheHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AlimentosCache = AutoDisposeAsyncNotifier<List<Object?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

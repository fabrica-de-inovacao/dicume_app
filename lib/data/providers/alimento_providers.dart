import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/alimento_repository.dart';
import '../repositories/alimento_repository_impl.dart';
import '../datasources/alimento_remote_datasource.dart';
import 'auth_providers.dart';
import '../../core/services/database_service.dart';

part 'alimento_providers.g.dart';

// ============================================================================
// DATA SOURCES
// ============================================================================

@riverpod
AlimentoRemoteDataSource alimentoRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AlimentoRemoteDataSourceImpl(dio: dio);
}

// ============================================================================
// REPOSITORIES
// ============================================================================

@riverpod
AlimentoRepository alimentoRepository(Ref ref) {
  final remoteDataSource = ref.watch(alimentoRemoteDataSourceProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final connectivity = ref.watch(connectivityProvider);

  return AlimentoRepositoryImpl(
    remoteDataSource: remoteDataSource,
    authLocalDataSource: authLocalDataSource,
    databaseService: databaseService,
    connectivity: connectivity,
  );
}

// ============================================================================
// USE CASES (Estados)
// ============================================================================

@riverpod
class AlimentosCache extends _$AlimentosCache {
  @override
  Future<List<Object?>> build() async {
    final repository = ref.watch(alimentoRepositoryProvider);

    // Verifica se o cache está desatualizado
    final isOutdated = await repository.isCacheOutdated();
    if (isOutdated) {
      // Tenta sincronizar com a API
      await repository.syncAlimentosFromAPI();
    }

    // Retorna os alimentos do cache local
    final result = await repository.getAllAlimentos();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (alimentos) => alimentos,
    );
  }

  Future<void> refresh() async {
    final repository = ref.read(alimentoRepositoryProvider);
    await repository.syncAlimentosFromAPI();
    ref.invalidateSelf();
  }

  Future<void> clearCache() async {
    final repository = ref.read(alimentoRepositoryProvider);
    await repository.clearCache();
    ref.invalidateSelf();
  }
}

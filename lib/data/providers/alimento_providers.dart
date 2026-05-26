import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/alimento_repository.dart';
import '../../domain/entities/alimento.dart';
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
  Future<List<Alimento>> build() async {
    print('📦 [CACHE] Inicializando cache de alimentos...');
    final repository = ref.watch(alimentoRepositoryProvider);

    // Verifica se o cache está desatualizado
    print('📦 [CACHE] Verificando se cache está desatualizado...');
    final isOutdated = await repository.isCacheOutdated();
    print('📦 [CACHE] Cache desatualizado: $isOutdated');

    if (isOutdated) {
      print('📦 [CACHE] Sincronizando com a API...');
      // Tenta sincronizar com a API
      final syncResult = await repository.syncAlimentosFromAPI();
      syncResult.fold(
        (failure) =>
            print('📦 [CACHE] ❌ Erro na sincronização: ${failure.message}'),
        (count) => print('📦 [CACHE] ✅ Sincronizados $count alimentos'),
      );
    }

    // Retorna os alimentos do cache local
    print('📦 [CACHE] Obtendo alimentos do cache local...');
    final result = await repository.getAllAlimentos();
    return result.fold(
      (failure) {
        print('📦 [CACHE] ❌ Erro ao obter alimentos: ${failure.message}');
        throw Exception(failure.message);
      },
      (alimentos) {
        print('📦 [CACHE] ✅ Retornando ${alimentos.length} alimentos do cache');
        return alimentos;
      },
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

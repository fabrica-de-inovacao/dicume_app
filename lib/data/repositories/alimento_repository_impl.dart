import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/alimento.dart' as entities;
import '../../domain/entities/failures.dart';
import '../../domain/repositories/alimento_repository.dart';
import '../datasources/alimento_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../../core/services/database_service.dart';
import '../../core/database/database.dart';

class AlimentoRepositoryImpl implements AlimentoRepository {
  final AlimentoRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final DatabaseService databaseService;
  final Connectivity connectivity;

  AlimentoRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
    required this.databaseService,
    required this.connectivity,
  });
  @override
  Future<Either<CacheFailure, List<entities.Alimento>>>
  getAllAlimentos() async {
    try {
      print('🍎 [ALIMENTOS] Buscando alimentos do banco local...');
      final alimentosDb = await databaseService.getAllAlimentos();
      print(
        '🍎 [ALIMENTOS] Encontrados ${alimentosDb.length} alimentos no banco',
      );

      final alimentosFutures = alimentosDb.map((alimentoDb) async {
        // Tenta recuperar o UUID original
        final originalId = await _getOriginalId(alimentoDb.id);
        return await _alimentoFromDb(alimentoDb, originalId: originalId);
      });

      // Aguarda todos os futures serem resolvidos
      final alimentosResolved = await Future.wait(alimentosFutures);
      print(
        '🍎 [ALIMENTOS] Retornando ${alimentosResolved.length} alimentos convertidos',
      );
      return Right(alimentosResolved);
    } catch (e) {
      print('🍎 [ALIMENTOS] ❌ Erro ao obter alimentos: $e');
      return Left(CacheFailure('Erro ao obter alimentos do cache: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<entities.Alimento>>> getAlimentosByGrupo(
    String grupo,
  ) async {
    try {
      final alimentosDb = await databaseService.getAlimentosByCategoria(grupo);
      final alimentosFutures = alimentosDb.map((db) => _alimentoFromDb(db));
      final alimentos = await Future.wait(alimentosFutures);
      return Right(alimentos);
    } catch (e) {
      return Left(CacheFailure('Erro ao obter alimentos por grupo: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<entities.Alimento>>> searchAlimentos(
    String query,
  ) async {
    try {
      print('🔍 [BUSCA] Buscando alimentos com query: "${query}"');
      final alimentosDb = await databaseService.searchAlimentos(query);
      print(
        '🔍 [BUSCA] Encontrados ${alimentosDb.length} alimentos que correspondem à busca',
      );

      final alimentosFutures = alimentosDb.map((db) => _alimentoFromDb(db));
      final alimentos = await Future.wait(alimentosFutures);
      print('🔍 [BUSCA] Retornando ${alimentos.length} alimentos convertidos');
      return Right(alimentos);
    } catch (e) {
      print('🔍 [BUSCA] ❌ Erro na busca: $e');
      return Left(CacheFailure('Erro ao buscar alimentos: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<entities.Alimento>>>
  getFavoritosAlimentos() async {
    try {
      final alimentosDb = await databaseService.getFavoritosAlimentos();
      final alimentosFutures = alimentosDb.map((db) => _alimentoFromDb(db));
      final alimentos = await Future.wait(alimentosFutures);
      return Right(alimentos);
    } catch (e) {
      return Left(CacheFailure('Erro ao obter alimentos favoritos: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, entities.Alimento?>> getAlimentoById(
    String id,
  ) async {
    try {
      // Converte String UUID para int temporariamente
      final intId = _stringToIntId(id);
      final alimentoDb = await databaseService.getAlimentoById(intId);
      if (alimentoDb == null) {
        return const Right(null);
      }
      final alimento = await _alimentoFromDb(alimentoDb, originalId: id);
      return Right(alimento);
    } catch (e) {
      return Left(CacheFailure('Erro ao obter alimento por ID: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, bool>> toggleFavorito(String alimentoId) async {
    try {
      // Converte String UUID para int temporariamente
      final intId = _stringToIntId(alimentoId);
      final alimentoDb = await databaseService.getAlimentoById(intId);
      if (alimentoDb == null) {
        return Left(CacheFailure('Alimento não encontrado'));
      }

      final alimentoAtualizado = alimentoDb.copyWith(
        isFavorito: !alimentoDb.isFavorito,
        updatedAt: DateTime.now(),
      );

      final success = await databaseService.updateAlimento(alimentoAtualizado);
      return Right(success);
    } catch (e) {
      return Left(CacheFailure('Erro ao atualizar favorito: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, int>> syncAlimentosFromAPI() async {
    try {
      print('🌐 [SYNC] Iniciando sincronização de alimentos da API...');

      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        print('🌐 [SYNC] ❌ Sem conexão com a internet');
        return Left(CacheFailure('Sem conexão com a internet'));
      }

      print(
        '🌐 [SYNC] ✅ Conectividade verificada, fazendo requisição à API...',
      );

      // Busca alimentos da API (sem autenticação necessária)
      final alimentosModel = await remoteDataSource.getAllAlimentos();
      print('🌐 [SYNC] ✅ Recebidos ${alimentosModel.length} alimentos da API');

      // Limpa cache atual
      print('🌐 [SYNC] Limpando cache atual...');
      await databaseService.clearAlimentos();

      // Salva novos alimentos no cache
      int count = 0;
      final Map<String, int> idMapping = {}; // Mapeia UUID para int

      print('🌐 [SYNC] Salvando alimentos no banco local...');
      for (final alimentoModel in alimentosModel) {
        // Converte UUID string para int único
        final intId = _stringToIntId(alimentoModel.id);
        idMapping[alimentoModel.id] = intId;

        final alimentoCompanion = AlimentosCompanion.insert(
          id: Value(intId), // Usa o ID convertido
          nome: alimentoModel.nomePopular,
          categoria: alimentoModel.grupoDicume,
          carboidratos: 0.0, // Dados nutricionais não disponíveis na API ainda
          proteinas: 0.0,
          gorduras: 0.0,
          calorias: 0.0,
          indiceCagemicoGlicemico: const Value(null),
        );

        await databaseService.insertAlimento(alimentoCompanion);
        // Salva a URL da foto no cache separado para recuperar depois
        await databaseService.setCacheValue(
          'alimento_foto_$intId',
          alimentoModel.fotoPorcaoUrl,
        );
        // Salva também a recomendação de consumo no cache para preservar o valor da API
        await databaseService.setCacheValue(
          'alimento_recomendacao_$intId',
          alimentoModel.recomendacaoConsumo,
        );
        // Salva a classificação do semáforo e outros metadados para reconstruir a entidade corretamente
        await databaseService.setCacheValue(
          'alimento_classificacao_$intId',
          alimentoModel.classificacaoCor,
        );
        await databaseService.setCacheValue(
          'alimento_grupo_nutricional_$intId',
          alimentoModel.grupoNutricional,
        );
        await databaseService.setCacheValue(
          'alimento_ig_classificacao_$intId',
          alimentoModel.igClassificacao,
        );
        await databaseService.setCacheValue(
          'alimento_guia_class_$intId',
          alimentoModel.guiaAlimentarClass,
        );
        count++;

        if (count % 20 == 0) {
          print('🌐 [SYNC] Salvos $count alimentos...');
        }
      }

      print('🌐 [SYNC] ✅ Total de $count alimentos salvos no banco local');

      // Salva o mapeamento de IDs
      await _saveIdMapping(idMapping);

      // Atualiza timestamp do cache
      await _updateCacheTimestamp();

      return Right(count);
    } on DioException catch (e) {
      print('🌐 [SYNC] ❌ Erro na API: ${e.message}');
      return Left(CacheFailure('Erro na API: ${e.message}'));
    } catch (e) {
      print('🌐 [SYNC] ❌ Erro na sincronização: $e');
      return Left(CacheFailure('Erro ao sincronizar alimentos: $e'));
    }
  }

  @override
  Future<bool> isCacheOutdated() async {
    try {
      final lastSync = await _getLastCacheTimestamp();
      if (lastSync == null) return true;

      final now = DateTime.now();
      final difference = now.difference(lastSync);

      // Cache é considerado desatualizado após 24 horas
      return difference.inHours >= 24;
    } catch (e) {
      return true; // Se houver erro, considera desatualizado
    }
  }

  @override
  Future<Either<CacheFailure, bool>> clearCache() async {
    try {
      await databaseService.clearAlimentos();
      await _clearCacheTimestamp();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure('Erro ao limpar cache: $e'));
    }
  }
  // Métodos auxiliares

  Future<entities.Alimento> _alimentoFromDb(
    Alimento alimentoDb, {
    String? originalId,
  }) async {
    // Se temos o ID original (UUID), usa ele; senão converte o int para string
    final alimentoId = originalId ?? alimentoDb.id.toString();
    // Tenta recuperar a URL da foto, recomendação, classificação e metadados do cache (se existirem)
    String fotoUrl = '';
    String recomendacao = '';
    String classificacao = '';
    String grupoNutricional = '';
    String igClass = '';
    String guiaClass = '';
    try {
      final cachedFoto = await databaseService.getCacheValue(
        'alimento_foto_${alimentoDb.id}',
      );
      if (cachedFoto != null) fotoUrl = cachedFoto;

      final cachedRec = await databaseService.getCacheValue(
        'alimento_recomendacao_${alimentoDb.id}',
      );
      if (cachedRec != null) recomendacao = cachedRec;
      final cachedClass = await databaseService.getCacheValue(
        'alimento_classificacao_${alimentoDb.id}',
      );
      if (cachedClass != null) classificacao = cachedClass;

      final cachedGrupoNut = await databaseService.getCacheValue(
        'alimento_grupo_nutricional_${alimentoDb.id}',
      );
      if (cachedGrupoNut != null) grupoNutricional = cachedGrupoNut;

      final cachedIg = await databaseService.getCacheValue(
        'alimento_ig_classificacao_${alimentoDb.id}',
      );
      if (cachedIg != null) igClass = cachedIg;

      final cachedGuia = await databaseService.getCacheValue(
        'alimento_guia_class_${alimentoDb.id}',
      );
      if (cachedGuia != null) guiaClass = cachedGuia;
    } catch (_) {}

    return entities.Alimento(
      id: alimentoId,
      nomePopular: alimentoDb.nome,
      grupoDicume: alimentoDb.categoria,
      // Usa valores vindos do cache quando disponíveis, senão mantém valores padrão razoáveis
      classificacaoCor: classificacao.isNotEmpty ? classificacao : 'verde',
      recomendacaoConsumo: recomendacao.isNotEmpty ? recomendacao : '1 porção',
      fotoPorcaoUrl: fotoUrl,
      grupoNutricional:
          grupoNutricional.isNotEmpty ? grupoNutricional : 'Carboidrato',
      igClassificacao: igClass.isNotEmpty ? igClass : 'baixo',
      guiaAlimentarClass: guiaClass.isNotEmpty ? guiaClass : 'in_natura',
      isFavorito: alimentoDb.isFavorito,
      createdAt: alimentoDb.createdAt,
      updatedAt: alimentoDb.updatedAt,
    );
  }

  /// Converte UUID string para int usando hash
  int _stringToIntId(String uuid) {
    return uuid.hashCode.abs();
  }

  /// Salva mapeamento de UUID para int no cache
  Future<void> _saveIdMapping(Map<String, int> mapping) async {
    final mappingJson = mapping.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    for (final entry in mappingJson.entries) {
      await databaseService.setCacheValue(
        'id_mapping_${entry.value}',
        entry.key,
      );
    }
  }

  /// Recupera UUID original a partir do int ID
  Future<String?> _getOriginalId(int intId) async {
    return await databaseService.getCacheValue('id_mapping_$intId');
  }

  Future<void> _updateCacheTimestamp() async {
    await databaseService.setCacheValue(
      'alimentos_last_sync',
      DateTime.now().toIso8601String(),
    );
  }

  Future<DateTime?> _getLastCacheTimestamp() async {
    try {
      final timestampStr = await databaseService.getCacheValue(
        'alimentos_last_sync',
      );
      if (timestampStr != null) {
        return DateTime.parse(timestampStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearCacheTimestamp() async {
    await databaseService.deleteCacheValue('alimentos_last_sync');
  }
}

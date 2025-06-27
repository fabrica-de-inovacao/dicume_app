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
      final alimentosDb = await databaseService.getAllAlimentos();
      final alimentos =
          alimentosDb.map((alimentoDb) async {
            // Tenta recuperar o UUID original
            final originalId = await _getOriginalId(alimentoDb.id);
            return _alimentoFromDb(alimentoDb, originalId: originalId);
          }).toList();

      // Aguarda todos os futures serem resolvidos
      final alimentosResolved = await Future.wait(alimentos);
      return Right(alimentosResolved);
    } catch (e) {
      return Left(CacheFailure('Erro ao obter alimentos do cache: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<entities.Alimento>>> getAlimentosByGrupo(
    String grupo,
  ) async {
    try {
      final alimentosDb = await databaseService.getAlimentosByCategoria(grupo);
      final alimentos = alimentosDb.map(_alimentoFromDb).toList();
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
      final alimentosDb = await databaseService.searchAlimentos(query);
      final alimentos = alimentosDb.map(_alimentoFromDb).toList();
      return Right(alimentos);
    } catch (e) {
      return Left(CacheFailure('Erro ao buscar alimentos: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<entities.Alimento>>>
  getFavoritosAlimentos() async {
    try {
      final alimentosDb = await databaseService.getFavoritosAlimentos();
      final alimentos = alimentosDb.map(_alimentoFromDb).toList();
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
      return Right(_alimentoFromDb(alimentoDb, originalId: id));
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
      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return Left(CacheFailure('Sem conexão com a internet'));
      }

      // Busca alimentos da API (sem autenticação necessária)
      final alimentosModel = await remoteDataSource.getAllAlimentos();

      // Limpa cache atual
      await databaseService.clearAlimentos();

      // Salva novos alimentos no cache
      int count = 0;
      final Map<String, int> idMapping = {}; // Mapeia UUID para int

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
        count++;
      }

      // Salva o mapeamento de IDs
      await _saveIdMapping(idMapping);

      // Atualiza timestamp do cache
      await _updateCacheTimestamp();

      return Right(count);
    } on DioException catch (e) {
      return Left(CacheFailure('Erro na API: ${e.message}'));
    } catch (e) {
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

  entities.Alimento _alimentoFromDb(Alimento alimentoDb, {String? originalId}) {
    // Se temos o ID original (UUID), usa ele; senão converte o int para string
    final alimentoId = originalId ?? alimentoDb.id.toString();

    return entities.Alimento(
      id: alimentoId,
      nomePopular: alimentoDb.nome,
      grupoDicume: alimentoDb.categoria,
      classificacaoCor: 'verde', // Será implementado depois com dados reais
      recomendacaoConsumo: '1 porção',
      fotoPorcaoUrl: '',
      grupoNutricional: 'Carboidrato',
      igClassificacao: 'baixo',
      guiaAlimentarClass: 'in_natura',
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

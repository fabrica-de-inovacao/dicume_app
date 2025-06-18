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
      final alimentos = alimentosDb.map(_alimentoFromDb).toList();
      return Right(alimentos);
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
    int id,
  ) async {
    try {
      final alimentoDb = await databaseService.getAlimentoById(id);
      if (alimentoDb == null) {
        return const Right(null);
      }
      return Right(_alimentoFromDb(alimentoDb));
    } catch (e) {
      return Left(CacheFailure('Erro ao obter alimento por ID: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, bool>> toggleFavorito(int alimentoId) async {
    try {
      final alimentoDb = await databaseService.getAlimentoById(alimentoId);
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

      // Obtém token de autenticação
      final token = await authLocalDataSource.getCachedToken();
      if (token == null) {
        return Left(CacheFailure('Token de autenticação não encontrado'));
      }

      // Busca alimentos da API
      final alimentosModel = await remoteDataSource.getAllAlimentos(
        token.accessToken,
      );

      // Limpa cache atual
      await databaseService.clearAlimentos();

      // Salva novos alimentos no cache
      int count = 0;
      for (final alimentoModel in alimentosModel) {
        final alimentoCompanion = AlimentosCompanion.insert(
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

  entities.Alimento _alimentoFromDb(Alimento alimentoDb) {
    return entities.Alimento(
      id: alimentoDb.id,
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

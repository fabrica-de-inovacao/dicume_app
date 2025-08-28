import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/refeicao.dart';
import '../../domain/entities/failures.dart';
import '../../domain/repositories/refeicao_repository.dart';
import '../datasources/refeicao_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../../core/services/database_service.dart';
import '../../core/database/database.dart';
import '../models/refeicao_pendente_model.dart';

class RefeicaoRepositoryImpl implements RefeicaoRepository {
  final RefeicaoRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final DatabaseService databaseService;
  final Connectivity connectivity;

  RefeicaoRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
    required this.databaseService,
    required this.connectivity,
  });

  @override
  Future<Either<CacheFailure, bool>> salvarRefeicaoOffline(
    RefeicaoPendente refeicao,
  ) async {
    try {
      final refeicaoModel = RefeicaoPendenteModel.fromEntity(refeicao);

      final companion = RefeicoesPendentesCompanion.insert(
        tipoRefeicao: refeicaoModel.tipoRefeicao,
        dataRefeicao: refeicaoModel.dataRefeicao,
        itensJson: refeicaoModel.toJsonString(),
        createdAt: Value(DateTime.parse(refeicaoModel.createdAt)),
      );

      await databaseService.insertRefeicaoPendente(companion);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure('Erro ao salvar refeição offline: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, List<RefeicaoPendente>>>
  getRefeicoesPendentes() async {
    try {
      final refeicoesPendentesDb =
          await databaseService.getAllRefeicoesPendentes();
      final refeicoes = refeicoesPendentesDb.map(_refeicaoFromDb).toList();
      return Right(refeicoes);
    } catch (e) {
      return Left(CacheFailure('Erro ao obter refeições pendentes: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, Map<String, dynamic>>> syncRefeicao(
    RefeicaoPendente refeicao,
  ) async {
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

      // Marca como sincronizando
      if (refeicao.id != null) {
        await databaseService.markRefeicaoAsSyncing(refeicao.id!);
      }

      // Converte para modelo da API
      final apiRequest = RefeicaoApiRequestModel.fromRefeicaoPendente(refeicao);

      // Envia para API
      final response = await remoteDataSource.enviarRefeicao(
        token.accessToken,
        apiRequest,
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(CacheFailure('Erro na API: ${e.message}'));
    } catch (e) {
      return Left(CacheFailure('Erro ao sincronizar refeição: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, int>> syncAllRefeicoesPendentes() async {
    try {
      final refeicoesPendentes =
          await databaseService.getRefeicoesPendentesSemSync();
      int sucessos = 0;

      for (final refeicaoDb in refeicoesPendentes) {
        final refeicao = _refeicaoFromDb(refeicaoDb);

        final result = await syncRefeicao(refeicao);

        if (result.isRight()) {
          // Sincronização bem-sucedida, remove da queue
          await databaseService.deleteRefeicaoPendente(refeicaoDb.id);
          sucessos++;
        } else {
          // Falha na sincronização, incrementa tentativas
          final refeicaoAtualizada = refeicaoDb.copyWith(
            isSyncing: false,
            lastSyncAttempt: Value(DateTime.now()),
            syncAttempts: refeicaoDb.syncAttempts + 1,
          );
          await databaseService.updateRefeicaoPendente(refeicaoAtualizada);
        }
      }

      return Right(sucessos);
    } catch (e) {
      return Left(CacheFailure('Erro ao sincronizar todas as refeições: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, bool>> removeRefeicaoSincronizada(int id) async {
    try {
      await databaseService.deleteRefeicaoPendente(id);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure('Erro ao remover refeição sincronizada: $e'));
    }
  }

  @override
  Future<Either<CacheFailure, bool>> clearQueue() async {
    try {
      await databaseService.clearAllRefeicoesPendentes();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure('Erro ao limpar queue: $e'));
    }
  }

  @override
  Future<bool> hasRefeicoesPendentes() async {
    try {
      final refeicoes = await databaseService.getAllRefeicoesPendentes();
      return refeicoes.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Métodos auxiliares

  RefeicaoPendente _refeicaoFromDb(RefeicoesPendente refeicaoDb) {
    final model = RefeicaoPendenteModel.fromJsonString(refeicaoDb.itensJson);

    return RefeicaoPendente(
      id: refeicaoDb.id,
      tipoRefeicao: refeicaoDb.tipoRefeicao,
      dataRefeicao: refeicaoDb.dataRefeicao,
      itens: model.itens.map((item) => item.toEntity()).toList(),
      createdAt: refeicaoDb.createdAt,
      isSyncing: refeicaoDb.isSyncing,
    );
  }
}

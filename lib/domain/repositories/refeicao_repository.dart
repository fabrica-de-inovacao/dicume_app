import 'package:dartz/dartz.dart';
import '../entities/refeicao.dart';
import '../entities/failures.dart';

abstract class RefeicaoRepository {
  /// Salva uma refeição localmente e adiciona à queue de sync
  Future<Either<CacheFailure, bool>> salvarRefeicaoOffline(
    RefeicaoPendente refeicao,
  );

  /// Obtém todas as refeições pendentes de sincronização
  Future<Either<CacheFailure, List<RefeicaoPendente>>> getRefeicoesPendentes();

  /// Sincroniza uma refeição específica com a API
  Future<Either<CacheFailure, Map<String, dynamic>>> syncRefeicao(
    RefeicaoPendente refeicao,
  );

  /// Sincroniza todas as refeições pendentes com a API
  Future<Either<CacheFailure, int>> syncAllRefeicoesPendentes();

  /// Remove uma refeição da queue após sincronização bem-sucedida
  Future<Either<CacheFailure, bool>> removeRefeicaoSincronizada(int id);

  /// Limpa toda a queue de refeições pendentes
  Future<Either<CacheFailure, bool>> clearQueue();

  /// Verifica se há refeições pendentes de sincronização
  Future<bool> hasRefeicoesPendentes();
}

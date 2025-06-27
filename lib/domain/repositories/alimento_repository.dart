import 'package:dartz/dartz.dart';
import '../entities/alimento.dart';
import '../entities/failures.dart';

abstract class AlimentoRepository {
  /// Obtém todos os alimentos do cache local
  Future<Either<CacheFailure, List<Alimento>>> getAllAlimentos();

  /// Obtém alimentos por categoria/grupo
  Future<Either<CacheFailure, List<Alimento>>> getAlimentosByGrupo(
    String grupo,
  );

  /// Busca alimentos por nome
  Future<Either<CacheFailure, List<Alimento>>> searchAlimentos(String query);

  /// Obtém alimentos favoritos
  Future<Either<CacheFailure, List<Alimento>>> getFavoritosAlimentos();

  /// Obtém um alimento específico por ID
  Future<Either<CacheFailure, Alimento?>> getAlimentoById(String id);

  /// Marca/desmarca alimento como favorito
  Future<Either<CacheFailure, bool>> toggleFavorito(String alimentoId);

  /// Sincroniza alimentos da API para o cache local
  Future<Either<CacheFailure, int>> syncAlimentosFromAPI();

  /// Verifica se o cache de alimentos está desatualizado
  Future<bool> isCacheOutdated();

  /// Limpa o cache de alimentos
  Future<Either<CacheFailure, bool>> clearCache();
}

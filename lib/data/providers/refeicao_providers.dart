import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/refeicao_repository.dart';
import '../../domain/entities/refeicao.dart';
import '../repositories/refeicao_repository_impl.dart';
import '../datasources/refeicao_remote_datasource.dart';
import 'auth_providers.dart';
import '../../core/services/database_service.dart';

part 'refeicao_providers.g.dart';

// ============================================================================
// DATA SOURCES
// ============================================================================

@riverpod
RefeicaoRemoteDataSource refeicaoRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return RefeicaoRemoteDataSourceImpl(dio: dio);
}

// ============================================================================
// REPOSITORIES
// ============================================================================

@riverpod
RefeicaoRepository refeicaoRepository(Ref ref) {
  final remoteDataSource = ref.watch(refeicaoRemoteDataSourceProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final connectivity = ref.watch(connectivityProvider);

  return RefeicaoRepositoryImpl(
    remoteDataSource: remoteDataSource,
    authLocalDataSource: authLocalDataSource,
    databaseService: databaseService,
    connectivity: connectivity,
  );
}

// ============================================================================
// PROVIDERS DE ESTADO
// ============================================================================

@riverpod
class OfflineQueue extends _$OfflineQueue {
  @override
  Future<List<RefeicaoPendente>> build() async {
    final repository = ref.watch(refeicaoRepositoryProvider);

    final result = await repository.getRefeicoesPendentes();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (refeicoes) => refeicoes,
    );
  }

  /// Adiciona uma refeição à queue offline
  Future<bool> adicionarRefeicao(RefeicaoPendente refeicao) async {
    final repository = ref.read(refeicaoRepositoryProvider);

    final result = await repository.salvarRefeicaoOffline(refeicao);

    if (result.isRight()) {
      ref.invalidateSelf();
      return true;
    }
    return false;
  }

  /// Sincroniza todas as refeições pendentes
  Future<int> sincronizarTodas() async {
    final repository = ref.read(refeicaoRepositoryProvider);

    final result = await repository.syncAllRefeicoesPendentes();

    if (result.isRight()) {
      ref.invalidateSelf();
      return result.getOrElse(() => 0);
    }

    throw Exception('Erro ao sincronizar refeições');
  }

  /// Limpa toda a queue
  Future<void> limparQueue() async {
    final repository = ref.read(refeicaoRepositoryProvider);

    await repository.clearQueue();
    ref.invalidateSelf();
  }

  /// Verifica se há refeições pendentes
  Future<bool> temRefeicoesPendentes() async {
    final repository = ref.read(refeicaoRepositoryProvider);
    return await repository.hasRefeicoesPendentes();
  }
}

/// Provider para indicar status de sincronização
@riverpod
class SyncStatus extends _$SyncStatus {
  @override
  SyncState build() {
    return const SyncState.idle();
  }

  void setSyncing() {
    state = const SyncState.syncing();
  }

  void setSuccess(int count) {
    state = SyncState.success(count);

    // Volta para idle após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      // Verifica se o provider ainda está ativo
      try {
        state = const SyncState.idle();
      } catch (e) {
        // Provider foi disposed, ignorar
      }
    });
  }

  void setError(String message) {
    state = SyncState.error(message);

    // Volta para idle após 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      // Verifica se o provider ainda está ativo
      try {
        state = const SyncState.idle();
      } catch (e) {
        // Provider foi disposed, ignorar
      }
    });
  }
}

/// Estados de sincronização
sealed class SyncState {
  const SyncState();

  const factory SyncState.idle() = _IdleState;
  const factory SyncState.syncing() = _SyncingState;
  const factory SyncState.success(int count) = _SuccessState;
  const factory SyncState.error(String message) = _ErrorState;
}

class _IdleState extends SyncState {
  const _IdleState();
}

class _SyncingState extends SyncState {
  const _SyncingState();
}

class _SuccessState extends SyncState {
  final int count;
  const _SuccessState(this.count);
}

class _ErrorState extends SyncState {
  final String message;
  const _ErrorState(this.message);
}

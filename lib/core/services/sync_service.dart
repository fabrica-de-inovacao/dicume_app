import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/providers/refeicao_providers.dart';
import '../../data/providers/alimento_providers.dart';
import '../../data/providers/auth_providers.dart';

/// Service para gerenciar sincronização automática
class SyncService {
  final Ref ref;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  SyncService({required this.ref, required this.connectivity});

  /// Inicia o serviço de sincronização
  void start() {
    _startConnectivityListener();
    _startPeriodicSync();
  }

  /// Para o serviço de sincronização
  void stop() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
  }

  /// Monitora mudanças de conectividade
  void _startConnectivityListener() {
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      connectivityResults,
    ) {
      final hasConnection =
          !connectivityResults.contains(ConnectivityResult.none);

      if (hasConnection) {
        _syncWhenOnline();
      }
    });
  }

  /// Sincronização periódica a cada 5 minutos quando online
  void _startPeriodicSync() {
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _syncWhenOnline(),
    );
  }

  /// Executa sincronização quando estiver online
  Future<void> _syncWhenOnline() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      final hasConnection =
          !connectivityResult.contains(ConnectivityResult.none);

      if (!hasConnection) return;

      // Sincroniza refeições pendentes
      await _syncRefeicoesPendentes();

      // Atualiza cache de alimentos se necessário
      await _updateAlimentosCache();
    } catch (e) {
      // Log de erro se necessário
      debugPrint('Erro na sincronização automática: $e');
    }
  }

  /// Sincroniza refeições pendentes
  Future<void> _syncRefeicoesPendentes() async {
    try {
      final offlineQueue = ref.read(offlineQueueProvider.notifier);
      await offlineQueue.sincronizarTodas();
    } catch (e) {
      debugPrint('Erro ao sincronizar refeições: $e');
    }
  }

  /// Atualiza cache de alimentos se necessário
  Future<void> _updateAlimentosCache() async {
    try {
      final alimentosCache = ref.read(alimentosCacheProvider.notifier);
      // Verifica se precisa atualizar (implementado no provider)
      await alimentosCache.refresh();
    } catch (e) {
      debugPrint('Erro ao atualizar cache de alimentos: $e');
    }
  }

  /// Força sincronização manual
  Future<SyncResult> forcedSync() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      final hasConnection =
          !connectivityResult.contains(ConnectivityResult.none);

      if (!hasConnection) {
        return SyncResult.noConnection();
      }

      int refeicoesSincronizadas = 0;
      bool alimentosAtualizados = false;

      // Sincroniza refeições
      try {
        final offlineQueue = ref.read(offlineQueueProvider.notifier);
        refeicoesSincronizadas = await offlineQueue.sincronizarTodas();
      } catch (e) {
        return SyncResult.error('Erro ao sincronizar refeições: $e');
      }

      // Atualiza alimentos
      try {
        final alimentosCache = ref.read(alimentosCacheProvider.notifier);
        await alimentosCache.refresh();
        alimentosAtualizados = true;
      } catch (e) {
        // Não falha se alimentos não sincronizaram, mas log o erro
        debugPrint('Erro ao atualizar alimentos: $e');
      }

      return SyncResult.success(
        refeicoesSincronizadas: refeicoesSincronizadas,
        alimentosAtualizados: alimentosAtualizados,
      );
    } catch (e) {
      return SyncResult.error('Erro geral na sincronização: $e');
    }
  }
}

/// Provider para o serviço de sincronização
final syncServiceProvider = Provider<SyncService>((ref) {
  final connectivity = ref.watch(connectivityProvider);

  final service = SyncService(ref: ref, connectivity: connectivity);

  // Inicia automaticamente
  service.start();

  // Para quando o provider for disposed
  ref.onDispose(() {
    service.stop();
  });

  return service;
});

/// Resultado de uma operação de sincronização
sealed class SyncResult {
  const SyncResult();

  const factory SyncResult.success({
    required int refeicoesSincronizadas,
    required bool alimentosAtualizados,
  }) = SyncSuccess;

  const factory SyncResult.noConnection() = SyncNoConnection;
  const factory SyncResult.error(String message) = SyncError;
}

class SyncSuccess extends SyncResult {
  final int refeicoesSincronizadas;
  final bool alimentosAtualizados;

  const SyncSuccess({
    required this.refeicoesSincronizadas,
    required this.alimentosAtualizados,
  });
}

class SyncNoConnection extends SyncResult {
  const SyncNoConnection();
}

class SyncError extends SyncResult {
  final String message;
  const SyncError(this.message);
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../database/database.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}

@riverpod
DatabaseService databaseService(Ref ref) {
  final db = ref.watch(databaseProvider);
  return DatabaseService(db);
}

class DatabaseService {
  final AppDatabase _db;

  DatabaseService(this._db);

  // Operações para Alimentos
  Future<List<Alimento>> getAllAlimentos() => _db.select(_db.alimentos).get();

  Future<List<Alimento>> getAlimentosByCategoria(String categoria) =>
      (_db.select(_db.alimentos)
        ..where((a) => a.categoria.equals(categoria))).get();

  Future<List<Alimento>> searchAlimentos(String query) =>
      (_db.select(_db.alimentos)..where((a) => a.nome.contains(query))).get();

  Future<List<Alimento>> getFavoritosAlimentos() =>
      (_db.select(_db.alimentos)
        ..where((a) => a.isFavorito.equals(true))).get();

  Future<Alimento?> getAlimentoById(int id) =>
      (_db.select(_db.alimentos)
        ..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> insertAlimento(AlimentosCompanion alimento) =>
      _db.into(_db.alimentos).insert(alimento);

  Future<bool> updateAlimento(Alimento alimento) =>
      _db.update(_db.alimentos).replace(alimento);

  Future<int> deleteAlimento(int id) =>
      (_db.delete(_db.alimentos)..where((a) => a.id.equals(id))).go();

  Future<int> clearAlimentos() => _db.delete(_db.alimentos).go();

  Future<bool> toggleFavoritoAlimento(int id) async {
    final alimento = await getAlimentoById(id);
    if (alimento == null) return false;

    return await updateAlimento(
      alimento.copyWith(
        isFavorito: !alimento.isFavorito,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Operações para Refeições
  Future<List<Refeicoe>> getAllRefeicoes() => _db.select(_db.refeicoes).get();

  Future<List<Refeicoe>> getRefeicoesByData(DateTime data) {
    final startOfDay = DateTime(data.year, data.month, data.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.refeicoes)
          ..where((r) => r.dataHora.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(r) => OrderingTerm.asc(r.dataHora)]))
        .get();
  }

  Future<List<Refeicoe>> getRefeicoesByTipo(String tipo) =>
      (_db.select(_db.refeicoes)..where((r) => r.tipo.equals(tipo))).get();

  Future<Refeicoe?> getRefeicaoById(int id) =>
      (_db.select(_db.refeicoes)
        ..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> insertRefeicao(RefeicoesCompanion refeicao) =>
      _db.into(_db.refeicoes).insert(refeicao);

  Future<bool> updateRefeicao(Refeicoe refeicao) =>
      _db.update(_db.refeicoes).replace(refeicao);

  Future<int> deleteRefeicao(int id) async {
    // Primeiro deleta os itens da refeição
    await (_db.delete(_db.itensRefeicao)
      ..where((i) => i.refeicaoId.equals(id))).go();
    // Depois deleta a refeição
    return (_db.delete(_db.refeicoes)..where((r) => r.id.equals(id))).go();
  }

  // Operações para Itens de Refeição
  Future<List<ItensRefeicaoData>> getItensByRefeicao(int refeicaoId) =>
      (_db.select(_db.itensRefeicao)
        ..where((i) => i.refeicaoId.equals(refeicaoId))).get();

  Future<int> insertItemRefeicao(ItensRefeicaoCompanion item) =>
      _db.into(_db.itensRefeicao).insert(item);

  Future<bool> updateItemRefeicao(ItensRefeicaoData item) =>
      _db.update(_db.itensRefeicao).replace(item);

  Future<int> deleteItemRefeicao(int id) =>
      (_db.delete(_db.itensRefeicao)..where((i) => i.id.equals(id))).go();

  // Operações de Cache simplificadas
  Future<String?> getCacheValue(String key) async {
    final cache =
        await (_db.select(_db.cacheApi)
          ..where((c) => c.key.equals(key))).getSingleOrNull();
    return cache?.data;
  }

  Future<void> setCacheValue(String key, String value) {
    return _db
        .into(_db.cacheApi)
        .insertOnConflictUpdate(
          CacheApiCompanion.insert(
            key: key,
            data: value,
            expiresAt: DateTime.now().add(const Duration(days: 30)),
          ),
        );
  }

  Future<int> deleteCacheValue(String key) =>
      (_db.delete(_db.cacheApi)..where((c) => c.key.equals(key))).go();

  // Operações de relatório
  Future<Map<String, double>> getResumoNutricionalDia(DateTime data) async {
    final refeicoes = await getRefeicoesByData(data);

    double totalCarboidratos = 0;
    double totalProteinas = 0;
    double totalGorduras = 0;
    double totalCalorias = 0;

    for (final refeicao in refeicoes) {
      totalCarboidratos += refeicao.totalCarboidratos;
      totalProteinas += refeicao.totalProteinas;
      totalGorduras += refeicao.totalGorduras;
      totalCalorias += refeicao.totalCalorias;
    }

    return {
      'carboidratos': totalCarboidratos,
      'proteinas': totalProteinas,
      'gorduras': totalGorduras,
      'calorias': totalCalorias,
    };
  }

  // Operações para Queue Offline de Refeições
  Future<List<RefeicoesPendente>> getAllRefeicoesPendentes() =>
      _db.select(_db.refeicoesPendentes).get();

  Future<List<RefeicoesPendente>> getRefeicoesPendentesSemSync() =>
      (_db.select(_db.refeicoesPendentes)
        ..where((r) => r.isSyncing.equals(false))).get();

  Future<int> insertRefeicaoPendente(RefeicoesPendentesCompanion refeicao) =>
      _db.into(_db.refeicoesPendentes).insert(refeicao);

  Future<bool> updateRefeicaoPendente(RefeicoesPendente refeicao) =>
      _db.update(_db.refeicoesPendentes).replace(refeicao);

  Future<int> deleteRefeicaoPendente(int id) =>
      (_db.delete(_db.refeicoesPendentes)..where((r) => r.id.equals(id))).go();

  Future<int> markRefeicaoAsSyncing(int id) =>
      (_db.update(_db.refeicoesPendentes)..where(
        (r) => r.id.equals(id),
      )).write(const RefeicoesPendentesCompanion(isSyncing: Value(true)));

  Future<int> clearAllRefeicoesPendentes() =>
      _db.delete(_db.refeicoesPendentes).go();

  // Fechar conexão
  Future<void> close() => _db.close();
}

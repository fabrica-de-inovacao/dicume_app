import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../constants/app_constants.dart';

// Tabelas
part 'database.g.dart';

// Tabela de Alimentos
class Alimentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 255)();
  TextColumn get categoria => text().withLength(min: 1, max: 100)();
  RealColumn get carboidratos => real()();
  RealColumn get proteinas => real()();
  RealColumn get gorduras => real()();
  RealColumn get calorias => real()();
  RealColumn get indiceCagemicoGlicemico => real().nullable()();
  BoolColumn get isFavorito => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Tabela de Refeições
class Refeicoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 255)();
  TextColumn get tipo =>
      text().withLength(
        min: 1,
        max: 50,
      )(); // cafe_manha, almoco, jantar, lanche
  DateTimeColumn get dataHora => dateTime()();
  RealColumn get totalCarboidratos => real().withDefault(const Constant(0))();
  RealColumn get totalProteinas => real().withDefault(const Constant(0))();
  RealColumn get totalGorduras => real().withDefault(const Constant(0))();
  RealColumn get totalCalorias => real().withDefault(const Constant(0))();
  TextColumn get observacoes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Tabela de Itens de Refeição (relacionamento entre Refeições e Alimentos)
class ItensRefeicao extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get refeicaoId => integer().references(Refeicoes, #id)();
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  RealColumn get quantidade => real()(); // em gramas
  RealColumn get carboidratos => real()();
  RealColumn get proteinas => real()();
  RealColumn get gorduras => real()();
  RealColumn get calorias => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Tabela de Cache de API
class CacheApi extends Table {
  TextColumn get key => text()();
  TextColumn get data => text()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

// Tabela de Queue Offline para Refeições Pendentes
class RefeicoesPendentes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipoRefeicao => text().withLength(min: 1, max: 50)();
  TextColumn get dataRefeicao =>
      text().withLength(min: 10, max: 10)(); // YYYY-MM-DD
  TextColumn get itensJson => text()(); // JSON dos itens da refeição
  BoolColumn get isSyncing => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAttempt => dateTime().nullable()();
  IntColumn get syncAttempts => integer().withDefault(const Constant(0))();
}

@DriftDatabase(
  tables: [Alimentos, Refeicoes, ItensRefeicao, CacheApi, RefeicoesPendentes],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Futuras migrações do banco de dados
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}

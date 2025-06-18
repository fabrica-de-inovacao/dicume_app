// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AlimentosTable extends Alimentos
    with TableInfo<$AlimentosTable, Alimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlimentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carboidratosMeta = const VerificationMeta(
    'carboidratos',
  );
  @override
  late final GeneratedColumn<double> carboidratos = GeneratedColumn<double>(
    'carboidratos',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinasMeta = const VerificationMeta(
    'proteinas',
  );
  @override
  late final GeneratedColumn<double> proteinas = GeneratedColumn<double>(
    'proteinas',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gordurasMeta = const VerificationMeta(
    'gorduras',
  );
  @override
  late final GeneratedColumn<double> gorduras = GeneratedColumn<double>(
    'gorduras',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriasMeta = const VerificationMeta(
    'calorias',
  );
  @override
  late final GeneratedColumn<double> calorias = GeneratedColumn<double>(
    'calorias',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indiceCagemicoGlicemicoMeta =
      const VerificationMeta('indiceCagemicoGlicemico');
  @override
  late final GeneratedColumn<double> indiceCagemicoGlicemico =
      GeneratedColumn<double>(
        'indice_cagemico_glicemico',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isFavoritoMeta = const VerificationMeta(
    'isFavorito',
  );
  @override
  late final GeneratedColumn<bool> isFavorito = GeneratedColumn<bool>(
    'is_favorito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    categoria,
    carboidratos,
    proteinas,
    gorduras,
    calorias,
    indiceCagemicoGlicemico,
    isFavorito,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alimentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Alimento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('carboidratos')) {
      context.handle(
        _carboidratosMeta,
        carboidratos.isAcceptableOrUnknown(
          data['carboidratos']!,
          _carboidratosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carboidratosMeta);
    }
    if (data.containsKey('proteinas')) {
      context.handle(
        _proteinasMeta,
        proteinas.isAcceptableOrUnknown(data['proteinas']!, _proteinasMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinasMeta);
    }
    if (data.containsKey('gorduras')) {
      context.handle(
        _gordurasMeta,
        gorduras.isAcceptableOrUnknown(data['gorduras']!, _gordurasMeta),
      );
    } else if (isInserting) {
      context.missing(_gordurasMeta);
    }
    if (data.containsKey('calorias')) {
      context.handle(
        _caloriasMeta,
        calorias.isAcceptableOrUnknown(data['calorias']!, _caloriasMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriasMeta);
    }
    if (data.containsKey('indice_cagemico_glicemico')) {
      context.handle(
        _indiceCagemicoGlicemicoMeta,
        indiceCagemicoGlicemico.isAcceptableOrUnknown(
          data['indice_cagemico_glicemico']!,
          _indiceCagemicoGlicemicoMeta,
        ),
      );
    }
    if (data.containsKey('is_favorito')) {
      context.handle(
        _isFavoritoMeta,
        isFavorito.isAcceptableOrUnknown(data['is_favorito']!, _isFavoritoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alimento(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nome:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nome'],
          )!,
      categoria:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}categoria'],
          )!,
      carboidratos:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}carboidratos'],
          )!,
      proteinas:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}proteinas'],
          )!,
      gorduras:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}gorduras'],
          )!,
      calorias:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calorias'],
          )!,
      indiceCagemicoGlicemico: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}indice_cagemico_glicemico'],
      ),
      isFavorito:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_favorito'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AlimentosTable createAlias(String alias) {
    return $AlimentosTable(attachedDatabase, alias);
  }
}

class Alimento extends DataClass implements Insertable<Alimento> {
  final int id;
  final String nome;
  final String categoria;
  final double carboidratos;
  final double proteinas;
  final double gorduras;
  final double calorias;
  final double? indiceCagemicoGlicemico;
  final bool isFavorito;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Alimento({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.carboidratos,
    required this.proteinas,
    required this.gorduras,
    required this.calorias,
    this.indiceCagemicoGlicemico,
    required this.isFavorito,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['categoria'] = Variable<String>(categoria);
    map['carboidratos'] = Variable<double>(carboidratos);
    map['proteinas'] = Variable<double>(proteinas);
    map['gorduras'] = Variable<double>(gorduras);
    map['calorias'] = Variable<double>(calorias);
    if (!nullToAbsent || indiceCagemicoGlicemico != null) {
      map['indice_cagemico_glicemico'] = Variable<double>(
        indiceCagemicoGlicemico,
      );
    }
    map['is_favorito'] = Variable<bool>(isFavorito);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AlimentosCompanion toCompanion(bool nullToAbsent) {
    return AlimentosCompanion(
      id: Value(id),
      nome: Value(nome),
      categoria: Value(categoria),
      carboidratos: Value(carboidratos),
      proteinas: Value(proteinas),
      gorduras: Value(gorduras),
      calorias: Value(calorias),
      indiceCagemicoGlicemico:
          indiceCagemicoGlicemico == null && nullToAbsent
              ? const Value.absent()
              : Value(indiceCagemicoGlicemico),
      isFavorito: Value(isFavorito),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Alimento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alimento(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: serializer.fromJson<String>(json['categoria']),
      carboidratos: serializer.fromJson<double>(json['carboidratos']),
      proteinas: serializer.fromJson<double>(json['proteinas']),
      gorduras: serializer.fromJson<double>(json['gorduras']),
      calorias: serializer.fromJson<double>(json['calorias']),
      indiceCagemicoGlicemico: serializer.fromJson<double?>(
        json['indiceCagemicoGlicemico'],
      ),
      isFavorito: serializer.fromJson<bool>(json['isFavorito']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(categoria),
      'carboidratos': serializer.toJson<double>(carboidratos),
      'proteinas': serializer.toJson<double>(proteinas),
      'gorduras': serializer.toJson<double>(gorduras),
      'calorias': serializer.toJson<double>(calorias),
      'indiceCagemicoGlicemico': serializer.toJson<double?>(
        indiceCagemicoGlicemico,
      ),
      'isFavorito': serializer.toJson<bool>(isFavorito),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Alimento copyWith({
    int? id,
    String? nome,
    String? categoria,
    double? carboidratos,
    double? proteinas,
    double? gorduras,
    double? calorias,
    Value<double?> indiceCagemicoGlicemico = const Value.absent(),
    bool? isFavorito,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Alimento(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoria: categoria ?? this.categoria,
    carboidratos: carboidratos ?? this.carboidratos,
    proteinas: proteinas ?? this.proteinas,
    gorduras: gorduras ?? this.gorduras,
    calorias: calorias ?? this.calorias,
    indiceCagemicoGlicemico:
        indiceCagemicoGlicemico.present
            ? indiceCagemicoGlicemico.value
            : this.indiceCagemicoGlicemico,
    isFavorito: isFavorito ?? this.isFavorito,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Alimento copyWithCompanion(AlimentosCompanion data) {
    return Alimento(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      carboidratos:
          data.carboidratos.present
              ? data.carboidratos.value
              : this.carboidratos,
      proteinas: data.proteinas.present ? data.proteinas.value : this.proteinas,
      gorduras: data.gorduras.present ? data.gorduras.value : this.gorduras,
      calorias: data.calorias.present ? data.calorias.value : this.calorias,
      indiceCagemicoGlicemico:
          data.indiceCagemicoGlicemico.present
              ? data.indiceCagemicoGlicemico.value
              : this.indiceCagemicoGlicemico,
      isFavorito:
          data.isFavorito.present ? data.isFavorito.value : this.isFavorito,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alimento(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('carboidratos: $carboidratos, ')
          ..write('proteinas: $proteinas, ')
          ..write('gorduras: $gorduras, ')
          ..write('calorias: $calorias, ')
          ..write('indiceCagemicoGlicemico: $indiceCagemicoGlicemico, ')
          ..write('isFavorito: $isFavorito, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoria,
    carboidratos,
    proteinas,
    gorduras,
    calorias,
    indiceCagemicoGlicemico,
    isFavorito,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alimento &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.carboidratos == this.carboidratos &&
          other.proteinas == this.proteinas &&
          other.gorduras == this.gorduras &&
          other.calorias == this.calorias &&
          other.indiceCagemicoGlicemico == this.indiceCagemicoGlicemico &&
          other.isFavorito == this.isFavorito &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AlimentosCompanion extends UpdateCompanion<Alimento> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> categoria;
  final Value<double> carboidratos;
  final Value<double> proteinas;
  final Value<double> gorduras;
  final Value<double> calorias;
  final Value<double?> indiceCagemicoGlicemico;
  final Value<bool> isFavorito;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AlimentosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.carboidratos = const Value.absent(),
    this.proteinas = const Value.absent(),
    this.gorduras = const Value.absent(),
    this.calorias = const Value.absent(),
    this.indiceCagemicoGlicemico = const Value.absent(),
    this.isFavorito = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AlimentosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String categoria,
    required double carboidratos,
    required double proteinas,
    required double gorduras,
    required double calorias,
    this.indiceCagemicoGlicemico = const Value.absent(),
    this.isFavorito = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nome = Value(nome),
       categoria = Value(categoria),
       carboidratos = Value(carboidratos),
       proteinas = Value(proteinas),
       gorduras = Value(gorduras),
       calorias = Value(calorias);
  static Insertable<Alimento> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<double>? carboidratos,
    Expression<double>? proteinas,
    Expression<double>? gorduras,
    Expression<double>? calorias,
    Expression<double>? indiceCagemicoGlicemico,
    Expression<bool>? isFavorito,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (carboidratos != null) 'carboidratos': carboidratos,
      if (proteinas != null) 'proteinas': proteinas,
      if (gorduras != null) 'gorduras': gorduras,
      if (calorias != null) 'calorias': calorias,
      if (indiceCagemicoGlicemico != null)
        'indice_cagemico_glicemico': indiceCagemicoGlicemico,
      if (isFavorito != null) 'is_favorito': isFavorito,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AlimentosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? categoria,
    Value<double>? carboidratos,
    Value<double>? proteinas,
    Value<double>? gorduras,
    Value<double>? calorias,
    Value<double?>? indiceCagemicoGlicemico,
    Value<bool>? isFavorito,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AlimentosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      carboidratos: carboidratos ?? this.carboidratos,
      proteinas: proteinas ?? this.proteinas,
      gorduras: gorduras ?? this.gorduras,
      calorias: calorias ?? this.calorias,
      indiceCagemicoGlicemico:
          indiceCagemicoGlicemico ?? this.indiceCagemicoGlicemico,
      isFavorito: isFavorito ?? this.isFavorito,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (carboidratos.present) {
      map['carboidratos'] = Variable<double>(carboidratos.value);
    }
    if (proteinas.present) {
      map['proteinas'] = Variable<double>(proteinas.value);
    }
    if (gorduras.present) {
      map['gorduras'] = Variable<double>(gorduras.value);
    }
    if (calorias.present) {
      map['calorias'] = Variable<double>(calorias.value);
    }
    if (indiceCagemicoGlicemico.present) {
      map['indice_cagemico_glicemico'] = Variable<double>(
        indiceCagemicoGlicemico.value,
      );
    }
    if (isFavorito.present) {
      map['is_favorito'] = Variable<bool>(isFavorito.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlimentosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('carboidratos: $carboidratos, ')
          ..write('proteinas: $proteinas, ')
          ..write('gorduras: $gorduras, ')
          ..write('calorias: $calorias, ')
          ..write('indiceCagemicoGlicemico: $indiceCagemicoGlicemico, ')
          ..write('isFavorito: $isFavorito, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RefeicoesTable extends Refeicoes
    with TableInfo<$RefeicoesTable, Refeicoe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefeicoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCarboidratosMeta = const VerificationMeta(
    'totalCarboidratos',
  );
  @override
  late final GeneratedColumn<double> totalCarboidratos =
      GeneratedColumn<double>(
        'total_carboidratos',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _totalProteinasMeta = const VerificationMeta(
    'totalProteinas',
  );
  @override
  late final GeneratedColumn<double> totalProteinas = GeneratedColumn<double>(
    'total_proteinas',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalGordurasMeta = const VerificationMeta(
    'totalGorduras',
  );
  @override
  late final GeneratedColumn<double> totalGorduras = GeneratedColumn<double>(
    'total_gorduras',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCaloriasMeta = const VerificationMeta(
    'totalCalorias',
  );
  @override
  late final GeneratedColumn<double> totalCalorias = GeneratedColumn<double>(
    'total_calorias',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    tipo,
    dataHora,
    totalCarboidratos,
    totalProteinas,
    totalGorduras,
    totalCalorias,
    observacoes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refeicoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Refeicoe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('total_carboidratos')) {
      context.handle(
        _totalCarboidratosMeta,
        totalCarboidratos.isAcceptableOrUnknown(
          data['total_carboidratos']!,
          _totalCarboidratosMeta,
        ),
      );
    }
    if (data.containsKey('total_proteinas')) {
      context.handle(
        _totalProteinasMeta,
        totalProteinas.isAcceptableOrUnknown(
          data['total_proteinas']!,
          _totalProteinasMeta,
        ),
      );
    }
    if (data.containsKey('total_gorduras')) {
      context.handle(
        _totalGordurasMeta,
        totalGorduras.isAcceptableOrUnknown(
          data['total_gorduras']!,
          _totalGordurasMeta,
        ),
      );
    }
    if (data.containsKey('total_calorias')) {
      context.handle(
        _totalCaloriasMeta,
        totalCalorias.isAcceptableOrUnknown(
          data['total_calorias']!,
          _totalCaloriasMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Refeicoe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Refeicoe(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nome:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nome'],
          )!,
      tipo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tipo'],
          )!,
      dataHora:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}data_hora'],
          )!,
      totalCarboidratos:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_carboidratos'],
          )!,
      totalProteinas:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_proteinas'],
          )!,
      totalGorduras:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_gorduras'],
          )!,
      totalCalorias:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_calorias'],
          )!,
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $RefeicoesTable createAlias(String alias) {
    return $RefeicoesTable(attachedDatabase, alias);
  }
}

class Refeicoe extends DataClass implements Insertable<Refeicoe> {
  final int id;
  final String nome;
  final String tipo;
  final DateTime dataHora;
  final double totalCarboidratos;
  final double totalProteinas;
  final double totalGorduras;
  final double totalCalorias;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Refeicoe({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.dataHora,
    required this.totalCarboidratos,
    required this.totalProteinas,
    required this.totalGorduras,
    required this.totalCalorias,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['tipo'] = Variable<String>(tipo);
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['total_carboidratos'] = Variable<double>(totalCarboidratos);
    map['total_proteinas'] = Variable<double>(totalProteinas);
    map['total_gorduras'] = Variable<double>(totalGorduras);
    map['total_calorias'] = Variable<double>(totalCalorias);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RefeicoesCompanion toCompanion(bool nullToAbsent) {
    return RefeicoesCompanion(
      id: Value(id),
      nome: Value(nome),
      tipo: Value(tipo),
      dataHora: Value(dataHora),
      totalCarboidratos: Value(totalCarboidratos),
      totalProteinas: Value(totalProteinas),
      totalGorduras: Value(totalGorduras),
      totalCalorias: Value(totalCalorias),
      observacoes:
          observacoes == null && nullToAbsent
              ? const Value.absent()
              : Value(observacoes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Refeicoe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Refeicoe(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      tipo: serializer.fromJson<String>(json['tipo']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      totalCarboidratos: serializer.fromJson<double>(json['totalCarboidratos']),
      totalProteinas: serializer.fromJson<double>(json['totalProteinas']),
      totalGorduras: serializer.fromJson<double>(json['totalGorduras']),
      totalCalorias: serializer.fromJson<double>(json['totalCalorias']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'tipo': serializer.toJson<String>(tipo),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'totalCarboidratos': serializer.toJson<double>(totalCarboidratos),
      'totalProteinas': serializer.toJson<double>(totalProteinas),
      'totalGorduras': serializer.toJson<double>(totalGorduras),
      'totalCalorias': serializer.toJson<double>(totalCalorias),
      'observacoes': serializer.toJson<String?>(observacoes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Refeicoe copyWith({
    int? id,
    String? nome,
    String? tipo,
    DateTime? dataHora,
    double? totalCarboidratos,
    double? totalProteinas,
    double? totalGorduras,
    double? totalCalorias,
    Value<String?> observacoes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Refeicoe(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    tipo: tipo ?? this.tipo,
    dataHora: dataHora ?? this.dataHora,
    totalCarboidratos: totalCarboidratos ?? this.totalCarboidratos,
    totalProteinas: totalProteinas ?? this.totalProteinas,
    totalGorduras: totalGorduras ?? this.totalGorduras,
    totalCalorias: totalCalorias ?? this.totalCalorias,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Refeicoe copyWithCompanion(RefeicoesCompanion data) {
    return Refeicoe(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      totalCarboidratos:
          data.totalCarboidratos.present
              ? data.totalCarboidratos.value
              : this.totalCarboidratos,
      totalProteinas:
          data.totalProteinas.present
              ? data.totalProteinas.value
              : this.totalProteinas,
      totalGorduras:
          data.totalGorduras.present
              ? data.totalGorduras.value
              : this.totalGorduras,
      totalCalorias:
          data.totalCalorias.present
              ? data.totalCalorias.value
              : this.totalCalorias,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Refeicoe(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tipo: $tipo, ')
          ..write('dataHora: $dataHora, ')
          ..write('totalCarboidratos: $totalCarboidratos, ')
          ..write('totalProteinas: $totalProteinas, ')
          ..write('totalGorduras: $totalGorduras, ')
          ..write('totalCalorias: $totalCalorias, ')
          ..write('observacoes: $observacoes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    tipo,
    dataHora,
    totalCarboidratos,
    totalProteinas,
    totalGorduras,
    totalCalorias,
    observacoes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Refeicoe &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.tipo == this.tipo &&
          other.dataHora == this.dataHora &&
          other.totalCarboidratos == this.totalCarboidratos &&
          other.totalProteinas == this.totalProteinas &&
          other.totalGorduras == this.totalGorduras &&
          other.totalCalorias == this.totalCalorias &&
          other.observacoes == this.observacoes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RefeicoesCompanion extends UpdateCompanion<Refeicoe> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> tipo;
  final Value<DateTime> dataHora;
  final Value<double> totalCarboidratos;
  final Value<double> totalProteinas;
  final Value<double> totalGorduras;
  final Value<double> totalCalorias;
  final Value<String?> observacoes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RefeicoesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.tipo = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.totalCarboidratos = const Value.absent(),
    this.totalProteinas = const Value.absent(),
    this.totalGorduras = const Value.absent(),
    this.totalCalorias = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RefeicoesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String tipo,
    required DateTime dataHora,
    this.totalCarboidratos = const Value.absent(),
    this.totalProteinas = const Value.absent(),
    this.totalGorduras = const Value.absent(),
    this.totalCalorias = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nome = Value(nome),
       tipo = Value(tipo),
       dataHora = Value(dataHora);
  static Insertable<Refeicoe> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? tipo,
    Expression<DateTime>? dataHora,
    Expression<double>? totalCarboidratos,
    Expression<double>? totalProteinas,
    Expression<double>? totalGorduras,
    Expression<double>? totalCalorias,
    Expression<String>? observacoes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (tipo != null) 'tipo': tipo,
      if (dataHora != null) 'data_hora': dataHora,
      if (totalCarboidratos != null) 'total_carboidratos': totalCarboidratos,
      if (totalProteinas != null) 'total_proteinas': totalProteinas,
      if (totalGorduras != null) 'total_gorduras': totalGorduras,
      if (totalCalorias != null) 'total_calorias': totalCalorias,
      if (observacoes != null) 'observacoes': observacoes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RefeicoesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? tipo,
    Value<DateTime>? dataHora,
    Value<double>? totalCarboidratos,
    Value<double>? totalProteinas,
    Value<double>? totalGorduras,
    Value<double>? totalCalorias,
    Value<String?>? observacoes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RefeicoesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      dataHora: dataHora ?? this.dataHora,
      totalCarboidratos: totalCarboidratos ?? this.totalCarboidratos,
      totalProteinas: totalProteinas ?? this.totalProteinas,
      totalGorduras: totalGorduras ?? this.totalGorduras,
      totalCalorias: totalCalorias ?? this.totalCalorias,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (totalCarboidratos.present) {
      map['total_carboidratos'] = Variable<double>(totalCarboidratos.value);
    }
    if (totalProteinas.present) {
      map['total_proteinas'] = Variable<double>(totalProteinas.value);
    }
    if (totalGorduras.present) {
      map['total_gorduras'] = Variable<double>(totalGorduras.value);
    }
    if (totalCalorias.present) {
      map['total_calorias'] = Variable<double>(totalCalorias.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefeicoesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tipo: $tipo, ')
          ..write('dataHora: $dataHora, ')
          ..write('totalCarboidratos: $totalCarboidratos, ')
          ..write('totalProteinas: $totalProteinas, ')
          ..write('totalGorduras: $totalGorduras, ')
          ..write('totalCalorias: $totalCalorias, ')
          ..write('observacoes: $observacoes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ItensRefeicaoTable extends ItensRefeicao
    with TableInfo<$ItensRefeicaoTable, ItensRefeicaoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItensRefeicaoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _refeicaoIdMeta = const VerificationMeta(
    'refeicaoId',
  );
  @override
  late final GeneratedColumn<int> refeicaoId = GeneratedColumn<int>(
    'refeicao_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES refeicoes (id)',
    ),
  );
  static const VerificationMeta _alimentoIdMeta = const VerificationMeta(
    'alimentoId',
  );
  @override
  late final GeneratedColumn<int> alimentoId = GeneratedColumn<int>(
    'alimento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alimentos (id)',
    ),
  );
  static const VerificationMeta _quantidadeMeta = const VerificationMeta(
    'quantidade',
  );
  @override
  late final GeneratedColumn<double> quantidade = GeneratedColumn<double>(
    'quantidade',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carboidratosMeta = const VerificationMeta(
    'carboidratos',
  );
  @override
  late final GeneratedColumn<double> carboidratos = GeneratedColumn<double>(
    'carboidratos',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinasMeta = const VerificationMeta(
    'proteinas',
  );
  @override
  late final GeneratedColumn<double> proteinas = GeneratedColumn<double>(
    'proteinas',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gordurasMeta = const VerificationMeta(
    'gorduras',
  );
  @override
  late final GeneratedColumn<double> gorduras = GeneratedColumn<double>(
    'gorduras',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriasMeta = const VerificationMeta(
    'calorias',
  );
  @override
  late final GeneratedColumn<double> calorias = GeneratedColumn<double>(
    'calorias',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    refeicaoId,
    alimentoId,
    quantidade,
    carboidratos,
    proteinas,
    gorduras,
    calorias,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itens_refeicao';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItensRefeicaoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('refeicao_id')) {
      context.handle(
        _refeicaoIdMeta,
        refeicaoId.isAcceptableOrUnknown(data['refeicao_id']!, _refeicaoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refeicaoIdMeta);
    }
    if (data.containsKey('alimento_id')) {
      context.handle(
        _alimentoIdMeta,
        alimentoId.isAcceptableOrUnknown(data['alimento_id']!, _alimentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alimentoIdMeta);
    }
    if (data.containsKey('quantidade')) {
      context.handle(
        _quantidadeMeta,
        quantidade.isAcceptableOrUnknown(data['quantidade']!, _quantidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_quantidadeMeta);
    }
    if (data.containsKey('carboidratos')) {
      context.handle(
        _carboidratosMeta,
        carboidratos.isAcceptableOrUnknown(
          data['carboidratos']!,
          _carboidratosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carboidratosMeta);
    }
    if (data.containsKey('proteinas')) {
      context.handle(
        _proteinasMeta,
        proteinas.isAcceptableOrUnknown(data['proteinas']!, _proteinasMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinasMeta);
    }
    if (data.containsKey('gorduras')) {
      context.handle(
        _gordurasMeta,
        gorduras.isAcceptableOrUnknown(data['gorduras']!, _gordurasMeta),
      );
    } else if (isInserting) {
      context.missing(_gordurasMeta);
    }
    if (data.containsKey('calorias')) {
      context.handle(
        _caloriasMeta,
        calorias.isAcceptableOrUnknown(data['calorias']!, _caloriasMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriasMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItensRefeicaoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItensRefeicaoData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      refeicaoId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}refeicao_id'],
          )!,
      alimentoId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}alimento_id'],
          )!,
      quantidade:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}quantidade'],
          )!,
      carboidratos:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}carboidratos'],
          )!,
      proteinas:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}proteinas'],
          )!,
      gorduras:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}gorduras'],
          )!,
      calorias:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calorias'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ItensRefeicaoTable createAlias(String alias) {
    return $ItensRefeicaoTable(attachedDatabase, alias);
  }
}

class ItensRefeicaoData extends DataClass
    implements Insertable<ItensRefeicaoData> {
  final int id;
  final int refeicaoId;
  final int alimentoId;
  final double quantidade;
  final double carboidratos;
  final double proteinas;
  final double gorduras;
  final double calorias;
  final DateTime createdAt;
  const ItensRefeicaoData({
    required this.id,
    required this.refeicaoId,
    required this.alimentoId,
    required this.quantidade,
    required this.carboidratos,
    required this.proteinas,
    required this.gorduras,
    required this.calorias,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['refeicao_id'] = Variable<int>(refeicaoId);
    map['alimento_id'] = Variable<int>(alimentoId);
    map['quantidade'] = Variable<double>(quantidade);
    map['carboidratos'] = Variable<double>(carboidratos);
    map['proteinas'] = Variable<double>(proteinas);
    map['gorduras'] = Variable<double>(gorduras);
    map['calorias'] = Variable<double>(calorias);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItensRefeicaoCompanion toCompanion(bool nullToAbsent) {
    return ItensRefeicaoCompanion(
      id: Value(id),
      refeicaoId: Value(refeicaoId),
      alimentoId: Value(alimentoId),
      quantidade: Value(quantidade),
      carboidratos: Value(carboidratos),
      proteinas: Value(proteinas),
      gorduras: Value(gorduras),
      calorias: Value(calorias),
      createdAt: Value(createdAt),
    );
  }

  factory ItensRefeicaoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItensRefeicaoData(
      id: serializer.fromJson<int>(json['id']),
      refeicaoId: serializer.fromJson<int>(json['refeicaoId']),
      alimentoId: serializer.fromJson<int>(json['alimentoId']),
      quantidade: serializer.fromJson<double>(json['quantidade']),
      carboidratos: serializer.fromJson<double>(json['carboidratos']),
      proteinas: serializer.fromJson<double>(json['proteinas']),
      gorduras: serializer.fromJson<double>(json['gorduras']),
      calorias: serializer.fromJson<double>(json['calorias']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'refeicaoId': serializer.toJson<int>(refeicaoId),
      'alimentoId': serializer.toJson<int>(alimentoId),
      'quantidade': serializer.toJson<double>(quantidade),
      'carboidratos': serializer.toJson<double>(carboidratos),
      'proteinas': serializer.toJson<double>(proteinas),
      'gorduras': serializer.toJson<double>(gorduras),
      'calorias': serializer.toJson<double>(calorias),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ItensRefeicaoData copyWith({
    int? id,
    int? refeicaoId,
    int? alimentoId,
    double? quantidade,
    double? carboidratos,
    double? proteinas,
    double? gorduras,
    double? calorias,
    DateTime? createdAt,
  }) => ItensRefeicaoData(
    id: id ?? this.id,
    refeicaoId: refeicaoId ?? this.refeicaoId,
    alimentoId: alimentoId ?? this.alimentoId,
    quantidade: quantidade ?? this.quantidade,
    carboidratos: carboidratos ?? this.carboidratos,
    proteinas: proteinas ?? this.proteinas,
    gorduras: gorduras ?? this.gorduras,
    calorias: calorias ?? this.calorias,
    createdAt: createdAt ?? this.createdAt,
  );
  ItensRefeicaoData copyWithCompanion(ItensRefeicaoCompanion data) {
    return ItensRefeicaoData(
      id: data.id.present ? data.id.value : this.id,
      refeicaoId:
          data.refeicaoId.present ? data.refeicaoId.value : this.refeicaoId,
      alimentoId:
          data.alimentoId.present ? data.alimentoId.value : this.alimentoId,
      quantidade:
          data.quantidade.present ? data.quantidade.value : this.quantidade,
      carboidratos:
          data.carboidratos.present
              ? data.carboidratos.value
              : this.carboidratos,
      proteinas: data.proteinas.present ? data.proteinas.value : this.proteinas,
      gorduras: data.gorduras.present ? data.gorduras.value : this.gorduras,
      calorias: data.calorias.present ? data.calorias.value : this.calorias,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItensRefeicaoData(')
          ..write('id: $id, ')
          ..write('refeicaoId: $refeicaoId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('quantidade: $quantidade, ')
          ..write('carboidratos: $carboidratos, ')
          ..write('proteinas: $proteinas, ')
          ..write('gorduras: $gorduras, ')
          ..write('calorias: $calorias, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    refeicaoId,
    alimentoId,
    quantidade,
    carboidratos,
    proteinas,
    gorduras,
    calorias,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItensRefeicaoData &&
          other.id == this.id &&
          other.refeicaoId == this.refeicaoId &&
          other.alimentoId == this.alimentoId &&
          other.quantidade == this.quantidade &&
          other.carboidratos == this.carboidratos &&
          other.proteinas == this.proteinas &&
          other.gorduras == this.gorduras &&
          other.calorias == this.calorias &&
          other.createdAt == this.createdAt);
}

class ItensRefeicaoCompanion extends UpdateCompanion<ItensRefeicaoData> {
  final Value<int> id;
  final Value<int> refeicaoId;
  final Value<int> alimentoId;
  final Value<double> quantidade;
  final Value<double> carboidratos;
  final Value<double> proteinas;
  final Value<double> gorduras;
  final Value<double> calorias;
  final Value<DateTime> createdAt;
  const ItensRefeicaoCompanion({
    this.id = const Value.absent(),
    this.refeicaoId = const Value.absent(),
    this.alimentoId = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.carboidratos = const Value.absent(),
    this.proteinas = const Value.absent(),
    this.gorduras = const Value.absent(),
    this.calorias = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItensRefeicaoCompanion.insert({
    this.id = const Value.absent(),
    required int refeicaoId,
    required int alimentoId,
    required double quantidade,
    required double carboidratos,
    required double proteinas,
    required double gorduras,
    required double calorias,
    this.createdAt = const Value.absent(),
  }) : refeicaoId = Value(refeicaoId),
       alimentoId = Value(alimentoId),
       quantidade = Value(quantidade),
       carboidratos = Value(carboidratos),
       proteinas = Value(proteinas),
       gorduras = Value(gorduras),
       calorias = Value(calorias);
  static Insertable<ItensRefeicaoData> custom({
    Expression<int>? id,
    Expression<int>? refeicaoId,
    Expression<int>? alimentoId,
    Expression<double>? quantidade,
    Expression<double>? carboidratos,
    Expression<double>? proteinas,
    Expression<double>? gorduras,
    Expression<double>? calorias,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (refeicaoId != null) 'refeicao_id': refeicaoId,
      if (alimentoId != null) 'alimento_id': alimentoId,
      if (quantidade != null) 'quantidade': quantidade,
      if (carboidratos != null) 'carboidratos': carboidratos,
      if (proteinas != null) 'proteinas': proteinas,
      if (gorduras != null) 'gorduras': gorduras,
      if (calorias != null) 'calorias': calorias,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItensRefeicaoCompanion copyWith({
    Value<int>? id,
    Value<int>? refeicaoId,
    Value<int>? alimentoId,
    Value<double>? quantidade,
    Value<double>? carboidratos,
    Value<double>? proteinas,
    Value<double>? gorduras,
    Value<double>? calorias,
    Value<DateTime>? createdAt,
  }) {
    return ItensRefeicaoCompanion(
      id: id ?? this.id,
      refeicaoId: refeicaoId ?? this.refeicaoId,
      alimentoId: alimentoId ?? this.alimentoId,
      quantidade: quantidade ?? this.quantidade,
      carboidratos: carboidratos ?? this.carboidratos,
      proteinas: proteinas ?? this.proteinas,
      gorduras: gorduras ?? this.gorduras,
      calorias: calorias ?? this.calorias,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (refeicaoId.present) {
      map['refeicao_id'] = Variable<int>(refeicaoId.value);
    }
    if (alimentoId.present) {
      map['alimento_id'] = Variable<int>(alimentoId.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<double>(quantidade.value);
    }
    if (carboidratos.present) {
      map['carboidratos'] = Variable<double>(carboidratos.value);
    }
    if (proteinas.present) {
      map['proteinas'] = Variable<double>(proteinas.value);
    }
    if (gorduras.present) {
      map['gorduras'] = Variable<double>(gorduras.value);
    }
    if (calorias.present) {
      map['calorias'] = Variable<double>(calorias.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItensRefeicaoCompanion(')
          ..write('id: $id, ')
          ..write('refeicaoId: $refeicaoId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('quantidade: $quantidade, ')
          ..write('carboidratos: $carboidratos, ')
          ..write('proteinas: $proteinas, ')
          ..write('gorduras: $gorduras, ')
          ..write('calorias: $calorias, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CacheApiTable extends CacheApi
    with TableInfo<$CacheApiTable, CacheApiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheApiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, data, expiresAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_api';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheApiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheApiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheApiData(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      data:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data'],
          )!,
      expiresAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}expires_at'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $CacheApiTable createAlias(String alias) {
    return $CacheApiTable(attachedDatabase, alias);
  }
}

class CacheApiData extends DataClass implements Insertable<CacheApiData> {
  final String key;
  final String data;
  final DateTime expiresAt;
  final DateTime createdAt;
  const CacheApiData({
    required this.key,
    required this.data,
    required this.expiresAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['data'] = Variable<String>(data);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CacheApiCompanion toCompanion(bool nullToAbsent) {
    return CacheApiCompanion(
      key: Value(key),
      data: Value(data),
      expiresAt: Value(expiresAt),
      createdAt: Value(createdAt),
    );
  }

  factory CacheApiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheApiData(
      key: serializer.fromJson<String>(json['key']),
      data: serializer.fromJson<String>(json['data']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'data': serializer.toJson<String>(data),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CacheApiData copyWith({
    String? key,
    String? data,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) => CacheApiData(
    key: key ?? this.key,
    data: data ?? this.data,
    expiresAt: expiresAt ?? this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
  );
  CacheApiData copyWithCompanion(CacheApiCompanion data) {
    return CacheApiData(
      key: data.key.present ? data.key.value : this.key,
      data: data.data.present ? data.data.value : this.data,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheApiData(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, data, expiresAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheApiData &&
          other.key == this.key &&
          other.data == this.data &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt);
}

class CacheApiCompanion extends UpdateCompanion<CacheApiData> {
  final Value<String> key;
  final Value<String> data;
  final Value<DateTime> expiresAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CacheApiCompanion({
    this.key = const Value.absent(),
    this.data = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheApiCompanion.insert({
    required String key,
    required String data,
    required DateTime expiresAt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       data = Value(data),
       expiresAt = Value(expiresAt);
  static Insertable<CacheApiData> custom({
    Expression<String>? key,
    Expression<String>? data,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (data != null) 'data': data,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheApiCompanion copyWith({
    Value<String>? key,
    Value<String>? data,
    Value<DateTime>? expiresAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CacheApiCompanion(
      key: key ?? this.key,
      data: data ?? this.data,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheApiCompanion(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefeicoesPendentesTable extends RefeicoesPendentes
    with TableInfo<$RefeicoesPendentesTable, RefeicoesPendente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefeicoesPendentesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoRefeicaoMeta = const VerificationMeta(
    'tipoRefeicao',
  );
  @override
  late final GeneratedColumn<String> tipoRefeicao = GeneratedColumn<String>(
    'tipo_refeicao',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataRefeicaoMeta = const VerificationMeta(
    'dataRefeicao',
  );
  @override
  late final GeneratedColumn<String> dataRefeicao = GeneratedColumn<String>(
    'data_refeicao',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itensJsonMeta = const VerificationMeta(
    'itensJson',
  );
  @override
  late final GeneratedColumn<String> itensJson = GeneratedColumn<String>(
    'itens_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncingMeta = const VerificationMeta(
    'isSyncing',
  );
  @override
  late final GeneratedColumn<bool> isSyncing = GeneratedColumn<bool>(
    'is_syncing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_syncing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncAttemptMeta = const VerificationMeta(
    'lastSyncAttempt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAttempt =
      GeneratedColumn<DateTime>(
        'last_sync_attempt',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _syncAttemptsMeta = const VerificationMeta(
    'syncAttempts',
  );
  @override
  late final GeneratedColumn<int> syncAttempts = GeneratedColumn<int>(
    'sync_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoRefeicao,
    dataRefeicao,
    itensJson,
    isSyncing,
    createdAt,
    lastSyncAttempt,
    syncAttempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refeicoes_pendentes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefeicoesPendente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_refeicao')) {
      context.handle(
        _tipoRefeicaoMeta,
        tipoRefeicao.isAcceptableOrUnknown(
          data['tipo_refeicao']!,
          _tipoRefeicaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoRefeicaoMeta);
    }
    if (data.containsKey('data_refeicao')) {
      context.handle(
        _dataRefeicaoMeta,
        dataRefeicao.isAcceptableOrUnknown(
          data['data_refeicao']!,
          _dataRefeicaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataRefeicaoMeta);
    }
    if (data.containsKey('itens_json')) {
      context.handle(
        _itensJsonMeta,
        itensJson.isAcceptableOrUnknown(data['itens_json']!, _itensJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itensJsonMeta);
    }
    if (data.containsKey('is_syncing')) {
      context.handle(
        _isSyncingMeta,
        isSyncing.isAcceptableOrUnknown(data['is_syncing']!, _isSyncingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_sync_attempt')) {
      context.handle(
        _lastSyncAttemptMeta,
        lastSyncAttempt.isAcceptableOrUnknown(
          data['last_sync_attempt']!,
          _lastSyncAttemptMeta,
        ),
      );
    }
    if (data.containsKey('sync_attempts')) {
      context.handle(
        _syncAttemptsMeta,
        syncAttempts.isAcceptableOrUnknown(
          data['sync_attempts']!,
          _syncAttemptsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefeicoesPendente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefeicoesPendente(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      tipoRefeicao:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tipo_refeicao'],
          )!,
      dataRefeicao:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data_refeicao'],
          )!,
      itensJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}itens_json'],
          )!,
      isSyncing:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_syncing'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      lastSyncAttempt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_attempt'],
      ),
      syncAttempts:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sync_attempts'],
          )!,
    );
  }

  @override
  $RefeicoesPendentesTable createAlias(String alias) {
    return $RefeicoesPendentesTable(attachedDatabase, alias);
  }
}

class RefeicoesPendente extends DataClass
    implements Insertable<RefeicoesPendente> {
  final int id;
  final String tipoRefeicao;
  final String dataRefeicao;
  final String itensJson;
  final bool isSyncing;
  final DateTime createdAt;
  final DateTime? lastSyncAttempt;
  final int syncAttempts;
  const RefeicoesPendente({
    required this.id,
    required this.tipoRefeicao,
    required this.dataRefeicao,
    required this.itensJson,
    required this.isSyncing,
    required this.createdAt,
    this.lastSyncAttempt,
    required this.syncAttempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_refeicao'] = Variable<String>(tipoRefeicao);
    map['data_refeicao'] = Variable<String>(dataRefeicao);
    map['itens_json'] = Variable<String>(itensJson);
    map['is_syncing'] = Variable<bool>(isSyncing);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSyncAttempt != null) {
      map['last_sync_attempt'] = Variable<DateTime>(lastSyncAttempt);
    }
    map['sync_attempts'] = Variable<int>(syncAttempts);
    return map;
  }

  RefeicoesPendentesCompanion toCompanion(bool nullToAbsent) {
    return RefeicoesPendentesCompanion(
      id: Value(id),
      tipoRefeicao: Value(tipoRefeicao),
      dataRefeicao: Value(dataRefeicao),
      itensJson: Value(itensJson),
      isSyncing: Value(isSyncing),
      createdAt: Value(createdAt),
      lastSyncAttempt:
          lastSyncAttempt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSyncAttempt),
      syncAttempts: Value(syncAttempts),
    );
  }

  factory RefeicoesPendente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefeicoesPendente(
      id: serializer.fromJson<int>(json['id']),
      tipoRefeicao: serializer.fromJson<String>(json['tipoRefeicao']),
      dataRefeicao: serializer.fromJson<String>(json['dataRefeicao']),
      itensJson: serializer.fromJson<String>(json['itensJson']),
      isSyncing: serializer.fromJson<bool>(json['isSyncing']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSyncAttempt: serializer.fromJson<DateTime?>(json['lastSyncAttempt']),
      syncAttempts: serializer.fromJson<int>(json['syncAttempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoRefeicao': serializer.toJson<String>(tipoRefeicao),
      'dataRefeicao': serializer.toJson<String>(dataRefeicao),
      'itensJson': serializer.toJson<String>(itensJson),
      'isSyncing': serializer.toJson<bool>(isSyncing),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSyncAttempt': serializer.toJson<DateTime?>(lastSyncAttempt),
      'syncAttempts': serializer.toJson<int>(syncAttempts),
    };
  }

  RefeicoesPendente copyWith({
    int? id,
    String? tipoRefeicao,
    String? dataRefeicao,
    String? itensJson,
    bool? isSyncing,
    DateTime? createdAt,
    Value<DateTime?> lastSyncAttempt = const Value.absent(),
    int? syncAttempts,
  }) => RefeicoesPendente(
    id: id ?? this.id,
    tipoRefeicao: tipoRefeicao ?? this.tipoRefeicao,
    dataRefeicao: dataRefeicao ?? this.dataRefeicao,
    itensJson: itensJson ?? this.itensJson,
    isSyncing: isSyncing ?? this.isSyncing,
    createdAt: createdAt ?? this.createdAt,
    lastSyncAttempt:
        lastSyncAttempt.present ? lastSyncAttempt.value : this.lastSyncAttempt,
    syncAttempts: syncAttempts ?? this.syncAttempts,
  );
  RefeicoesPendente copyWithCompanion(RefeicoesPendentesCompanion data) {
    return RefeicoesPendente(
      id: data.id.present ? data.id.value : this.id,
      tipoRefeicao:
          data.tipoRefeicao.present
              ? data.tipoRefeicao.value
              : this.tipoRefeicao,
      dataRefeicao:
          data.dataRefeicao.present
              ? data.dataRefeicao.value
              : this.dataRefeicao,
      itensJson: data.itensJson.present ? data.itensJson.value : this.itensJson,
      isSyncing: data.isSyncing.present ? data.isSyncing.value : this.isSyncing,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSyncAttempt:
          data.lastSyncAttempt.present
              ? data.lastSyncAttempt.value
              : this.lastSyncAttempt,
      syncAttempts:
          data.syncAttempts.present
              ? data.syncAttempts.value
              : this.syncAttempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefeicoesPendente(')
          ..write('id: $id, ')
          ..write('tipoRefeicao: $tipoRefeicao, ')
          ..write('dataRefeicao: $dataRefeicao, ')
          ..write('itensJson: $itensJson, ')
          ..write('isSyncing: $isSyncing, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAttempt: $lastSyncAttempt, ')
          ..write('syncAttempts: $syncAttempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipoRefeicao,
    dataRefeicao,
    itensJson,
    isSyncing,
    createdAt,
    lastSyncAttempt,
    syncAttempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefeicoesPendente &&
          other.id == this.id &&
          other.tipoRefeicao == this.tipoRefeicao &&
          other.dataRefeicao == this.dataRefeicao &&
          other.itensJson == this.itensJson &&
          other.isSyncing == this.isSyncing &&
          other.createdAt == this.createdAt &&
          other.lastSyncAttempt == this.lastSyncAttempt &&
          other.syncAttempts == this.syncAttempts);
}

class RefeicoesPendentesCompanion extends UpdateCompanion<RefeicoesPendente> {
  final Value<int> id;
  final Value<String> tipoRefeicao;
  final Value<String> dataRefeicao;
  final Value<String> itensJson;
  final Value<bool> isSyncing;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSyncAttempt;
  final Value<int> syncAttempts;
  const RefeicoesPendentesCompanion({
    this.id = const Value.absent(),
    this.tipoRefeicao = const Value.absent(),
    this.dataRefeicao = const Value.absent(),
    this.itensJson = const Value.absent(),
    this.isSyncing = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSyncAttempt = const Value.absent(),
    this.syncAttempts = const Value.absent(),
  });
  RefeicoesPendentesCompanion.insert({
    this.id = const Value.absent(),
    required String tipoRefeicao,
    required String dataRefeicao,
    required String itensJson,
    this.isSyncing = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSyncAttempt = const Value.absent(),
    this.syncAttempts = const Value.absent(),
  }) : tipoRefeicao = Value(tipoRefeicao),
       dataRefeicao = Value(dataRefeicao),
       itensJson = Value(itensJson);
  static Insertable<RefeicoesPendente> custom({
    Expression<int>? id,
    Expression<String>? tipoRefeicao,
    Expression<String>? dataRefeicao,
    Expression<String>? itensJson,
    Expression<bool>? isSyncing,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSyncAttempt,
    Expression<int>? syncAttempts,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoRefeicao != null) 'tipo_refeicao': tipoRefeicao,
      if (dataRefeicao != null) 'data_refeicao': dataRefeicao,
      if (itensJson != null) 'itens_json': itensJson,
      if (isSyncing != null) 'is_syncing': isSyncing,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSyncAttempt != null) 'last_sync_attempt': lastSyncAttempt,
      if (syncAttempts != null) 'sync_attempts': syncAttempts,
    });
  }

  RefeicoesPendentesCompanion copyWith({
    Value<int>? id,
    Value<String>? tipoRefeicao,
    Value<String>? dataRefeicao,
    Value<String>? itensJson,
    Value<bool>? isSyncing,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSyncAttempt,
    Value<int>? syncAttempts,
  }) {
    return RefeicoesPendentesCompanion(
      id: id ?? this.id,
      tipoRefeicao: tipoRefeicao ?? this.tipoRefeicao,
      dataRefeicao: dataRefeicao ?? this.dataRefeicao,
      itensJson: itensJson ?? this.itensJson,
      isSyncing: isSyncing ?? this.isSyncing,
      createdAt: createdAt ?? this.createdAt,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      syncAttempts: syncAttempts ?? this.syncAttempts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoRefeicao.present) {
      map['tipo_refeicao'] = Variable<String>(tipoRefeicao.value);
    }
    if (dataRefeicao.present) {
      map['data_refeicao'] = Variable<String>(dataRefeicao.value);
    }
    if (itensJson.present) {
      map['itens_json'] = Variable<String>(itensJson.value);
    }
    if (isSyncing.present) {
      map['is_syncing'] = Variable<bool>(isSyncing.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSyncAttempt.present) {
      map['last_sync_attempt'] = Variable<DateTime>(lastSyncAttempt.value);
    }
    if (syncAttempts.present) {
      map['sync_attempts'] = Variable<int>(syncAttempts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefeicoesPendentesCompanion(')
          ..write('id: $id, ')
          ..write('tipoRefeicao: $tipoRefeicao, ')
          ..write('dataRefeicao: $dataRefeicao, ')
          ..write('itensJson: $itensJson, ')
          ..write('isSyncing: $isSyncing, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAttempt: $lastSyncAttempt, ')
          ..write('syncAttempts: $syncAttempts')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlimentosTable alimentos = $AlimentosTable(this);
  late final $RefeicoesTable refeicoes = $RefeicoesTable(this);
  late final $ItensRefeicaoTable itensRefeicao = $ItensRefeicaoTable(this);
  late final $CacheApiTable cacheApi = $CacheApiTable(this);
  late final $RefeicoesPendentesTable refeicoesPendentes =
      $RefeicoesPendentesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    alimentos,
    refeicoes,
    itensRefeicao,
    cacheApi,
    refeicoesPendentes,
  ];
}

typedef $$AlimentosTableCreateCompanionBuilder =
    AlimentosCompanion Function({
      Value<int> id,
      required String nome,
      required String categoria,
      required double carboidratos,
      required double proteinas,
      required double gorduras,
      required double calorias,
      Value<double?> indiceCagemicoGlicemico,
      Value<bool> isFavorito,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$AlimentosTableUpdateCompanionBuilder =
    AlimentosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> categoria,
      Value<double> carboidratos,
      Value<double> proteinas,
      Value<double> gorduras,
      Value<double> calorias,
      Value<double?> indiceCagemicoGlicemico,
      Value<bool> isFavorito,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$AlimentosTableReferences
    extends BaseReferences<_$AppDatabase, $AlimentosTable, Alimento> {
  $$AlimentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItensRefeicaoTable, List<ItensRefeicaoData>>
  _itensRefeicaoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensRefeicao,
    aliasName: $_aliasNameGenerator(
      db.alimentos.id,
      db.itensRefeicao.alimentoId,
    ),
  );

  $$ItensRefeicaoTableProcessedTableManager get itensRefeicaoRefs {
    final manager = $$ItensRefeicaoTableTableManager(
      $_db,
      $_db.itensRefeicao,
    ).filter((f) => f.alimentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itensRefeicaoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlimentosTableFilterComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinas => $composableBuilder(
    column: $table.proteinas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gorduras => $composableBuilder(
    column: $table.gorduras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calorias => $composableBuilder(
    column: $table.calorias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get indiceCagemicoGlicemico => $composableBuilder(
    column: $table.indiceCagemicoGlicemico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorito => $composableBuilder(
    column: $table.isFavorito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itensRefeicaoRefs(
    Expression<bool> Function($$ItensRefeicaoTableFilterComposer f) f,
  ) {
    final $$ItensRefeicaoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensRefeicao,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensRefeicaoTableFilterComposer(
            $db: $db,
            $table: $db.itensRefeicao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlimentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinas => $composableBuilder(
    column: $table.proteinas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gorduras => $composableBuilder(
    column: $table.gorduras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calorias => $composableBuilder(
    column: $table.calorias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get indiceCagemicoGlicemico => $composableBuilder(
    column: $table.indiceCagemicoGlicemico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorito => $composableBuilder(
    column: $table.isFavorito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlimentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinas =>
      $composableBuilder(column: $table.proteinas, builder: (column) => column);

  GeneratedColumn<double> get gorduras =>
      $composableBuilder(column: $table.gorduras, builder: (column) => column);

  GeneratedColumn<double> get calorias =>
      $composableBuilder(column: $table.calorias, builder: (column) => column);

  GeneratedColumn<double> get indiceCagemicoGlicemico => $composableBuilder(
    column: $table.indiceCagemicoGlicemico,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorito => $composableBuilder(
    column: $table.isFavorito,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> itensRefeicaoRefs<T extends Object>(
    Expression<T> Function($$ItensRefeicaoTableAnnotationComposer a) f,
  ) {
    final $$ItensRefeicaoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensRefeicao,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensRefeicaoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensRefeicao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlimentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlimentosTable,
          Alimento,
          $$AlimentosTableFilterComposer,
          $$AlimentosTableOrderingComposer,
          $$AlimentosTableAnnotationComposer,
          $$AlimentosTableCreateCompanionBuilder,
          $$AlimentosTableUpdateCompanionBuilder,
          (Alimento, $$AlimentosTableReferences),
          Alimento,
          PrefetchHooks Function({bool itensRefeicaoRefs})
        > {
  $$AlimentosTableTableManager(_$AppDatabase db, $AlimentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AlimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<double> carboidratos = const Value.absent(),
                Value<double> proteinas = const Value.absent(),
                Value<double> gorduras = const Value.absent(),
                Value<double> calorias = const Value.absent(),
                Value<double?> indiceCagemicoGlicemico = const Value.absent(),
                Value<bool> isFavorito = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AlimentosCompanion(
                id: id,
                nome: nome,
                categoria: categoria,
                carboidratos: carboidratos,
                proteinas: proteinas,
                gorduras: gorduras,
                calorias: calorias,
                indiceCagemicoGlicemico: indiceCagemicoGlicemico,
                isFavorito: isFavorito,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String categoria,
                required double carboidratos,
                required double proteinas,
                required double gorduras,
                required double calorias,
                Value<double?> indiceCagemicoGlicemico = const Value.absent(),
                Value<bool> isFavorito = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AlimentosCompanion.insert(
                id: id,
                nome: nome,
                categoria: categoria,
                carboidratos: carboidratos,
                proteinas: proteinas,
                gorduras: gorduras,
                calorias: calorias,
                indiceCagemicoGlicemico: indiceCagemicoGlicemico,
                isFavorito: isFavorito,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AlimentosTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({itensRefeicaoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (itensRefeicaoRefs) db.itensRefeicao,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itensRefeicaoRefs)
                    await $_getPrefetchedData<
                      Alimento,
                      $AlimentosTable,
                      ItensRefeicaoData
                    >(
                      currentTable: table,
                      referencedTable: $$AlimentosTableReferences
                          ._itensRefeicaoRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AlimentosTableReferences(
                                db,
                                table,
                                p0,
                              ).itensRefeicaoRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.alimentoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlimentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlimentosTable,
      Alimento,
      $$AlimentosTableFilterComposer,
      $$AlimentosTableOrderingComposer,
      $$AlimentosTableAnnotationComposer,
      $$AlimentosTableCreateCompanionBuilder,
      $$AlimentosTableUpdateCompanionBuilder,
      (Alimento, $$AlimentosTableReferences),
      Alimento,
      PrefetchHooks Function({bool itensRefeicaoRefs})
    >;
typedef $$RefeicoesTableCreateCompanionBuilder =
    RefeicoesCompanion Function({
      Value<int> id,
      required String nome,
      required String tipo,
      required DateTime dataHora,
      Value<double> totalCarboidratos,
      Value<double> totalProteinas,
      Value<double> totalGorduras,
      Value<double> totalCalorias,
      Value<String?> observacoes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RefeicoesTableUpdateCompanionBuilder =
    RefeicoesCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> tipo,
      Value<DateTime> dataHora,
      Value<double> totalCarboidratos,
      Value<double> totalProteinas,
      Value<double> totalGorduras,
      Value<double> totalCalorias,
      Value<String?> observacoes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RefeicoesTableReferences
    extends BaseReferences<_$AppDatabase, $RefeicoesTable, Refeicoe> {
  $$RefeicoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItensRefeicaoTable, List<ItensRefeicaoData>>
  _itensRefeicaoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensRefeicao,
    aliasName: $_aliasNameGenerator(
      db.refeicoes.id,
      db.itensRefeicao.refeicaoId,
    ),
  );

  $$ItensRefeicaoTableProcessedTableManager get itensRefeicaoRefs {
    final manager = $$ItensRefeicaoTableTableManager(
      $_db,
      $_db.itensRefeicao,
    ).filter((f) => f.refeicaoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itensRefeicaoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RefeicoesTableFilterComposer
    extends Composer<_$AppDatabase, $RefeicoesTable> {
  $$RefeicoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarboidratos => $composableBuilder(
    column: $table.totalCarboidratos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProteinas => $composableBuilder(
    column: $table.totalProteinas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalGorduras => $composableBuilder(
    column: $table.totalGorduras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCalorias => $composableBuilder(
    column: $table.totalCalorias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itensRefeicaoRefs(
    Expression<bool> Function($$ItensRefeicaoTableFilterComposer f) f,
  ) {
    final $$ItensRefeicaoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensRefeicao,
      getReferencedColumn: (t) => t.refeicaoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensRefeicaoTableFilterComposer(
            $db: $db,
            $table: $db.itensRefeicao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RefeicoesTableOrderingComposer
    extends Composer<_$AppDatabase, $RefeicoesTable> {
  $$RefeicoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarboidratos => $composableBuilder(
    column: $table.totalCarboidratos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProteinas => $composableBuilder(
    column: $table.totalProteinas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalGorduras => $composableBuilder(
    column: $table.totalGorduras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCalorias => $composableBuilder(
    column: $table.totalCalorias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RefeicoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefeicoesTable> {
  $$RefeicoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<double> get totalCarboidratos => $composableBuilder(
    column: $table.totalCarboidratos,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProteinas => $composableBuilder(
    column: $table.totalProteinas,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalGorduras => $composableBuilder(
    column: $table.totalGorduras,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCalorias => $composableBuilder(
    column: $table.totalCalorias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> itensRefeicaoRefs<T extends Object>(
    Expression<T> Function($$ItensRefeicaoTableAnnotationComposer a) f,
  ) {
    final $$ItensRefeicaoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensRefeicao,
      getReferencedColumn: (t) => t.refeicaoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensRefeicaoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensRefeicao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RefeicoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefeicoesTable,
          Refeicoe,
          $$RefeicoesTableFilterComposer,
          $$RefeicoesTableOrderingComposer,
          $$RefeicoesTableAnnotationComposer,
          $$RefeicoesTableCreateCompanionBuilder,
          $$RefeicoesTableUpdateCompanionBuilder,
          (Refeicoe, $$RefeicoesTableReferences),
          Refeicoe,
          PrefetchHooks Function({bool itensRefeicaoRefs})
        > {
  $$RefeicoesTableTableManager(_$AppDatabase db, $RefeicoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RefeicoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RefeicoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RefeicoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<double> totalCarboidratos = const Value.absent(),
                Value<double> totalProteinas = const Value.absent(),
                Value<double> totalGorduras = const Value.absent(),
                Value<double> totalCalorias = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RefeicoesCompanion(
                id: id,
                nome: nome,
                tipo: tipo,
                dataHora: dataHora,
                totalCarboidratos: totalCarboidratos,
                totalProteinas: totalProteinas,
                totalGorduras: totalGorduras,
                totalCalorias: totalCalorias,
                observacoes: observacoes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String tipo,
                required DateTime dataHora,
                Value<double> totalCarboidratos = const Value.absent(),
                Value<double> totalProteinas = const Value.absent(),
                Value<double> totalGorduras = const Value.absent(),
                Value<double> totalCalorias = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RefeicoesCompanion.insert(
                id: id,
                nome: nome,
                tipo: tipo,
                dataHora: dataHora,
                totalCarboidratos: totalCarboidratos,
                totalProteinas: totalProteinas,
                totalGorduras: totalGorduras,
                totalCalorias: totalCalorias,
                observacoes: observacoes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RefeicoesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({itensRefeicaoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (itensRefeicaoRefs) db.itensRefeicao,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itensRefeicaoRefs)
                    await $_getPrefetchedData<
                      Refeicoe,
                      $RefeicoesTable,
                      ItensRefeicaoData
                    >(
                      currentTable: table,
                      referencedTable: $$RefeicoesTableReferences
                          ._itensRefeicaoRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RefeicoesTableReferences(
                                db,
                                table,
                                p0,
                              ).itensRefeicaoRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.refeicaoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RefeicoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefeicoesTable,
      Refeicoe,
      $$RefeicoesTableFilterComposer,
      $$RefeicoesTableOrderingComposer,
      $$RefeicoesTableAnnotationComposer,
      $$RefeicoesTableCreateCompanionBuilder,
      $$RefeicoesTableUpdateCompanionBuilder,
      (Refeicoe, $$RefeicoesTableReferences),
      Refeicoe,
      PrefetchHooks Function({bool itensRefeicaoRefs})
    >;
typedef $$ItensRefeicaoTableCreateCompanionBuilder =
    ItensRefeicaoCompanion Function({
      Value<int> id,
      required int refeicaoId,
      required int alimentoId,
      required double quantidade,
      required double carboidratos,
      required double proteinas,
      required double gorduras,
      required double calorias,
      Value<DateTime> createdAt,
    });
typedef $$ItensRefeicaoTableUpdateCompanionBuilder =
    ItensRefeicaoCompanion Function({
      Value<int> id,
      Value<int> refeicaoId,
      Value<int> alimentoId,
      Value<double> quantidade,
      Value<double> carboidratos,
      Value<double> proteinas,
      Value<double> gorduras,
      Value<double> calorias,
      Value<DateTime> createdAt,
    });

final class $$ItensRefeicaoTableReferences
    extends
        BaseReferences<_$AppDatabase, $ItensRefeicaoTable, ItensRefeicaoData> {
  $$ItensRefeicaoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RefeicoesTable _refeicaoIdTable(_$AppDatabase db) =>
      db.refeicoes.createAlias(
        $_aliasNameGenerator(db.itensRefeicao.refeicaoId, db.refeicoes.id),
      );

  $$RefeicoesTableProcessedTableManager get refeicaoId {
    final $_column = $_itemColumn<int>('refeicao_id')!;

    final manager = $$RefeicoesTableTableManager(
      $_db,
      $_db.refeicoes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_refeicaoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AlimentosTable _alimentoIdTable(_$AppDatabase db) =>
      db.alimentos.createAlias(
        $_aliasNameGenerator(db.itensRefeicao.alimentoId, db.alimentos.id),
      );

  $$AlimentosTableProcessedTableManager get alimentoId {
    final $_column = $_itemColumn<int>('alimento_id')!;

    final manager = $$AlimentosTableTableManager(
      $_db,
      $_db.alimentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alimentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItensRefeicaoTableFilterComposer
    extends Composer<_$AppDatabase, $ItensRefeicaoTable> {
  $$ItensRefeicaoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinas => $composableBuilder(
    column: $table.proteinas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gorduras => $composableBuilder(
    column: $table.gorduras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calorias => $composableBuilder(
    column: $table.calorias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RefeicoesTableFilterComposer get refeicaoId {
    final $$RefeicoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refeicaoId,
      referencedTable: $db.refeicoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefeicoesTableFilterComposer(
            $db: $db,
            $table: $db.refeicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableFilterComposer get alimentoId {
    final $$AlimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableFilterComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensRefeicaoTableOrderingComposer
    extends Composer<_$AppDatabase, $ItensRefeicaoTable> {
  $$ItensRefeicaoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinas => $composableBuilder(
    column: $table.proteinas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gorduras => $composableBuilder(
    column: $table.gorduras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calorias => $composableBuilder(
    column: $table.calorias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RefeicoesTableOrderingComposer get refeicaoId {
    final $$RefeicoesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refeicaoId,
      referencedTable: $db.refeicoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefeicoesTableOrderingComposer(
            $db: $db,
            $table: $db.refeicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableOrderingComposer get alimentoId {
    final $$AlimentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableOrderingComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensRefeicaoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItensRefeicaoTable> {
  $$ItensRefeicaoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carboidratos => $composableBuilder(
    column: $table.carboidratos,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinas =>
      $composableBuilder(column: $table.proteinas, builder: (column) => column);

  GeneratedColumn<double> get gorduras =>
      $composableBuilder(column: $table.gorduras, builder: (column) => column);

  GeneratedColumn<double> get calorias =>
      $composableBuilder(column: $table.calorias, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RefeicoesTableAnnotationComposer get refeicaoId {
    final $$RefeicoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refeicaoId,
      referencedTable: $db.refeicoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefeicoesTableAnnotationComposer(
            $db: $db,
            $table: $db.refeicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableAnnotationComposer get alimentoId {
    final $$AlimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensRefeicaoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItensRefeicaoTable,
          ItensRefeicaoData,
          $$ItensRefeicaoTableFilterComposer,
          $$ItensRefeicaoTableOrderingComposer,
          $$ItensRefeicaoTableAnnotationComposer,
          $$ItensRefeicaoTableCreateCompanionBuilder,
          $$ItensRefeicaoTableUpdateCompanionBuilder,
          (ItensRefeicaoData, $$ItensRefeicaoTableReferences),
          ItensRefeicaoData,
          PrefetchHooks Function({bool refeicaoId, bool alimentoId})
        > {
  $$ItensRefeicaoTableTableManager(_$AppDatabase db, $ItensRefeicaoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ItensRefeicaoTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ItensRefeicaoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ItensRefeicaoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> refeicaoId = const Value.absent(),
                Value<int> alimentoId = const Value.absent(),
                Value<double> quantidade = const Value.absent(),
                Value<double> carboidratos = const Value.absent(),
                Value<double> proteinas = const Value.absent(),
                Value<double> gorduras = const Value.absent(),
                Value<double> calorias = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItensRefeicaoCompanion(
                id: id,
                refeicaoId: refeicaoId,
                alimentoId: alimentoId,
                quantidade: quantidade,
                carboidratos: carboidratos,
                proteinas: proteinas,
                gorduras: gorduras,
                calorias: calorias,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int refeicaoId,
                required int alimentoId,
                required double quantidade,
                required double carboidratos,
                required double proteinas,
                required double gorduras,
                required double calorias,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItensRefeicaoCompanion.insert(
                id: id,
                refeicaoId: refeicaoId,
                alimentoId: alimentoId,
                quantidade: quantidade,
                carboidratos: carboidratos,
                proteinas: proteinas,
                gorduras: gorduras,
                calorias: calorias,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ItensRefeicaoTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({refeicaoId = false, alimentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (refeicaoId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.refeicaoId,
                            referencedTable: $$ItensRefeicaoTableReferences
                                ._refeicaoIdTable(db),
                            referencedColumn:
                                $$ItensRefeicaoTableReferences
                                    ._refeicaoIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (alimentoId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.alimentoId,
                            referencedTable: $$ItensRefeicaoTableReferences
                                ._alimentoIdTable(db),
                            referencedColumn:
                                $$ItensRefeicaoTableReferences
                                    ._alimentoIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItensRefeicaoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItensRefeicaoTable,
      ItensRefeicaoData,
      $$ItensRefeicaoTableFilterComposer,
      $$ItensRefeicaoTableOrderingComposer,
      $$ItensRefeicaoTableAnnotationComposer,
      $$ItensRefeicaoTableCreateCompanionBuilder,
      $$ItensRefeicaoTableUpdateCompanionBuilder,
      (ItensRefeicaoData, $$ItensRefeicaoTableReferences),
      ItensRefeicaoData,
      PrefetchHooks Function({bool refeicaoId, bool alimentoId})
    >;
typedef $$CacheApiTableCreateCompanionBuilder =
    CacheApiCompanion Function({
      required String key,
      required String data,
      required DateTime expiresAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CacheApiTableUpdateCompanionBuilder =
    CacheApiCompanion Function({
      Value<String> key,
      Value<String> data,
      Value<DateTime> expiresAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CacheApiTableFilterComposer
    extends Composer<_$AppDatabase, $CacheApiTable> {
  $$CacheApiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheApiTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheApiTable> {
  $$CacheApiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheApiTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheApiTable> {
  $$CacheApiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CacheApiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheApiTable,
          CacheApiData,
          $$CacheApiTableFilterComposer,
          $$CacheApiTableOrderingComposer,
          $$CacheApiTableAnnotationComposer,
          $$CacheApiTableCreateCompanionBuilder,
          $$CacheApiTableUpdateCompanionBuilder,
          (
            CacheApiData,
            BaseReferences<_$AppDatabase, $CacheApiTable, CacheApiData>,
          ),
          CacheApiData,
          PrefetchHooks Function()
        > {
  $$CacheApiTableTableManager(_$AppDatabase db, $CacheApiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CacheApiTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CacheApiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CacheApiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheApiCompanion(
                key: key,
                data: data,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String data,
                required DateTime expiresAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheApiCompanion.insert(
                key: key,
                data: data,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheApiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheApiTable,
      CacheApiData,
      $$CacheApiTableFilterComposer,
      $$CacheApiTableOrderingComposer,
      $$CacheApiTableAnnotationComposer,
      $$CacheApiTableCreateCompanionBuilder,
      $$CacheApiTableUpdateCompanionBuilder,
      (
        CacheApiData,
        BaseReferences<_$AppDatabase, $CacheApiTable, CacheApiData>,
      ),
      CacheApiData,
      PrefetchHooks Function()
    >;
typedef $$RefeicoesPendentesTableCreateCompanionBuilder =
    RefeicoesPendentesCompanion Function({
      Value<int> id,
      required String tipoRefeicao,
      required String dataRefeicao,
      required String itensJson,
      Value<bool> isSyncing,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSyncAttempt,
      Value<int> syncAttempts,
    });
typedef $$RefeicoesPendentesTableUpdateCompanionBuilder =
    RefeicoesPendentesCompanion Function({
      Value<int> id,
      Value<String> tipoRefeicao,
      Value<String> dataRefeicao,
      Value<String> itensJson,
      Value<bool> isSyncing,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSyncAttempt,
      Value<int> syncAttempts,
    });

class $$RefeicoesPendentesTableFilterComposer
    extends Composer<_$AppDatabase, $RefeicoesPendentesTable> {
  $$RefeicoesPendentesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoRefeicao => $composableBuilder(
    column: $table.tipoRefeicao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataRefeicao => $composableBuilder(
    column: $table.dataRefeicao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itensJson => $composableBuilder(
    column: $table.itensJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSyncing => $composableBuilder(
    column: $table.isSyncing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAttempt => $composableBuilder(
    column: $table.lastSyncAttempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RefeicoesPendentesTableOrderingComposer
    extends Composer<_$AppDatabase, $RefeicoesPendentesTable> {
  $$RefeicoesPendentesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoRefeicao => $composableBuilder(
    column: $table.tipoRefeicao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataRefeicao => $composableBuilder(
    column: $table.dataRefeicao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itensJson => $composableBuilder(
    column: $table.itensJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSyncing => $composableBuilder(
    column: $table.isSyncing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAttempt => $composableBuilder(
    column: $table.lastSyncAttempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RefeicoesPendentesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefeicoesPendentesTable> {
  $$RefeicoesPendentesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoRefeicao => $composableBuilder(
    column: $table.tipoRefeicao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dataRefeicao => $composableBuilder(
    column: $table.dataRefeicao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itensJson =>
      $composableBuilder(column: $table.itensJson, builder: (column) => column);

  GeneratedColumn<bool> get isSyncing =>
      $composableBuilder(column: $table.isSyncing, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAttempt => $composableBuilder(
    column: $table.lastSyncAttempt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => column,
  );
}

class $$RefeicoesPendentesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefeicoesPendentesTable,
          RefeicoesPendente,
          $$RefeicoesPendentesTableFilterComposer,
          $$RefeicoesPendentesTableOrderingComposer,
          $$RefeicoesPendentesTableAnnotationComposer,
          $$RefeicoesPendentesTableCreateCompanionBuilder,
          $$RefeicoesPendentesTableUpdateCompanionBuilder,
          (
            RefeicoesPendente,
            BaseReferences<
              _$AppDatabase,
              $RefeicoesPendentesTable,
              RefeicoesPendente
            >,
          ),
          RefeicoesPendente,
          PrefetchHooks Function()
        > {
  $$RefeicoesPendentesTableTableManager(
    _$AppDatabase db,
    $RefeicoesPendentesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RefeicoesPendentesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$RefeicoesPendentesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$RefeicoesPendentesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tipoRefeicao = const Value.absent(),
                Value<String> dataRefeicao = const Value.absent(),
                Value<String> itensJson = const Value.absent(),
                Value<bool> isSyncing = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSyncAttempt = const Value.absent(),
                Value<int> syncAttempts = const Value.absent(),
              }) => RefeicoesPendentesCompanion(
                id: id,
                tipoRefeicao: tipoRefeicao,
                dataRefeicao: dataRefeicao,
                itensJson: itensJson,
                isSyncing: isSyncing,
                createdAt: createdAt,
                lastSyncAttempt: lastSyncAttempt,
                syncAttempts: syncAttempts,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tipoRefeicao,
                required String dataRefeicao,
                required String itensJson,
                Value<bool> isSyncing = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSyncAttempt = const Value.absent(),
                Value<int> syncAttempts = const Value.absent(),
              }) => RefeicoesPendentesCompanion.insert(
                id: id,
                tipoRefeicao: tipoRefeicao,
                dataRefeicao: dataRefeicao,
                itensJson: itensJson,
                isSyncing: isSyncing,
                createdAt: createdAt,
                lastSyncAttempt: lastSyncAttempt,
                syncAttempts: syncAttempts,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RefeicoesPendentesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefeicoesPendentesTable,
      RefeicoesPendente,
      $$RefeicoesPendentesTableFilterComposer,
      $$RefeicoesPendentesTableOrderingComposer,
      $$RefeicoesPendentesTableAnnotationComposer,
      $$RefeicoesPendentesTableCreateCompanionBuilder,
      $$RefeicoesPendentesTableUpdateCompanionBuilder,
      (
        RefeicoesPendente,
        BaseReferences<
          _$AppDatabase,
          $RefeicoesPendentesTable,
          RefeicoesPendente
        >,
      ),
      RefeicoesPendente,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlimentosTableTableManager get alimentos =>
      $$AlimentosTableTableManager(_db, _db.alimentos);
  $$RefeicoesTableTableManager get refeicoes =>
      $$RefeicoesTableTableManager(_db, _db.refeicoes);
  $$ItensRefeicaoTableTableManager get itensRefeicao =>
      $$ItensRefeicaoTableTableManager(_db, _db.itensRefeicao);
  $$CacheApiTableTableManager get cacheApi =>
      $$CacheApiTableTableManager(_db, _db.cacheApi);
  $$RefeicoesPendentesTableTableManager get refeicoesPendentes =>
      $$RefeicoesPendentesTableTableManager(_db, _db.refeicoesPendentes);
}

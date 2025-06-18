// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refeicao_pendente_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefeicaoPendenteModel _$RefeicaoPendenteModelFromJson(
  Map<String, dynamic> json,
) => RefeicaoPendenteModel(
  id: (json['id'] as num?)?.toInt(),
  tipoRefeicao: json['tipo_refeicao'] as String,
  dataRefeicao: json['data_refeicao'] as String,
  itens:
      (json['itens'] as List<dynamic>)
          .map(
            (e) =>
                ItemRefeicaoPendenteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  createdAt: json['created_at'] as String,
  isSyncing: json['is_syncing'] as bool? ?? false,
);

Map<String, dynamic> _$RefeicaoPendenteModelToJson(
  RefeicaoPendenteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tipo_refeicao': instance.tipoRefeicao,
  'data_refeicao': instance.dataRefeicao,
  'itens': instance.itens,
  'created_at': instance.createdAt,
  'is_syncing': instance.isSyncing,
};

ItemRefeicaoPendenteModel _$ItemRefeicaoPendenteModelFromJson(
  Map<String, dynamic> json,
) => ItemRefeicaoPendenteModel(
  alimentoId: (json['alimento_id'] as num).toInt(),
  quantidadeBase: (json['quantidade_base'] as num).toDouble(),
);

Map<String, dynamic> _$ItemRefeicaoPendenteModelToJson(
  ItemRefeicaoPendenteModel instance,
) => <String, dynamic>{
  'alimento_id': instance.alimentoId,
  'quantidade_base': instance.quantidadeBase,
};

RefeicaoApiRequestModel _$RefeicaoApiRequestModelFromJson(
  Map<String, dynamic> json,
) => RefeicaoApiRequestModel(
  tipoRefeicao: json['tipo_refeicao'] as String,
  dataRefeicao: json['data_refeicao'] as String,
  itens:
      (json['itens'] as List<dynamic>)
          .map((e) => ItemRefeicaoApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RefeicaoApiRequestModelToJson(
  RefeicaoApiRequestModel instance,
) => <String, dynamic>{
  'tipo_refeicao': instance.tipoRefeicao,
  'data_refeicao': instance.dataRefeicao,
  'itens': instance.itens,
};

ItemRefeicaoApiModel _$ItemRefeicaoApiModelFromJson(
  Map<String, dynamic> json,
) => ItemRefeicaoApiModel(
  alimentoId: (json['alimento_id'] as num).toInt(),
  quantidadeBase: (json['quantidade_base'] as num).toDouble(),
);

Map<String, dynamic> _$ItemRefeicaoApiModelToJson(
  ItemRefeicaoApiModel instance,
) => <String, dynamic>{
  'alimento_id': instance.alimentoId,
  'quantidade_base': instance.quantidadeBase,
};

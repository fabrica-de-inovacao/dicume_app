// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refeicao_do_dia_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefeicaoDoDiaModel _$RefeicaoDoDiaModelFromJson(Map<String, dynamic> json) =>
    RefeicaoDoDiaModel(
      id: json['id'] as String,
      tipoRefeicao: json['tipo_refeicao'] as String,
      classificacaoFinal: json['classificacao_final'] as String,
      itens:
          (json['itens'] as List<dynamic>)
              .map(
                (e) =>
                    ItemRefeicaoDoDiaModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$RefeicaoDoDiaModelToJson(RefeicaoDoDiaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo_refeicao': instance.tipoRefeicao,
      'classificacao_final': instance.classificacaoFinal,
      'itens': instance.itens,
    };

ItemRefeicaoDoDiaModel _$ItemRefeicaoDoDiaModelFromJson(
  Map<String, dynamic> json,
) => ItemRefeicaoDoDiaModel(
  alimentos: AlimentoRefeicaoDoDiaModel.fromJson(
    json['alimentos'] as Map<String, dynamic>,
  ),
  quantidadeBase: (json['quantidade_base'] as num).toInt(),
);

Map<String, dynamic> _$ItemRefeicaoDoDiaModelToJson(
  ItemRefeicaoDoDiaModel instance,
) => <String, dynamic>{
  'alimentos': instance.alimentos,
  'quantidade_base': instance.quantidadeBase,
};

AlimentoRefeicaoDoDiaModel _$AlimentoRefeicaoDoDiaModelFromJson(
  Map<String, dynamic> json,
) => AlimentoRefeicaoDoDiaModel(
  nomePopular: json['nome_popular'] as String,
  fotoPorcaoUrl: json['foto_porcao_url'] as String,
  recomendacaoConsumo: json['recomendacao_consumo'] as String,
);

Map<String, dynamic> _$AlimentoRefeicaoDoDiaModelToJson(
  AlimentoRefeicaoDoDiaModel instance,
) => <String, dynamic>{
  'nome_popular': instance.nomePopular,
  'foto_porcao_url': instance.fotoPorcaoUrl,
  'recomendacao_consumo': instance.recomendacaoConsumo,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlimentoModel _$AlimentoModelFromJson(Map<String, dynamic> json) =>
    AlimentoModel(
      id: (json['id'] as num).toInt(),
      nomePopular: json['nome_popular'] as String,
      grupoDicume: json['grupo_dicume'] as String,
      classificacaoCor: json['classificacao_cor'] as String,
      recomendacaoConsumo: json['recomendacao_consumo'] as String,
      fotoPorcaoUrl: json['foto_porcao_url'] as String,
      grupoNutricional: json['grupo_nutricional'] as String,
      igClassificacao: json['ig_classificacao'] as String,
      guiaAlimentarClass: json['guia_alimentar_class'] as String,
    );

Map<String, dynamic> _$AlimentoModelToJson(AlimentoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome_popular': instance.nomePopular,
      'grupo_dicume': instance.grupoDicume,
      'classificacao_cor': instance.classificacaoCor,
      'recomendacao_consumo': instance.recomendacaoConsumo,
      'foto_porcao_url': instance.fotoPorcaoUrl,
      'grupo_nutricional': instance.grupoNutricional,
      'ig_classificacao': instance.igClassificacao,
      'guia_alimentar_class': instance.guiaAlimentarClass,
    };

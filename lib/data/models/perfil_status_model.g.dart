// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerfilStatusModel _$PerfilStatusModelFromJson(Map<String, dynamic> json) =>
    PerfilStatusModel(
      success: json['success'] as bool,
      userId: json['usuario_id'] as String,
      totalRefeicoes: (json['total_refeicoes'] as num).toInt(),
      diasConsecutivos: (json['dias_consecutivos'] as num).toInt(),
      ultimasRefeicoes:
          (json['ultimas_refeicoes'] as List<dynamic>)
              .map(
                (e) => UltimaRefeicaoModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$PerfilStatusModelToJson(PerfilStatusModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'usuario_id': instance.userId,
      'total_refeicoes': instance.totalRefeicoes,
      'dias_consecutivos': instance.diasConsecutivos,
      'ultimas_refeicoes': instance.ultimasRefeicoes,
    };

UltimaRefeicaoModel _$UltimaRefeicaoModelFromJson(Map<String, dynamic> json) =>
    UltimaRefeicaoModel(
      id: json['id'] as String,
      dataRefeicao: json['data_refeicao'] as String,
      tipoRefeicao: json['tipo_refeicao'] as String,
      classificacaoFinal: json['classificacao_final'] as String,
    );

Map<String, dynamic> _$UltimaRefeicaoModelToJson(
  UltimaRefeicaoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'data_refeicao': instance.dataRefeicao,
  'tipo_refeicao': instance.tipoRefeicao,
  'classificacao_final': instance.classificacaoFinal,
};

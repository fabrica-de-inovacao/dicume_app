import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'perfil_status_model.g.dart';

@JsonSerializable()
class PerfilStatusModel extends Equatable {
  final bool success;
  @JsonKey(name: 'usuario_id')
  final String userId;
  @JsonKey(name: 'total_refeicoes')
  final int totalRefeicoes;
  @JsonKey(name: 'dias_consecutivos')
  final int diasConsecutivos;
  @JsonKey(name: 'ultimas_refeicoes')
  final List<UltimaRefeicaoModel> ultimasRefeicoes;

  const PerfilStatusModel({
    required this.success,
    required this.userId,
    required this.totalRefeicoes,
    required this.diasConsecutivos,
    required this.ultimasRefeicoes,
  });

  factory PerfilStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PerfilStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$PerfilStatusModelToJson(this);

  @override
  List<Object?> get props => [
        success,
        userId,
        totalRefeicoes,
        diasConsecutivos,
        ultimasRefeicoes,
      ];
}

@JsonSerializable()
class UltimaRefeicaoModel extends Equatable {
  final String id;
  @JsonKey(name: 'data_refeicao')
  final String dataRefeicao;
  @JsonKey(name: 'tipo_refeicao')
  final String tipoRefeicao;
  @JsonKey(name: 'classificacao_final')
  final String classificacaoFinal;

  const UltimaRefeicaoModel({
    required this.id,
    required this.dataRefeicao,
    required this.tipoRefeicao,
    required this.classificacaoFinal,
  });

  factory UltimaRefeicaoModel.fromJson(Map<String, dynamic> json) =>
      _$UltimaRefeicaoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UltimaRefeicaoModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        dataRefeicao,
        tipoRefeicao,
        classificacaoFinal,
      ];
}

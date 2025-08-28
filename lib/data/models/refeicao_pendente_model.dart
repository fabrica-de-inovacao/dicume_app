import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import '../../domain/entities/refeicao.dart';

part 'refeicao_pendente_model.g.dart';

@JsonSerializable()
class RefeicaoPendenteModel {
  final int? id;
  @JsonKey(name: 'tipo_refeicao')
  final String tipoRefeicao;
  @JsonKey(name: 'data_refeicao')
  final String dataRefeicao;
  final List<ItemRefeicaoPendenteModel> itens;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'is_syncing')
  final bool isSyncing;

  const RefeicaoPendenteModel({
    this.id,
    required this.tipoRefeicao,
    required this.dataRefeicao,
    required this.itens,
    required this.createdAt,
    this.isSyncing = false,
  });

  factory RefeicaoPendenteModel.fromJson(Map<String, dynamic> json) =>
      _$RefeicaoPendenteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefeicaoPendenteModelToJson(this);

  RefeicaoPendente toEntity() {
    return RefeicaoPendente(
      id: id,
      tipoRefeicao: tipoRefeicao,
      dataRefeicao: dataRefeicao,
      itens: itens.map((item) => item.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      isSyncing: isSyncing,
    );
  }

  factory RefeicaoPendenteModel.fromEntity(RefeicaoPendente refeicao) {
    return RefeicaoPendenteModel(
      id: refeicao.id,
      tipoRefeicao: refeicao.tipoRefeicao,
      dataRefeicao: refeicao.dataRefeicao,
      itens:
          refeicao.itens
              .map((item) => ItemRefeicaoPendenteModel.fromEntity(item))
              .toList(),
      createdAt: refeicao.createdAt.toIso8601String(),
      isSyncing: refeicao.isSyncing,
    );
  }

  /// Converte para JSON string para armazenar no banco
  String toJsonString() => json.encode(toJson());

  /// Cria modelo a partir de JSON string do banco
  factory RefeicaoPendenteModel.fromJsonString(String jsonString) =>
      RefeicaoPendenteModel.fromJson(json.decode(jsonString));
}

@JsonSerializable()
class ItemRefeicaoPendenteModel {
  @JsonKey(name: 'alimento_id')
  final String alimentoId;
  @JsonKey(name: 'quantidade_base')
  final double quantidadeBase;

  const ItemRefeicaoPendenteModel({
    required this.alimentoId,
    required this.quantidadeBase,
  });

  factory ItemRefeicaoPendenteModel.fromJson(Map<String, dynamic> json) =>
      _$ItemRefeicaoPendenteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRefeicaoPendenteModelToJson(this);

  ItemRefeicaoPendente toEntity() {
    return ItemRefeicaoPendente(
      alimentoId: alimentoId,
      quantidadeBase: quantidadeBase,
    );
  }

  factory ItemRefeicaoPendenteModel.fromEntity(ItemRefeicaoPendente item) {
    return ItemRefeicaoPendenteModel(
      alimentoId: item.alimentoId,
      quantidadeBase: item.quantidadeBase,
    );
  }
}

/// Modelo para envio para API (POST /diario/refeicoes)
@JsonSerializable()
class RefeicaoApiRequestModel {
  @JsonKey(name: 'tipo_refeicao')
  final String tipoRefeicao;
  @JsonKey(name: 'data_refeicao')
  final String dataRefeicao;
  final List<ItemRefeicaoApiModel> itens;

  const RefeicaoApiRequestModel({
    required this.tipoRefeicao,
    required this.dataRefeicao,
    required this.itens,
  });

  factory RefeicaoApiRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefeicaoApiRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefeicaoApiRequestModelToJson(this);

  factory RefeicaoApiRequestModel.fromRefeicaoPendente(
    RefeicaoPendente refeicao,
  ) {
    return RefeicaoApiRequestModel(
      tipoRefeicao: refeicao.tipoRefeicao,
      dataRefeicao: refeicao.dataRefeicao,
      itens:
          refeicao.itens
              .map((item) => ItemRefeicaoApiModel.fromEntity(item))
              .toList(),
    );
  }
}

@JsonSerializable()
class ItemRefeicaoApiModel {
  @JsonKey(name: 'alimento_id')
  final String alimentoId;
  @JsonKey(name: 'quantidade_base')
  final double quantidadeBase;

  const ItemRefeicaoApiModel({
    required this.alimentoId,
    required this.quantidadeBase,
  });

  factory ItemRefeicaoApiModel.fromJson(Map<String, dynamic> json) =>
      _$ItemRefeicaoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRefeicaoApiModelToJson(this);

  factory ItemRefeicaoApiModel.fromEntity(ItemRefeicaoPendente item) {
    return ItemRefeicaoApiModel(
      alimentoId: item.alimentoId,
      quantidadeBase: item.quantidadeBase,
    );
  }
}

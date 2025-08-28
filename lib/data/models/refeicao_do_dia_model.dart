import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

part 'refeicao_do_dia_model.g.dart';

@JsonSerializable()
class RefeicaoDoDiaModel {
  final String id;
  @JsonKey(name: 'tipo_refeicao')
  final String tipoRefeicao;
  @JsonKey(name: 'classificacao_final')
  final String classificacaoFinal;
  final List<ItemRefeicaoDoDiaModel> itens;

  // Campos adicionais para a UI
  @JsonKey(ignore: true)
  IconData? icone;
  @JsonKey(ignore: true)
  Color? cor;
  @JsonKey(ignore: true)
  String? horario; // Adicionado para compatibilidade com a UI existente

  RefeicaoDoDiaModel({
    required this.id,
    required this.tipoRefeicao,
    required this.classificacaoFinal,
    required this.itens,
    this.icone,
    this.cor,
    this.horario,
  }) {
    _setUiProperties();
  }

  factory RefeicaoDoDiaModel.fromJson(Map<String, dynamic> json) =>
      _$RefeicaoDoDiaModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefeicaoDoDiaModelToJson(this);

  void _setUiProperties() {
    switch (tipoRefeicao.toLowerCase()) {
      case 'café da manhã':
        icone = Icons.free_breakfast;
        horario = '07:30'; // Valor padrão, pode ser ajustado
        break;
      case 'lanche da manhã':
        icone = Icons.local_cafe;
        horario = '10:00';
        break;
      case 'almoço':
        icone = Icons.restaurant;
        horario = '12:30';
        break;
      case 'lanche da tarde':
        icone = Icons.local_drink;
        horario = '15:30';
        break;
      case 'jantar':
        icone = Icons.dinner_dining;
        horario = '19:00';
        break;
      case 'ceia':
        icone = Icons.nights_stay;
        horario = '22:00';
        break;
      default:
        icone = Icons.fastfood;
        horario = 'N/A';
    }

    switch (classificacaoFinal.toLowerCase()) {
      case 'verde':
        cor = AppColors.success;
        break;
      case 'amarelo':
        cor = AppColors.warning;
        break;
      case 'vermelho':
        cor = AppColors.error;
        break;
      default:
        cor = AppColors.grey400;
    }
  }
}

@JsonSerializable()
class ItemRefeicaoDoDiaModel {
  final AlimentoRefeicaoDoDiaModel alimentos;
  @JsonKey(name: 'quantidade_base')
  final int quantidadeBase;

  ItemRefeicaoDoDiaModel({
    required this.alimentos,
    required this.quantidadeBase,
  });

  factory ItemRefeicaoDoDiaModel.fromJson(Map<String, dynamic> json) =>
      _$ItemRefeicaoDoDiaModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRefeicaoDoDiaModelToJson(this);
}

@JsonSerializable()
class AlimentoRefeicaoDoDiaModel {
  @JsonKey(name: 'nome_popular')
  final String nomePopular;
  @JsonKey(name: 'foto_porcao_url')
  final String fotoPorcaoUrl;
  @JsonKey(name: 'recomendacao_consumo')
  final String recomendacaoConsumo;

  AlimentoRefeicaoDoDiaModel({
    required this.nomePopular,
    required this.fotoPorcaoUrl,
    required this.recomendacaoConsumo,
  });

  factory AlimentoRefeicaoDoDiaModel.fromJson(Map<String, dynamic> json) =>
      _$AlimentoRefeicaoDoDiaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlimentoRefeicaoDoDiaModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/alimento.dart';

part 'alimento_model.g.dart';

@JsonSerializable()
class AlimentoModel {
  final int id;
  @JsonKey(name: 'nome_popular')
  final String nomePopular;
  @JsonKey(name: 'grupo_dicume')
  final String grupoDicume;
  @JsonKey(name: 'classificacao_cor')
  final String classificacaoCor;
  @JsonKey(name: 'recomendacao_consumo')
  final String recomendacaoConsumo;
  @JsonKey(name: 'foto_porcao_url')
  final String fotoPorcaoUrl;
  @JsonKey(name: 'grupo_nutricional')
  final String grupoNutricional;
  @JsonKey(name: 'ig_classificacao')
  final String igClassificacao;
  @JsonKey(name: 'guia_alimentar_class')
  final String guiaAlimentarClass;

  const AlimentoModel({
    required this.id,
    required this.nomePopular,
    required this.grupoDicume,
    required this.classificacaoCor,
    required this.recomendacaoConsumo,
    required this.fotoPorcaoUrl,
    required this.grupoNutricional,
    required this.igClassificacao,
    required this.guiaAlimentarClass,
  });

  factory AlimentoModel.fromJson(Map<String, dynamic> json) =>
      _$AlimentoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlimentoModelToJson(this);

  Alimento toEntity({bool isFavorito = false}) {
    return Alimento(
      id: id,
      nomePopular: nomePopular,
      grupoDicume: grupoDicume,
      classificacaoCor: classificacaoCor,
      recomendacaoConsumo: recomendacaoConsumo,
      fotoPorcaoUrl: fotoPorcaoUrl,
      grupoNutricional: grupoNutricional,
      igClassificacao: igClassificacao,
      guiaAlimentarClass: guiaAlimentarClass,
      isFavorito: isFavorito,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory AlimentoModel.fromEntity(Alimento alimento) {
    return AlimentoModel(
      id: alimento.id,
      nomePopular: alimento.nomePopular,
      grupoDicume: alimento.grupoDicume,
      classificacaoCor: alimento.classificacaoCor,
      recomendacaoConsumo: alimento.recomendacaoConsumo,
      fotoPorcaoUrl: alimento.fotoPorcaoUrl,
      grupoNutricional: alimento.grupoNutricional,
      igClassificacao: alimento.igClassificacao,
      guiaAlimentarClass: alimento.guiaAlimentarClass,
    );
  }
}

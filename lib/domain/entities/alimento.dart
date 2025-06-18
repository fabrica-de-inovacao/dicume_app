import 'package:equatable/equatable.dart';

class Alimento extends Equatable {
  final int id;
  final String nomePopular;
  final String grupoDicume;
  final String classificacaoCor;
  final String recomendacaoConsumo;
  final String fotoPorcaoUrl;
  final String grupoNutricional;
  final String igClassificacao;
  final String guiaAlimentarClass;
  final bool isFavorito;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Alimento({
    required this.id,
    required this.nomePopular,
    required this.grupoDicume,
    required this.classificacaoCor,
    required this.recomendacaoConsumo,
    required this.fotoPorcaoUrl,
    required this.grupoNutricional,
    required this.igClassificacao,
    required this.guiaAlimentarClass,
    this.isFavorito = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Alimento copyWith({
    int? id,
    String? nomePopular,
    String? grupoDicume,
    String? classificacaoCor,
    String? recomendacaoConsumo,
    String? fotoPorcaoUrl,
    String? grupoNutricional,
    String? igClassificacao,
    String? guiaAlimentarClass,
    bool? isFavorito,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Alimento(
      id: id ?? this.id,
      nomePopular: nomePopular ?? this.nomePopular,
      grupoDicume: grupoDicume ?? this.grupoDicume,
      classificacaoCor: classificacaoCor ?? this.classificacaoCor,
      recomendacaoConsumo: recomendacaoConsumo ?? this.recomendacaoConsumo,
      fotoPorcaoUrl: fotoPorcaoUrl ?? this.fotoPorcaoUrl,
      grupoNutricional: grupoNutricional ?? this.grupoNutricional,
      igClassificacao: igClassificacao ?? this.igClassificacao,
      guiaAlimentarClass: guiaAlimentarClass ?? this.guiaAlimentarClass,
      isFavorito: isFavorito ?? this.isFavorito,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nomePopular,
    grupoDicume,
    classificacaoCor,
    recomendacaoConsumo,
    fotoPorcaoUrl,
    grupoNutricional,
    igClassificacao,
    guiaAlimentarClass,
    isFavorito,
    createdAt,
    updatedAt,
  ];
}

// Enum para classificação de cores do semáforo
enum ClassificacaoCor {
  verde('verde'),
  amarelo('amarelo'),
  vermelho('vermelho');

  const ClassificacaoCor(this.value);
  final String value;

  static ClassificacaoCor fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verde':
        return ClassificacaoCor.verde;
      case 'amarelo':
        return ClassificacaoCor.amarelo;
      case 'vermelho':
        return ClassificacaoCor.vermelho;
      default:
        throw ArgumentError('Classificação de cor inválida: $value');
    }
  }
}

// Enum para grupos DICUMÊ regionalizados
enum GrupoDicume {
  verdurasFolhosas('Verduras e Folhosas'),
  legumes('Legumes'),
  frutas('Frutas'),
  cereaisIntegrais('Cereais e Integrais'),
  cereaisRefinados('Cereais Refinados'),
  leguminosas('Leguminosas'),
  carnes('Carnes e Peixes'),
  laticinios('Laticínios'),
  oleaginosas('Oleaginosas'),
  oleos('Óleos e Gorduras'),
  doces('GRUPO DOS DOCES'),
  outros('Outros');

  const GrupoDicume(this.displayName);
  final String displayName;

  static GrupoDicume fromString(String value) {
    for (GrupoDicume grupo in GrupoDicume.values) {
      if (grupo.displayName.toLowerCase() == value.toLowerCase()) {
        return grupo;
      }
    }
    return GrupoDicume.outros;
  }
}

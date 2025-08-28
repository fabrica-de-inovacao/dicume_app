import 'package:equatable/equatable.dart';

class RefeicaoPendente extends Equatable {
  final int? id;
  final String tipoRefeicao;
  final String dataRefeicao;
  final List<ItemRefeicaoPendente> itens;
  final DateTime createdAt;
  final bool isSyncing;

  const RefeicaoPendente({
    this.id,
    required this.tipoRefeicao,
    required this.dataRefeicao,
    required this.itens,
    required this.createdAt,
    this.isSyncing = false,
  });

  RefeicaoPendente copyWith({
    int? id,
    String? tipoRefeicao,
    String? dataRefeicao,
    List<ItemRefeicaoPendente>? itens,
    DateTime? createdAt,
    bool? isSyncing,
  }) {
    return RefeicaoPendente(
      id: id ?? this.id,
      tipoRefeicao: tipoRefeicao ?? this.tipoRefeicao,
      dataRefeicao: dataRefeicao ?? this.dataRefeicao,
      itens: itens ?? this.itens,
      createdAt: createdAt ?? this.createdAt,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props => [
    id,
    tipoRefeicao,
    dataRefeicao,
    itens,
    createdAt,
    isSyncing,
  ];
}

class ItemRefeicaoPendente extends Equatable {
  final String alimentoId;
  final double quantidadeBase;

  const ItemRefeicaoPendente({
    required this.alimentoId,
    required this.quantidadeBase,
  });

  @override
  List<Object?> get props => [alimentoId, quantidadeBase];
}

// Enums para tipos de refeição
enum TipoRefeicao {
  cafeManha('cafe_manha', 'Café da Manhã'),
  almoco('almoco', 'Almoço'),
  jantar('jantar', 'Jantar'),
  lanche('lanche', 'Lanche');

  const TipoRefeicao(this.value, this.displayName);
  final String value;
  final String displayName;

  static TipoRefeicao fromString(String value) {
    for (TipoRefeicao tipo in TipoRefeicao.values) {
      if (tipo.value == value) {
        return tipo;
      }
    }
    throw ArgumentError('Tipo de refeição inválido: $value');
  }
}

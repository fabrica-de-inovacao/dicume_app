class AlimentoSimples {
  final String nome;
  final double calorias;
  final double carboidratos;
  final double proteinas;
  final double gorduras;
  final String classificacao; // verde, amarelo, vermelho

  const AlimentoSimples({
    required this.nome,
    required this.calorias,
    required this.carboidratos,
    required this.proteinas,
    required this.gorduras,
    required this.classificacao,
  });

  // Dados mock para teste
  static const List<AlimentoSimples> alimentosMock = [
    AlimentoSimples(
      nome: 'Arroz branco cozido',
      calorias: 130,
      carboidratos: 28.2,
      proteinas: 2.7,
      gorduras: 0.3,
      classificacao: 'amarelo',
    ),
    AlimentoSimples(
      nome: 'Feijão preto cozido',
      calorias: 132,
      carboidratos: 23.1,
      proteinas: 8.9,
      gorduras: 0.5,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Frango grelhado (peito)',
      calorias: 165,
      carboidratos: 0,
      proteinas: 31,
      gorduras: 3.6,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Batata doce cozida',
      calorias: 86,
      carboidratos: 20.1,
      proteinas: 1.6,
      gorduras: 0.1,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Brócolis cozido',
      calorias: 35,
      carboidratos: 7,
      proteinas: 2.8,
      gorduras: 0.4,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Banana prata',
      calorias: 89,
      carboidratos: 22.8,
      proteinas: 1.1,
      gorduras: 0.3,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Ovo cozido',
      calorias: 155,
      carboidratos: 1.1,
      proteinas: 13,
      gorduras: 11,
      classificacao: 'verde',
    ),
    AlimentoSimples(
      nome: 'Pão francês',
      calorias: 265,
      carboidratos: 50.8,
      proteinas: 8.4,
      gorduras: 3.1,
      classificacao: 'amarelo',
    ),
    AlimentoSimples(
      nome: 'Queijo mussarela',
      calorias: 300,
      carboidratos: 2.9,
      proteinas: 25,
      gorduras: 21,
      classificacao: 'amarelo',
    ),
    AlimentoSimples(
      nome: 'Refrigerante cola',
      calorias: 42,
      carboidratos: 10.6,
      proteinas: 0,
      gorduras: 0,
      classificacao: 'vermelho',
    ),
  ];

  static List<AlimentoSimples> buscar(String query) {
    if (query.isEmpty) return [];

    return alimentosMock
        .where(
          (alimento) =>
              alimento.nome.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

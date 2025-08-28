class GrupoAlimento {
  final String id;
  final String nome;
  final String nomeRegional;
  final String descricao;
  final String icone;
  final String cor; // Cor temática do grupo
  final List<String> exemplos; // Exemplos de alimentos para preview

  const GrupoAlimento({
    required this.id,
    required this.nome,
    required this.nomeRegional,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.exemplos,
  });

  // Grupos regionalizados baseados na cultura maranhense
  static const List<GrupoAlimento> grupos = [
    GrupoAlimento(
      id: 'verduras',
      nome: 'Verduras e Legumes',
      nomeRegional: 'Verduras da Feira',
      descricao: 'As verdinhas frescas que a gente compra na feira',
      icone: '🥬',
      cor: '#4CAF50', // Verde
      exemplos: ['Alface', 'Tomate', 'Cebola', 'Coentro'],
    ),
    GrupoAlimento(
      id: 'frutas',
      nome: 'Frutas',
      nomeRegional: 'Frutas do Pé',
      descricao: 'As frutas docinhas da região',
      icone: '🍎',
      cor: '#FF9800', // Laranja
      exemplos: ['Banana', 'Manga', 'Caju', 'Açaí'],
    ),
    GrupoAlimento(
      id: 'carnes',
      nome: 'Carnes e Proteínas',
      nomeRegional: 'Carnes do Mercado',
      descricao: 'As proteínas que dão força pro corpo',
      icone: '🥩',
      cor: '#D32F2F', // Vermelho
      exemplos: ['Frango', 'Peixe', 'Carne de Sol', 'Ovo'],
    ),
    GrupoAlimento(
      id: 'graos',
      nome: 'Grãos e Cereais',
      nomeRegional: 'Grãos da Mesa',
      descricao: 'Arroz, feijão e outras bases da nossa comida',
      icone: '🌾',
      cor: '#8D6E63', // Marrom
      exemplos: ['Arroz', 'Feijão', 'Milho', 'Farinha'],
    ),
    GrupoAlimento(
      id: 'laticinios',
      nome: 'Leites e Derivados',
      nomeRegional: 'Leites e Queijos',
      descricao: 'Do leite fresquinho aos queijos da região',
      icone: '🥛',
      cor: '#2196F3', // Azul
      exemplos: ['Leite', 'Queijo', 'Iogurte', 'Requeijão'],
    ),
    GrupoAlimento(
      id: 'doces',
      nome: 'Doces e Açúcares',
      nomeRegional: 'Doces da Casa',
      descricao: 'Os docinhos que pedem moderação',
      icone: '🍯',
      cor: '#9C27B0', // Roxo
      exemplos: ['Açúcar', 'Mel', 'Doce de Leite', 'Rapadura'],
    ),
    GrupoAlimento(
      id: 'bebidas',
      nome: 'Bebidas',
      nomeRegional: 'Bebidas da Mesa',
      descricao: 'O que a gente bebe no dia a dia',
      icone: '🧃',
      cor: '#00BCD4', // Ciano
      exemplos: ['Água', 'Suco', 'Café', 'Guaraná'],
    ),
    GrupoAlimento(
      id: 'temperos',
      nome: 'Temperos e Condimentos',
      nomeRegional: 'Temperos da Cozinha',
      descricao: 'Os temperinhos que dão sabor na comida',
      icone: '🌿',
      cor: '#689F38', // Verde oliva
      exemplos: ['Alho', 'Pimenta', 'Cominho', 'Colorau'],
    ),
  ];

  static GrupoAlimento? buscarPorId(String id) {
    try {
      return grupos.firstWhere((grupo) => grupo.id == id);
    } catch (e) {
      return null;
    }
  }
}

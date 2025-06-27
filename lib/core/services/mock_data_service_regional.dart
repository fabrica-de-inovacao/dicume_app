import '../../domain/entities/alimento.dart';

/// Estrutura simples para medidas caseiras
class MedidaCaseiraSimples {
  final String id;
  final String nome;
  final double peso;
  final String grupoId;

  const MedidaCaseiraSimples({
    required this.id,
    required this.nome,
    required this.peso,
    required this.grupoId,
  });
}

/// Estrutura simples para alimentos com informação nutricional
class AlimentoNutricional {
  final String id;
  final String nome;
  final String grupoId;
  final double calorias;
  final double carboidratos;
  final double proteinas;
  final double gorduras;
  final double fibras;
  final double sodio;
  final String semaforo;
  final String descricao;
  final String imagemUrl;

  const AlimentoNutricional({
    required this.id,
    required this.nome,
    required this.grupoId,
    required this.calorias,
    required this.carboidratos,
    required this.proteinas,
    required this.gorduras,
    required this.fibras,
    required this.sodio,
    required this.semaforo,
    required this.descricao,
    required this.imagemUrl,
  });

  /// Converte para Alimento para compatibilidade
  Alimento toAlimento() {
    return Alimento(
      id: id, // Agora usa String diretamente
      nomePopular: nome,
      grupoDicume: grupoId,
      classificacaoCor: semaforo,
      recomendacaoConsumo: _getRecomendacao(semaforo),
      fotoPorcaoUrl: imagemUrl,
      grupoNutricional: grupoId,
      igClassificacao: 'baixo',
      guiaAlimentarClass: 'in_natura',
      isFavorito: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _getRecomendacao(String semaforo) {
    switch (semaforo) {
      case 'verde':
        return 'Pode consumir à vontade! Alimento saudável.';
      case 'amarelo':
        return 'Consuma com moderação.';
      case 'vermelho':
        return 'Consuma raramente e em pequenas quantidades.';
      default:
        return 'Consulte um nutricionista.';
    }
  }
}

/// Serviço de dados mock regionalizados para o DICUMÊ
class SuperMockDataService {
  static final SuperMockDataService _instance =
      SuperMockDataService._internal();
  factory SuperMockDataService() => _instance;
  SuperMockDataService._internal();

  // ============================================================================
  // GRUPOS ALIMENTARES SIMPLIFICADOS
  // ============================================================================

  static final List<Map<String, dynamic>> _grupos = [
    {
      'id': 'verduras',
      'nome': 'Verduras e Legumes',
      'nomeRegional': 'Verduras da Feira',
      'descricao': 'As verdinhas frescas que a gente compra na feira',
      'icone': '🥬',
      'cor': '#4CAF50',
      'exemplos': ['Alface', 'Tomate', 'Cebola', 'Coentro'],
    },
    {
      'id': 'frutas',
      'nome': 'Frutas',
      'nomeRegional': 'Frutas do Pé',
      'descricao': 'As frutas docinhas da região',
      'icone': '🍎',
      'cor': '#FF9800',
      'exemplos': ['Banana', 'Manga', 'Caju', 'Açaí'],
    },
    {
      'id': 'carnes',
      'nome': 'Carnes e Proteínas',
      'nomeRegional': 'Carnes do Mercado',
      'descricao': 'As proteínas que dão força pro corpo',
      'icone': '🥩',
      'cor': '#D32F2F',
      'exemplos': ['Frango', 'Peixe', 'Carne de Sol', 'Ovo'],
    },
    {
      'id': 'graos',
      'nome': 'Grãos e Cereais',
      'nomeRegional': 'Grãos da Terra',
      'descricao': 'Os grãos que dão energia pro dia',
      'icone': '🌾',
      'cor': '#8BC34A',
      'exemplos': ['Arroz', 'Feijão', 'Milho', 'Cuscuz'],
    },
    {
      'id': 'laticinios',
      'nome': 'Leites e Derivados',
      'nomeRegional': 'Leites da Fazenda',
      'descricao': 'Os laticínios frescos e nutritivos',
      'icone': '🥛',
      'cor': '#2196F3',
      'exemplos': ['Leite', 'Queijo', 'Iogurte', 'Requeijão'],
    },
  ];

  // ============================================================================
  // ALIMENTOS REGIONAIS POR CATEGORIA
  // ============================================================================

  static final List<AlimentoNutricional> _alimentos = [
    // VERDURAS E LEGUMES
    AlimentoNutricional(
      id: '1',
      nome: 'Jerimum (Abóbora)',
      grupoId: 'verduras',
      calorias: 26,
      carboidratos: 6.5,
      proteinas: 1.0,
      gorduras: 0.1,
      fibras: 0.5,
      sodio: 1,
      semaforo: 'verde',
      descricao: 'Jerimum docinho, rico em betacaroteno',
      imagemUrl: 'assets/images/jerimum.jpg',
    ),
    AlimentoNutricional(
      id: '2',
      nome: 'Maxixe',
      grupoId: 'verduras',
      calorias: 19,
      carboidratos: 4.3,
      proteinas: 1.1,
      gorduras: 0.1,
      fibras: 1.5,
      sodio: 8,
      semaforo: 'verde',
      descricao: 'Maxixe fresquinho, ideal para refogados',
      imagemUrl: 'assets/images/maxixe.jpg',
    ),
    AlimentoNutricional(
      id: '3',
      nome: 'Quiabo',
      grupoId: 'verduras',
      calorias: 33,
      carboidratos: 7.5,
      proteinas: 1.9,
      gorduras: 0.2,
      fibras: 3.2,
      sodio: 7,
      semaforo: 'verde',
      descricao: 'Quiabo fresquinho, rico em fibras',
      imagemUrl: 'assets/images/quiabo.jpg',
    ),
    AlimentoNutricional(
      id: '4',
      nome: 'Coentro',
      grupoId: 'verduras',
      calorias: 23,
      carboidratos: 3.7,
      proteinas: 2.1,
      gorduras: 0.5,
      fibras: 2.8,
      sodio: 46,
      semaforo: 'verde',
      descricao: 'Coentro cheiroso, tempero que não pode faltar',
      imagemUrl: 'assets/images/coentro.jpg',
    ),

    // FRUTAS
    AlimentoNutricional(
      id: '5',
      nome: 'Mangaba',
      grupoId: 'frutas',
      calorias: 43,
      carboidratos: 10.8,
      proteinas: 0.5,
      gorduras: 0.1,
      fibras: 1.8,
      sodio: 2,
      semaforo: 'verde',
      descricao: 'Mangaba doce e suculenta, fruta típica do Nordeste',
      imagemUrl: 'assets/images/mangaba.jpg',
    ),
    AlimentoNutricional(
      id: '6',
      nome: 'Cajá',
      grupoId: 'frutas',
      calorias: 46,
      carboidratos: 11.4,
      proteinas: 0.8,
      gorduras: 0.1,
      fibras: 1.7,
      sodio: 3,
      semaforo: 'verde',
      descricao: 'Cajá fresquinho, rico em vitamina C',
      imagemUrl: 'assets/images/caja.jpg',
    ),
    AlimentoNutricional(
      id: '7',
      nome: 'Siriguela',
      grupoId: 'frutas',
      calorias: 76,
      carboidratos: 19.0,
      proteinas: 0.8,
      gorduras: 0.2,
      fibras: 1.6,
      sodio: 4,
      semaforo: 'verde',
      descricao: 'Siriguela doce, perfeita para sobremesa',
      imagemUrl: 'assets/images/siriguela.jpg',
    ),
    AlimentoNutricional(
      id: '8',
      nome: 'Caju',
      grupoId: 'frutas',
      calorias: 37,
      carboidratos: 8.4,
      proteinas: 0.8,
      gorduras: 0.2,
      fibras: 1.3,
      sodio: 1,
      semaforo: 'verde',
      descricao: 'Caju suculento, rico em vitamina C',
      imagemUrl: 'assets/images/caju.jpg',
    ),

    // CARNES E PROTEÍNAS
    AlimentoNutricional(
      id: '9',
      nome: 'Peixe Grelhado',
      grupoId: 'carnes',
      calorias: 150,
      carboidratos: 0.0,
      proteinas: 28.0,
      gorduras: 4.2,
      fibras: 0.0,
      sodio: 120,
      semaforo: 'verde',
      descricao: 'Peixe fresquinho grelhado, proteína magra',
      imagemUrl: 'assets/images/peixe_grelhado.jpg',
    ),
    AlimentoNutricional(
      id: '10',
      nome: 'Frango Caipira',
      grupoId: 'carnes',
      calorias: 165,
      carboidratos: 0.0,
      proteinas: 31.0,
      gorduras: 3.6,
      fibras: 0.0,
      sodio: 70,
      semaforo: 'verde',
      descricao: 'Frango caipira criado solto, sabor autêntico',
      imagemUrl: 'assets/images/frango_caipira.jpg',
    ),
    AlimentoNutricional(
      id: '11',
      nome: 'Ovo Caipira',
      grupoId: 'carnes',
      calorias: 75,
      carboidratos: 0.6,
      proteinas: 6.3,
      gorduras: 5.0,
      fibras: 0.0,
      sodio: 70,
      semaforo: 'verde',
      descricao: 'Ovo fresquinho de galinha criada solta',
      imagemUrl: 'assets/images/ovo_caipira.jpg',
    ),
    AlimentoNutricional(
      id: '12',
      nome: 'Carne de Sol',
      grupoId: 'carnes',
      calorias: 250,
      carboidratos: 0.0,
      proteinas: 35.0,
      gorduras: 12.0,
      fibras: 0.0,
      sodio: 1200,
      semaforo: 'amarelo',
      descricao: 'Carne de sol tradicional, rica em proteínas',
      imagemUrl: 'assets/images/carne_sol.jpg',
    ),

    // GRÃOS E CEREAIS
    AlimentoNutricional(
      id: '13',
      nome: 'Cuscuz de Milho',
      grupoId: 'graos',
      calorias: 112,
      carboidratos: 24.2,
      proteinas: 2.8,
      gorduras: 0.8,
      fibras: 2.1,
      sodio: 200,
      semaforo: 'verde',
      descricao: 'Tradicional cuscuz nordestino feito com flocão de milho',
      imagemUrl: 'assets/images/cuscuz.jpg',
    ),
    AlimentoNutricional(
      id: '14',
      nome: 'Tapioca',
      grupoId: 'graos',
      calorias: 130,
      carboidratos: 32.0,
      proteinas: 0.2,
      gorduras: 0.1,
      fibras: 0.5,
      sodio: 1,
      semaforo: 'verde',
      descricao: 'Massa de tapioca fresquinha, ideal para recheios saudáveis',
      imagemUrl: 'assets/images/tapioca.jpg',
    ),
    AlimentoNutricional(
      id: '15',
      nome: 'Feijão de Corda',
      grupoId: 'graos',
      calorias: 85,
      carboidratos: 15.2,
      proteinas: 5.8,
      gorduras: 0.5,
      fibras: 8.5,
      sodio: 240,
      semaforo: 'verde',
      descricao: 'Feijão de corda tradicional, rico em proteínas',
      imagemUrl: 'assets/images/feijao_corda.jpg',
    ),
    AlimentoNutricional(
      id: '16',
      nome: 'Arroz Branco',
      grupoId: 'graos',
      calorias: 128,
      carboidratos: 28.1,
      proteinas: 2.5,
      gorduras: 0.2,
      fibras: 0.4,
      sodio: 1,
      semaforo: 'amarelo',
      descricao: 'Arroz soltinho, acompanhamento clássico',
      imagemUrl: 'assets/images/arroz.jpg',
    ),

    // LATICÍNIOS
    AlimentoNutricional(
      id: '17',
      nome: 'Queijo de Coalho',
      grupoId: 'laticinios',
      calorias: 355,
      carboidratos: 2.8,
      proteinas: 22.0,
      gorduras: 28.5,
      fibras: 0.0,
      sodio: 670,
      semaforo: 'amarelo',
      descricao: 'Queijo de coalho tradicional, ideal grelhado',
      imagemUrl: 'assets/images/queijo_coalho.jpg',
    ),
    AlimentoNutricional(
      id: '18',
      nome: 'Leite de Cabra',
      grupoId: 'laticinios',
      calorias: 69,
      carboidratos: 4.4,
      proteinas: 3.6,
      gorduras: 4.1,
      fibras: 0.0,
      sodio: 50,
      semaforo: 'verde',
      descricao: 'Leite de cabra fresquinho e nutritivo',
      imagemUrl: 'assets/images/leite_cabra.jpg',
    ),
    AlimentoNutricional(
      id: '19',
      nome: 'Iogurte Natural',
      grupoId: 'laticinios',
      calorias: 61,
      carboidratos: 4.7,
      proteinas: 3.5,
      gorduras: 3.3,
      fibras: 0.0,
      sodio: 46,
      semaforo: 'verde',
      descricao: 'Iogurte natural cremoso, fonte de probióticos',
      imagemUrl: 'assets/images/iogurte.jpg',
    ),
    AlimentoNutricional(
      id: '20',
      nome: 'Requeijão Caseiro',
      grupoId: 'laticinios',
      calorias: 264,
      carboidratos: 3.5,
      proteinas: 11.2,
      gorduras: 24.0,
      fibras: 0.0,
      sodio: 380,
      semaforo: 'amarelo',
      descricao: 'Requeijão caseiro cremoso, perfeito no cuscuz',
      imagemUrl: 'assets/images/requeijao.jpg',
    ),
  ];

  // ============================================================================
  // MÉTODOS PÚBLICOS
  // ============================================================================

  /// Retorna todos os grupos alimentares
  List<Map<String, dynamic>> getGrupos() => List.from(_grupos);

  /// Retorna alimentos de um grupo específico
  List<AlimentoNutricional> getAlimentosPorGrupo(String grupoId) {
    return _alimentos.where((alimento) => alimento.grupoId == grupoId).toList();
  }

  /// Retorna todos os alimentos
  List<AlimentoNutricional> getTodosAlimentos() => List.from(_alimentos);

  /// Retorna todos os alimentos convertidos para Alimento
  List<Alimento> getTodosAlimentosComoAlimento() {
    return _alimentos.map((a) => a.toAlimento()).toList();
  }

  /// Busca alimentos por nome
  List<AlimentoNutricional> buscarAlimentos(String query) {
    if (query.isEmpty) return getTodosAlimentos();

    return _alimentos
        .where(
          (alimento) =>
              alimento.nome.toLowerCase().contains(query.toLowerCase()) ||
              alimento.descricao.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Retorna um alimento específico por ID
  AlimentoNutricional? getAlimentoPorId(String id) {
    try {
      return _alimentos.firstWhere((alimento) => alimento.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna um grupo específico por ID
  Map<String, dynamic>? getGrupoPorId(String id) {
    try {
      return _grupos.firstWhere((grupo) => grupo['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna alimentos por semáforo nutricional
  List<AlimentoNutricional> getAlimentosPorSemaforo(String semaforo) {
    return _alimentos
        .where((alimento) => alimento.semaforo == semaforo)
        .toList();
  }

  /// Estatísticas dos alimentos por semáforo
  Map<String, int> getEstatisticasSemaforo() {
    final verdes = getAlimentosPorSemaforo('verde').length;
    final amarelos = getAlimentosPorSemaforo('amarelo').length;
    final vermelhos = getAlimentosPorSemaforo('vermelho').length;

    return {
      'verde': verdes,
      'amarelo': amarelos,
      'vermelho': vermelhos,
      'total': verdes + amarelos + vermelhos,
    };
  }

  // ============================================================================
  // MÉTODOS PARA SEMÁFORO FOCADO NO ÍNDICE GLICÊMICO
  // ============================================================================

  /// Obtém estatísticas de alimentos por categorias do semáforo nutricional
  /// focando no índice glicêmico
  Map<String, int> getEstatisticasIndiceGlicemico() {
    final baixo = getAlimentosPorSemaforo('verde').length; // Baixo IG
    final moderado = getAlimentosPorSemaforo('amarelo').length; // Moderado IG
    final alto = getAlimentosPorSemaforo('vermelho').length; // Alto IG

    return {
      'baixo': baixo,
      'moderado': moderado,
      'alto': alto,
      'total': baixo + moderado + alto,
    };
  }

  /// Busca alimentos por nome ou descrição
  List<AlimentoNutricional> buscarPorTexto(String query) {
    if (query.isEmpty) return getTodosAlimentos();

    final queryLower = query.toLowerCase();
    return _alimentos
        .where(
          (alimento) =>
              alimento.nome.toLowerCase().contains(queryLower) ||
              alimento.descricao.toLowerCase().contains(queryLower),
        )
        .toList();
  }

  /// Lista de pratos virtuais vazios para começar a montagem
  static List<Map<String, dynamic>> getPratosVazios() {
    return [
      {
        'nome': 'Prato do Dia',
        'descricao': 'Monte seu prato equilibrado',
        'icone': '🍽️',
        'semaforo': 'neutro',
        'alimentos': <AlimentoNutricional>[],
      },
      {
        'nome': 'Lanche Saudável',
        'descricao': 'Para os intervalos',
        'icone': '🥪',
        'semaforo': 'neutro',
        'alimentos': <AlimentoNutricional>[],
      },
      {
        'nome': 'Sobremesa',
        'descricao': 'Para adoçar o dia',
        'icone': '🍨',
        'semaforo': 'neutro',
        'alimentos': <AlimentoNutricional>[],
      },
    ];
  }
}

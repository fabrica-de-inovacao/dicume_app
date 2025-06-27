import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/mock_data_service_regional.dart';

class MeuDiaScreen extends StatefulWidget {
  const MeuDiaScreen({super.key});

  @override
  State<MeuDiaScreen> createState() => _MeuDiaScreenState();
}

class _MeuDiaScreenState extends State<MeuDiaScreen> {
  final mockService = SuperMockDataService();
  late List<Map<String, dynamic>> refeicoesHoje;
  late Map<String, int> resumoDia;

  @override
  void initState() {
    super.initState();
    _carregarDadosDia();
  }

  void _carregarDadosDia() {
    // Simula as refeições do dia atual
    refeicoesHoje = [
      {
        'tipo': 'Café da Manhã',
        'horario': '07:30',
        'alimentos': [
          {
            'nome': 'Tapioca',
            'semaforo': 'amarelo',
            'quantidade': '2 unidades',
          },
          {'nome': 'Banana', 'semaforo': 'verde', 'quantidade': '1 unidade'},
          {'nome': 'Café', 'semaforo': 'verde', 'quantidade': '1 xícara'},
        ],
        'icone': Icons.free_breakfast,
        'cor': AppColors.warning,
      },
      {
        'tipo': 'Lanche da Manhã',
        'horario': '10:00',
        'alimentos': [
          {
            'nome': 'Castanha do Pará',
            'semaforo': 'verde',
            'quantidade': '5 unidades',
          },
        ],
        'icone': Icons.local_cafe,
        'cor': AppColors.success,
      },
      {
        'tipo': 'Almoço',
        'horario': '12:30',
        'alimentos': [
          {
            'nome': 'Arroz integral',
            'semaforo': 'amarelo',
            'quantidade': '3 colheres',
          },
          {
            'nome': 'Feijão verde',
            'semaforo': 'verde',
            'quantidade': '1 concha',
          },
          {
            'nome': 'Peixe grelhado',
            'semaforo': 'verde',
            'quantidade': '1 filé',
          },
          {
            'nome': 'Salada mista',
            'semaforo': 'verde',
            'quantidade': '1 prato',
          },
        ],
        'icone': Icons.restaurant,
        'cor': AppColors.success,
      },
      {
        'tipo': 'Lanche da Tarde',
        'horario': '15:30',
        'alimentos': [
          {'nome': 'Caju', 'semaforo': 'verde', 'quantidade': '2 unidades'},
          {'nome': 'Água de coco', 'semaforo': 'verde', 'quantidade': '1 copo'},
        ],
        'icone': Icons.local_drink,
        'cor': AppColors.success,
      },
    ];

    // Calcula resumo do dia
    resumoDia = _calcularResumoDia();
  }

  Map<String, int> _calcularResumoDia() {
    int verde = 0, amarelo = 0, vermelho = 0;

    for (var refeicao in refeicoesHoje) {
      for (var alimento in refeicao['alimentos']) {
        switch (alimento['semaforo']) {
          case 'verde':
            verde++;
            break;
          case 'amarelo':
            amarelo++;
            break;
          case 'vermelho':
            vermelho++;
            break;
        }
      }
    }

    return {
      'verde': verde,
      'amarelo': amarelo,
      'vermelho': vermelho,
      'total': verde + amarelo + vermelho,
    };
  }

  Color _getSemaforoColor(String semaforo) {
    switch (semaforo) {
      case 'verde':
        return AppColors.success;
      case 'amarelo':
        return AppColors.warning;
      case 'vermelho':
        return AppColors.error;
      default:
        return AppColors.grey400;
    }
  }

  String _getStatusDia() {
    final porcentagemVerde = (resumoDia['verde']! / resumoDia['total']!) * 100;

    if (porcentagemVerde >= 70) {
      return 'Excelente! Dia muito saudável 🌟';
    } else if (porcentagemVerde >= 50) {
      return 'Bom dia! Continue assim 👍';
    } else {
      return 'Que tal mais verdes? 💚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Meu Dia',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            FeedbackService().lightTap();
            context.go('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: AppColors.primary),
            onPressed: () {
              FeedbackService().lightTap();
              _mostrarSeletorData(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do dia
            _buildResumoDia(textTheme),
            const SizedBox(height: 24),

            // Lista de refeições
            _buildListaRefeicoes(textTheme),

            const SizedBox(height: 100), // Espaço para FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FeedbackService().mediumTap();
          context.go('/montar-prato-virtual');
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova Refeição'),
      ),
    );
  }

  Widget _buildResumoDia(TextTheme textTheme) {
    final porcentagemVerde = (resumoDia['verde']! / resumoDia['total']!) * 100;

    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.today,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoje, ${DateTime.now().day}/${DateTime.now().month}',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getStatusDia(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Semáforo do dia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIndicadorSemaforo(
                      cor: AppColors.success,
                      valor: resumoDia['verde']!,
                      label: 'Verde',
                    ),
                    _buildIndicadorSemaforo(
                      cor: AppColors.warning,
                      valor: resumoDia['amarelo']!,
                      label: 'Amarelo',
                    ),
                    _buildIndicadorSemaforo(
                      cor: AppColors.error,
                      valor: resumoDia['vermelho']!,
                      label: 'Vermelho',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Barra de progresso
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      if (resumoDia['verde']! > 0)
                        Expanded(
                          flex: resumoDia['verde']!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      if (resumoDia['amarelo']! > 0)
                        Expanded(
                          flex: resumoDia['amarelo']!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      if (resumoDia['vermelho']! > 0)
                        Expanded(
                          flex: resumoDia['vermelho']!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${porcentagemVerde.toInt()}% alimentos verdes hoje',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicadorSemaforo({
    required Color cor,
    required int valor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: cor, width: 2),
          ),
          child: Center(
            child: Text(
              valor.toString(),
              style: TextStyle(
                color: cor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: cor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildListaRefeicoes(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suas Refeições',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        ...refeicoesHoje.map(
          (refeicao) => _buildCardRefeicao(refeicao, textTheme),
        ),
      ],
    );
  }

  Widget _buildCardRefeicao(
    Map<String, dynamic> refeicao,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DicumeElegantCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da refeição
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (refeicao['cor'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    refeicao['icone'],
                    color: refeicao['cor'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        refeicao['tipo'],
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        refeicao['horario'],
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () {
                    FeedbackService().lightTap();
                    _editarRefeicao(refeicao);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de alimentos
            ...refeicao['alimentos'].map<Widget>((alimento) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Indicador semáforo
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getSemaforoColor(alimento['semaforo']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nome do alimento
                    Expanded(
                      child: Text(
                        alimento['nome'],
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Quantidade
                    Text(
                      alimento['quantidade'],
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _mostrarSeletorData(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        // Aqui carregaria os dados do dia selecionado
        FeedbackService().mediumTap();
      }
    });
  }

  void _editarRefeicao(Map<String, dynamic> refeicao) {
    // Aqui abriria um modal ou navegaria para editar a refeição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando ${refeicao['tipo']}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

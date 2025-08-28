import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/refeicao_do_dia_model.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/alimento_display_helper.dart'; // Importar o helper

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class MeuDiaScreen extends ConsumerStatefulWidget {
  const MeuDiaScreen({super.key});

  @override
  ConsumerState<MeuDiaScreen> createState() => _MeuDiaScreenState();
}

class _MeuDiaScreenState extends ConsumerState<MeuDiaScreen> {
  late Future<List<RefeicaoDoDiaModel>> _refeicoesFuture;
  List<RefeicaoDoDiaModel> _refeicoesHoje = [];
  Map<String, int> _resumoDia = {'verde': 0, 'amarelo': 0, 'vermelho': 0, 'total': 0};

  @override
  void initState() {
    super.initState();
    _carregarDadosDia(ref.read(selectedDateProvider));
  }

  @override
  void didUpdateWidget(covariant MeuDiaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recarrega os dados se a data selecionada mudar
    final newDate = ref.read(selectedDateProvider);
    if (newDate != ref.read(selectedDateProvider)) {
      _carregarDadosDia(newDate);
    }
  }

  void _carregarDadosDia(DateTime date) {
    final apiService = ref.read(apiServiceProvider);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    _refeicoesFuture = apiService.getRefeicoesDoDia(formattedDate).then((refeicoes) {
      setState(() {
        _refeicoesHoje = refeicoes;
        _resumoDia = _calcularResumoDia();
      });
      return refeicoes;
    }).catchError((error) {
      // Tratar erro, talvez mostrar um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar refeições: $error'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() {
        _refeicoesHoje = [];
        _resumoDia = {'verde': 0, 'amarelo': 0, 'vermelho': 0, 'total': 0};
      });
      return [];
    });
  }

  Map<String, int> _calcularResumoDia() {
    int verde = 0, amarelo = 0, vermelho = 0;

    for (var refeicao in _refeicoesHoje) {
      switch (refeicao.classificacaoFinal.toLowerCase()) {
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

    return {
      'verde': verde,
      'amarelo': amarelo,
      'vermelho': vermelho,
      'total': verde + amarelo + vermelho,
    };
  }

  Color _getSemaforoColor(String classificacao) {
    switch (classificacao.toLowerCase()) {
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
    if (_resumoDia['total'] == 0) return 'Nenhuma refeição registrada hoje.';
    final porcentagemVerde = (_resumoDia['verde']! / _resumoDia['total']!) * 100;

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
    final selectedDate = ref.watch(selectedDateProvider);

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
              _mostrarSeletorData(context, selectedDate);
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
            _buildResumoDia(textTheme, selectedDate),
            const SizedBox(height: 24),

            // Lista de refeições
            FutureBuilder<List<RefeicaoDoDiaModel>>(
              future: _refeicoesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Exibir erro real da API
                  return Center(
                    child: Text(
                      'Erro ao carregar refeições: ${snapshot.error}',
                      style: textTheme.bodyLarge?.copyWith(color: AppColors.error),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  // Quando não há dados, mas sem erro
                  return Center(
                    child: Text(
                      'Nenhuma refeição registrada para esta data.',
                      style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return _buildListaRefeicoes(textTheme, snapshot.data!);
                } else {
                  // Caso padrão, pode ser um estado inicial sem dados
                  return const SizedBox.shrink();
                }
              },
            ),

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

  Widget _buildResumoDia(TextTheme textTheme, DateTime selectedDate) {
    final porcentagemVerde = _resumoDia['total']! > 0
        ? (_resumoDia['verde']! / _resumoDia['total']!) * 100
        : 0.0;

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
                      '${DateFormat('dd/MM').format(selectedDate)}',
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
                      valor: _resumoDia['verde']!,
                      label: 'Verde',
                    ),
                    _buildIndicadorSemaforo(
                      cor: AppColors.warning,
                      valor: _resumoDia['amarelo']!,
                      label: 'Amarelo',
                    ),
                    _buildIndicadorSemaforo(
                      cor: AppColors.error,
                      valor: _resumoDia['vermelho']!,
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
                      if (_resumoDia['verde']! > 0)
                        Expanded(
                          flex: _resumoDia['verde']!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      if (_resumoDia['amarelo']! > 0)
                        Expanded(
                          flex: _resumoDia['amarelo']!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      if (_resumoDia['vermelho']! > 0)
                        Expanded(
                          flex: _resumoDia['vermelho']!,
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

  Widget _buildListaRefeicoes(TextTheme textTheme, List<RefeicaoDoDiaModel> refeicoes) {
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

        ...refeicoes.map(
          (refeicao) => _buildCardRefeicao(refeicao, textTheme),
        ),
      ],
    );
  }

  Widget _buildCardRefeicao(
    RefeicaoDoDiaModel refeicao,
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
                    color: (refeicao.cor ?? AppColors.grey400).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    refeicao.icone ?? Icons.fastfood,
                    color: refeicao.cor ?? AppColors.grey400,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        refeicao.tipoRefeicao,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        refeicao.horario ?? 'N/A',
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
            ...refeicao.itens.map<Widget>((item) {
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
                        color: _getSemaforoColor(refeicao.classificacaoFinal),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nome do alimento
                    Expanded(
                      child: Text(
                        item.alimentos.nomePopular,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Quantidade
                    Text(
                      AlimentoDisplayHelper.getRecomendacaoConsumoFriendly(
                        '${item.quantidadeBase} ${item.alimentos.recomendacaoConsumo}',
                      ),
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

  void _mostrarSeletorData(BuildContext context, DateTime initialDate) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
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
        FeedbackService().mediumTap();
        ref.read(selectedDateProvider.notifier).state = selectedDate;
        _carregarDadosDia(selectedDate);
      }
    });
  }

  void _editarRefeicao(RefeicaoDoDiaModel refeicao) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando ${refeicao.tipoRefeicao}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

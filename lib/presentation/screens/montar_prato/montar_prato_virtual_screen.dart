import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/mock_data_service_regional.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';
import '../../../data/providers/refeicao_providers.dart';
import '../../../domain/entities/refeicao.dart';
import '../auth/auth_modal_screen.dart';

class MontarPratoVirtualScreen extends ConsumerStatefulWidget {
  const MontarPratoVirtualScreen({super.key});

  @override
  ConsumerState<MontarPratoVirtualScreen> createState() =>
      _MontarPratoVirtualScreenState();
}

class _MontarPratoVirtualScreenState
    extends ConsumerState<MontarPratoVirtualScreen>
    with TickerProviderStateMixin {
  final mockService = SuperMockDataService();
  late AnimationController _plateController;
  late Animation<double> _plateScale;

  List<AlimentoNutricional> pratoAtual = [];
  Map<String, dynamic> estatisticasPrato = {
    'calorias': 0.0,
    'proteinas': 0.0,
    'carboidratos': 0.0,
    'gorduras': 0.0,
    'fibras': 0.0,
    'semaforo': 'neutro',
  };

  @override
  void initState() {
    super.initState();
    _plateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _plateScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _plateController, curve: Curves.elasticOut),
    );

    // Animação inicial do prato
    Future.delayed(const Duration(milliseconds: 300), () {
      _plateController.forward();
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  void _adicionarAlimento(AlimentoNutricional alimento) {
    if (mounted) {
      setState(() {
        pratoAtual.add(alimento);
        _atualizarEstatisticas();
      });

      // Feedback tátil e animação
      FeedbackService().lightTap();
      _plateController.reset();
      _plateController.forward();
    }
  }

  void _removerAlimento(int index) {
    if (index >= 0 && index < pratoAtual.length) {
      setState(() {
        pratoAtual.removeAt(index);
        _atualizarEstatisticas();
      });

      FeedbackService().lightTap();
    }
  }

  void _atualizarEstatisticas() {
    double totalCalorias = 0;
    double totalProteinas = 0;
    double totalCarboidratos = 0;
    double totalGorduras = 0;
    double totalFibras = 0;

    int verdes = 0, amarelos = 0, vermelhos = 0;

    for (var alimento in pratoAtual) {
      totalCalorias += alimento.calorias;
      totalProteinas += alimento.proteinas;
      totalCarboidratos += alimento.carboidratos;
      totalGorduras += alimento.gorduras;
      totalFibras += alimento.fibras;

      switch (alimento.semaforo) {
        case 'verde':
          verdes++;
          break;
        case 'amarelo':
          amarelos++;
          break;
        case 'vermelho':
          vermelhos++;
          break;
      }
    }

    // Determinar semáforo geral do prato
    String semaforoGeral = 'verde';
    if (vermelhos > 0) {
      semaforoGeral = 'vermelho';
    } else if (amarelos > verdes) {
      semaforoGeral = 'amarelo';
    }

    estatisticasPrato = {
      'calorias': totalCalorias,
      'proteinas': totalProteinas,
      'carboidratos': totalCarboidratos,
      'gorduras': totalGorduras,
      'fibras': totalFibras,
      'semaforo': semaforoGeral,
      'verdes': verdes,
      'amarelos': amarelos,
      'vermelhos': vermelhos,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          FeedbackService().lightTap();
          if (context.mounted) {
            context.go('/home');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Monte seu Prato Virtual',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              FeedbackService().lightTap();
              if (mounted) {
                context.pop();
              }
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Prato Virtual
              _buildPratoVirtual(textTheme),

              // Estatísticas do prato
              if (pratoAtual.isNotEmpty) _buildEstatisticasPrato(textTheme),

              // Lista de alimentos para adicionar
              Expanded(child: _buildListaAlimentos(textTheme)),
            ],
          ),
        ),
        floatingActionButton:
            pratoAtual.isNotEmpty
                ? FloatingActionButton.extended(
                  onPressed: () {
                    if (mounted && pratoAtual.isNotEmpty) {
                      FeedbackService().strongTap();
                      _mostrarResumoFinal(context);
                    }
                  },
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.check, color: AppColors.onPrimary),
                  label: Text(
                    'Finalizar Prato',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildPratoVirtual(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: DicumeElegantCard(
        child: Column(
          children: [
            // Título do prato
            Row(
              children: [
                const Icon(
                  Icons.restaurant,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Seu Prato Virtual',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (pratoAtual.isNotEmpty)
                  DicumeSemaforoNutricional(
                    nivel: estatisticasPrato['semaforo'],
                    descricao: _getDescricaoSemaforo(
                      estatisticasPrato['semaforo'],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Prato visual
            AnimatedBuilder(
              animation: _plateScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _plateScale.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.outline, width: 3),
                      boxShadow: AppColors.mediumShadow,
                    ),
                    child:
                        pratoAtual.isEmpty
                            ? _buildPratoVazio(textTheme)
                            : _buildPratoComAlimentos(textTheme),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Lista de alimentos no prato
            if (pratoAtual.isNotEmpty) _buildListaAlimentosPrato(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildPratoVazio(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 8),
          Text(
            'Prato Vazio',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Adicione alimentos abaixo!',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildPratoComAlimentos(TextTheme textTheme) {
    return Stack(
      children: [
        // Fundo do prato
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8F9FA), Color(0xFFFFFFFF)],
            ),
          ),
        ),

        // Alimentos distribuídos no prato
        ...pratoAtual.asMap().entries.map((entry) {
          final index = entry.key;
          final alimento = entry.value;

          // Posicionamento circular dos alimentos
          final angle = (2 * 3.14159 * index) / pratoAtual.length;
          final radius = 60.0;
          final x = 100 + radius * cos(angle) - 20;
          final y = 100 + radius * sin(angle) - 20;

          return Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onTap: () => _removerAlimento(index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCorSemaforo(alimento.semaforo),
                  border: Border.all(color: AppColors.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    alimento.nome.substring(0, 1).toUpperCase(),
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        // Contador central
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${pratoAtual.length}',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListaAlimentosPrato(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alimentos no prato:',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...pratoAtual.asMap().entries.map((entry) {
          final index = entry.key;
          final alimento = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                DicumeSemaforoNutricional(
                  nivel: alimento.semaforo,
                  descricao: '',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alimento.nome,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _removerAlimento(index),
                  icon: const Icon(Icons.remove_circle_outline, size: 16),
                  color: AppColors.danger,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEstatisticasPrato(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: DicumeElegantCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Nutricionais',
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoNutricional(
                  'Calorias',
                  '${estatisticasPrato['calorias'].toInt()}',
                  'kcal',
                  Icons.local_fire_department,
                  AppColors.warning,
                ),
                const SizedBox(width: 16),
                _buildInfoNutricional(
                  'Proteínas',
                  '${estatisticasPrato['proteinas'].toStringAsFixed(1)}',
                  'g',
                  Icons.fitness_center,
                  AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Semáforo: ',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${estatisticasPrato['verdes']} verdes, ${estatisticasPrato['amarelos']} amarelos, ${estatisticasPrato['vermelhos']} vermelhos',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoNutricional(
    String label,
    String valor,
    String unidade,
    IconData icone,
    Color cor,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(icone, size: 16, color: cor),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            '$valor$unidade',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAlimentos(TextTheme textTheme) {
    final grupos = mockService.getGrupos();

    return DicumeElegantCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adicionar Alimentos',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                final alimentos = mockService.getAlimentosPorGrupo(grupo['id']);

                return ExpansionTile(
                  title: Text(
                    grupo['nome'],
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '${alimentos.length} alimentos disponíveis',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      grupo['icone'] ?? '🍽️',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  children:
                      alimentos.map((alimento) {
                        return ListTile(
                          dense: true,
                          title: Text(
                            alimento.nome,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            alimento.descricao,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          leading: DicumeSemaforoNutricional(
                            nivel: alimento.semaforo,
                            descricao: '',
                          ),
                          trailing: IconButton(
                            onPressed: () => _adicionarAlimento(alimento),
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCorSemaforo(String semaforo) {
    switch (semaforo) {
      case 'verde':
        return AppColors.success;
      case 'amarelo':
        return AppColors.warning;
      case 'vermelho':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getDescricaoSemaforo(String semaforo) {
    switch (semaforo) {
      case 'verde':
        return 'Prato Saudável';
      case 'amarelo':
        return 'Prato Moderado';
      case 'vermelho':
        return 'Prato com Atenção';
      default:
        return 'Sem avaliação';
    }
  }

  void _mostrarResumoFinal(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text('Prato Finalizado!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seu prato foi montado com ${pratoAtual.length} alimentos.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                DicumeSemaforoNutricional(
                  nivel: estatisticasPrato['semaforo'],
                  descricao: _getDescricaoSemaforo(
                    estatisticasPrato['semaforo'],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total: ${estatisticasPrato['calorias'].toInt()} kcal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FeedbackService().lightTap();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Continuar Editando'),
              ),
              ElevatedButton(
                onPressed: () async {
                  FeedbackService().mediumTap();

                  // Fechar o dialog primeiro
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  // Verificar se está logado antes de salvar
                  await _salvarComAutenticacao();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Salvar Prato'),
              ),
            ],
          ),
    );
  }

  Future<void> _salvarComAutenticacao() async {
    try {
      debugPrint(
        '[MONTAR_PRATO] Iniciando processo de salvar com autenticação',
      );

      final authService = AuthService();
      final isLoggedIn = await authService.isLoggedIn();

      debugPrint('[MONTAR_PRATO] Usuário já está logado: $isLoggedIn');

      if (!isLoggedIn) {
        debugPrint('[MONTAR_PRATO] Usuário não está logado, solicitando login');

        // Mostrar modal de login
        if (mounted) {
          final authenticated = await showAuthModal(context);

          debugPrint(
            '[MONTAR_PRATO] Resultado da autenticação: $authenticated',
          );

          if (!authenticated) {
            debugPrint('[MONTAR_PRATO] Usuário cancelou o login, não salvando');
            // Usuário cancelou o login, não salvar
            return;
          }
        }
      }

      debugPrint(
        '[MONTAR_PRATO] Usuário está logado, tentando salvar na API...',
      );

      // Usuário está logado, tentar salvar na API
      await _salvarNaAPI();

      debugPrint(
        '[MONTAR_PRATO] Salvo na API com sucesso, salvando localmente...',
      );

      // Também salvar localmente
      await _salvarRefeicaoLocal();

      debugPrint('[MONTAR_PRATO] Salvo localmente com sucesso');

      // Aguardar um frame antes de navegar
      await Future.delayed(const Duration(milliseconds: 100));

      // Voltar para home
      if (mounted) {
        debugPrint('[MONTAR_PRATO] Navegando de volta para home');
        context.go('/home');
      }
    } catch (e) {
      debugPrint('[MONTAR_PRATO] ERRO no processo de salvar: $e');
      // Em caso de erro, salvar apenas localmente
      await _salvarRefeicaoLocal();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prato salvo localmente. $e'),
            backgroundColor: AppColors.warning,
          ),
        );
        context.go('/home');
      }
    }
  }

  Future<void> _salvarNaAPI() async {
    final apiService = ApiService();
    final now = DateTime.now();
    // Converter alimentos para formato da API
    final itens =
        pratoAtual.map((alimento) {
          return RefeicaoItem(
            alimentoId:
                int.tryParse(alimento.id) ?? 0, // Converter String para int
            quantidadeBase: 1.0, // Quantidade padrão
          );
        }).toList();

    // Determinar tipo de refeição baseado no horário
    String tipoRefeicao;
    final hour = now.hour;
    if (hour >= 6 && hour < 11) {
      tipoRefeicao = 'cafe_manha';
    } else if (hour >= 11 && hour < 15) {
      tipoRefeicao = 'almoco';
    } else if (hour >= 18 && hour < 22) {
      tipoRefeicao = 'jantar';
    } else {
      tipoRefeicao = 'lanche';
    }

    final result = await apiService.registrarRefeicao(
      tipoRefeicao: tipoRefeicao,
      dataRefeicao:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      itens: itens,
    );

    if (!result.success) {
      throw Exception(result.error ?? 'Erro ao salvar na API');
    }
  }

  Future<void> _salvarRefeicaoLocal() async {
    try {
      final refeicaoRepo = ref.read(refeicaoRepositoryProvider);

      // Determinar o tipo de refeição baseado no horário
      final now = DateTime.now();
      final hour = now.hour;

      String tipoRefeicao;
      if (hour >= 5 && hour < 10) {
        tipoRefeicao = 'Café da Manhã';
      } else if (hour >= 10 && hour < 12) {
        tipoRefeicao = 'Lanche da Manhã';
      } else if (hour >= 12 && hour < 15) {
        tipoRefeicao = 'Almoço';
      } else if (hour >= 15 && hour < 18) {
        tipoRefeicao = 'Lanche da Tarde';
      } else if (hour >= 18 && hour < 22) {
        tipoRefeicao = 'Jantar';
      } else {
        tipoRefeicao = 'Ceia';
      } // Preparar dados da refeição
      final itens =
          pratoAtual
              .map(
                (alimento) => ItemRefeicaoPendente(
                  alimentoId: int.tryParse(alimento.id) ?? 0,
                  quantidadeBase: 1.0, // Quantidade padrão
                ),
              )
              .toList();

      final refeicaoPendente = RefeicaoPendente(
        tipoRefeicao: tipoRefeicao,
        dataRefeicao: now.toIso8601String(),
        itens: itens,
        createdAt: now,
      );

      // Salvar refeição
      final result = await refeicaoRepo.salvarRefeicaoOffline(refeicaoPendente);

      result.fold(
        (failure) {
          // Mostrar erro
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Erro ao salvar refeição: ${failure.message}'),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        (success) {
          // Mostrar confirmação
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ $tipoRefeicao salva com sucesso!'),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Mostrar erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao salvar refeição: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

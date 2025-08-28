import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/mock_data_service_regional.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/http_service.dart';
import '../../../data/providers/refeicao_providers.dart';
import '../../../domain/entities/refeicao.dart';
import '../../../domain/entities/alimento.dart';
import '../auth/auth_modal_screen.dart';
import '../buscar/buscar_alimento_screen.dart';
import 'widgets/summary_bottom_sheet.dart';

class MontarPratoVirtualScreen extends ConsumerStatefulWidget {
  const MontarPratoVirtualScreen({super.key});

  @override
  ConsumerState<MontarPratoVirtualScreen> createState() =>
      _MontarPratoVirtualScreenState();
}

class _MontarPratoVirtualScreenState
    extends ConsumerState<MontarPratoVirtualScreen>
    with TickerProviderStateMixin {
  // Estado mínimo necessário — os métodos abaixo usam estas variáveis.
  final List<AlimentoNutricional> pratoAtual = [];
  final Map<String, dynamic> estatisticasPrato = {
    'calorias': 0.0,
    'proteinas': 0.0,
    'carboidratos': 0.0,
    'gorduras': 0.0,
    'fibras': 0.0,
    'semaforo': 'neutro',
  };

  late final AnimationController _plateController;
  late final Animation<double> _plateScale;

  @override
  void initState() {
    super.initState();
    _plateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _plateScale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(_plateController);
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _onFinalizarPressed() async {
    bool confirmed = false;
    try {
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          return SummaryBottomSheet(
            itens: pratoAtual,
            estatisticas: estatisticasPrato,
            onResult: (r) => Navigator.of(sheetContext).pop(r),
          );
        },
      );

      confirmed = result ?? false;
    } catch (e, st) {
      debugPrint('[MONTAR_PRATO] erro ao abrir bottom sheet: $e');
      debugPrint('$st');
      confirmed = false;
    }

    if (confirmed == true && mounted) {
      FeedbackService().strongTap();
      await _salvarComAutenticacao();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: const Text('Montar Prato'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async => await _openBuscarAndAdd(),
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            tooltip: 'Adicionar alimento',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: 96 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              _buildPratoVirtual(textTheme),
              const SizedBox(height: 12),
              _buildEstatisticasPratoCompleto(textTheme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFinalizarPressed,
        label: const Text('Finalizar Prato'),
        icon: const Icon(Icons.check),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _adicionarAlimento(AlimentoNutricional alimento) {
    setState(() {
      pratoAtual.add(alimento);
      _atualizarEstatisticas();
      // animação para chamar atenção
      try {
        _plateController.forward(from: 0);
      } catch (_) {}
    });
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
                if (pratoAtual.isNotEmpty) ...[
                  DicumeSemaforoNutricional(
                    nivel: estatisticasPrato['semaforo'],
                    descricao: _getDescricaoSemaforo(
                      estatisticasPrato['semaforo'],
                    ),
                  ),
                ],
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
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFF7F8FA)],
                        center: Alignment(-0.2, -0.2),
                        radius: 0.9,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: AppColors.outline, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // rim/anel do prato
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            border: Border.all(
                              color: AppColors.grey100,
                              width: 8,
                            ),
                          ),
                        ),
                        pratoAtual.isEmpty
                            ? _buildEmptyStatePrato(textTheme)
                            : _buildPratoComAlimentos(textTheme),
                      ],
                    ),
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

        // Alimentos distribuídos no prato (com foto quando disponível)
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      alimento.imagemUrl.isNotEmpty
                          ? Image.network(
                            alimento.imagemUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (c, e, s) => Container(
                                  color: _getCorSemaforo(alimento.semaforo),
                                  child: Center(
                                    child: Text(
                                      alimento.nome
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: textTheme.labelMedium?.copyWith(
                                        color: AppColors.surface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            color: _getCorSemaforo(alimento.semaforo),
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
                fontWeight: FontWeight.w600,
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
                // Miniatura do alimento
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      alimento.imagemUrl.isNotEmpty
                          ? Image.network(
                            alimento.imagemUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (c, e, s) => Container(
                                  width: 44,
                                  height: 44,
                                  color: AppColors.grey100,
                                  child: Center(
                                    child: Text(
                                      alimento.nome
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: textTheme.labelMedium?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            width: 44,
                            height: 44,
                            color: AppColors.grey100,
                            child: Center(
                              child: Text(
                                alimento.nome.substring(0, 1).toUpperCase(),
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alimento.nome,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      alimento.calorias > 0
                          ? Text(
                            '${alimento.calorias.toInt()} kcal',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            ),
                          )
                          : Text(
                            alimento.descricao.isNotEmpty
                                ? alimento.descricao
                                : alimento.nome,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                    ],
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

  Widget _buildEstatisticasPratoCompleto(TextTheme textTheme) {
    return DicumeElegantCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo Nutricional do Prato',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEstatisticaItem(
                textTheme,
                'Itens',
                '${pratoAtual.length}',
                Icons.restaurant_menu,
                AppColors.primary,
              ),
              _buildEstatisticaItem(
                textTheme,
                'Grupo',
                pratoAtual.isNotEmpty ? 'N/A' : 'N/A',
                Icons.category,
                AppColors.secondary,
              ),
              _buildEstatisticaItem(
                textTheme,
                'Semáforo',
                _getDescricaoSemaforo(estatisticasPrato['semaforo']),
                Icons.circle,
                _getCorSemaforo(estatisticasPrato['semaforo']),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'Macronutrientes:',
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Informações de macronutrientes em breve.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticaItem(
    TextTheme textTheme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          title,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMacroNutrienteItem(
    TextTheme textTheme,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          title,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmptyStatePrato(TextTheme textTheme) {
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
            'Adicione alimentos para começar!',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async => await _openBuscarAndAdd(),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              // Usar FittedBox para reduzir o texto automaticamente se necessário
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Abrir lista', maxLines: 2),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removerAlimento(int index) {
    setState(() {
      if (index >= 0 && index < pratoAtual.length) {
        pratoAtual.removeAt(index);
        _atualizarEstatisticas();
      }
    });
  }

  void _atualizarEstatisticas() {
    double calorias = 0.0;
    double proteinas = 0.0;
    double carboidratos = 0.0;
    double gorduras = 0.0;
    double fibras = 0.0;
    int verdes = 0, amarelos = 0, vermelhos = 0;

    for (final a in pratoAtual) {
      calorias += a.calorias;
      proteinas += a.proteinas;
      carboidratos += a.carboidratos;
      gorduras += a.gorduras;
      fibras += a.fibras;
      switch (a.semaforo) {
        case 'verde':
          verdes++;
          break;
        case 'amarelo':
          amarelos++;
          break;
        case 'vermelho':
          vermelhos++;
          break;
        default:
      }
    }

    String semaforo = 'neutro';
    if (verdes >= amarelos && verdes >= vermelhos && verdes > 0)
      semaforo = 'verde';
    else if (amarelos >= verdes && amarelos >= vermelhos && amarelos > 0)
      semaforo = 'amarelo';
    else if (vermelhos > 0)
      semaforo = 'vermelho';

    setState(() {
      estatisticasPrato['calorias'] = calorias;
      estatisticasPrato['proteinas'] = proteinas;
      estatisticasPrato['carboidratos'] = carboidratos;
      estatisticasPrato['gorduras'] = gorduras;
      estatisticasPrato['fibras'] = fibras;
      estatisticasPrato['semaforo'] = semaforo;
      estatisticasPrato['verdes'] = verdes;
      estatisticasPrato['amarelos'] = amarelos;
      estatisticasPrato['vermelhos'] = vermelhos;
    });
  }

  Future<void> _openBuscarAndAdd() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>?>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.35),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const BuscarAlimentoScreen(),
          );
        },
      ),
    );
    if (result != null) {
      final alimento = result['alimento'] as Alimento;
      final quantidade = result['quantidade'] as double;

      final item = AlimentoNutricional(
        id: alimento.id.toString(),
        nome: alimento.nomePopular,
        grupoId: alimento.grupoDicume,
        calorias: 0.0, // Estes valores ainda não são calculados por quantidade
        carboidratos: 0.0,
        proteinas: 0.0,
        gorduras: 0.0,
        fibras: 0.0,
        sodio: 0.0,
        semaforo:
            alimento.classificacaoCor.isNotEmpty
                ? alimento.classificacaoCor
                : 'neutro',
        descricao: alimento.recomendacaoConsumo,
        imagemUrl: alimento.fotoPorcaoUrl,
        quantidadeBase: quantidade, // Usar a quantidade selecionada
      );

      _adicionarAlimento(item);
    }
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

      // Usuário está logado, tentar salvar na API usando helper que monta payload
      try {
        await _salvarNaAPI();
      } on AppException catch (e) {
        if (e.type == AppExceptionType.auth) {
          debugPrint(
            '[MONTAR_PRATO] AppException auth recebido, solicitando login e re-tentando',
          );
          if (mounted) {
            final authenticated = await showAuthModal(context);
            if (!authenticated) {
              throw Exception('Acesso negado. Faça login novamente.');
            }

            // Re-tentar
            await _salvarNaAPI();
          }
        } else {
          rethrow;
        }
      }

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
          // Enviar o id tal como está no mock (String). A API aceita strings/UUIDs.
          return RefeicaoItem(
            alimentoId: alimento.id.toString(),
            quantidadeBase: 1.0,
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
      // Se o erro for de autenticação, transformar em AppException para ser
      // capturado no chamador e permitir reautenticação.
      if (result.errorType == AppExceptionType.auth) {
        throw AppException(
          result.error ?? 'Acesso negado',
          type: AppExceptionType.auth,
        );
      }
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
                  alimentoId: alimento.id,
                  quantidadeBase: 1.0, // Quantidade padrão
                ),
              )
              .toList();

      final refeicaoPendente = RefeicaoPendente(
        tipoRefeicao: tipoRefeicao,
        dataRefeicao:
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        itens: itens,
        createdAt: now,
      );

      // Salvar refeição
      final result = await refeicaoRepo.salvarRefeicaoOffline(refeicaoPendente);

      result.fold(
        (failure) {
          // Mostrar erro
          if (mounted) {
            kDebugMode
                ? print('❌ Erro ao salvar refeição: ${failure.message}')
                : null;
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
            kDebugMode ? print('✅ $tipoRefeicao salva com sucesso!') : null;
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

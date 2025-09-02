import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/auth_utils.dart';
import '../../../data/providers/alimento_providers.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/home_banner_carousel.dart';
import '../../../data/providers/refeicao_providers.dart'; // Importar o novo provider
import 'package:intl/intl.dart'; // Para formatar a data

class HomeScreenElegante extends ConsumerStatefulWidget {
  const HomeScreenElegante({super.key});

  @override
  ConsumerState<HomeScreenElegante> createState() => _HomeScreenEleganteState();
}

class _HomeScreenEleganteState extends ConsumerState<HomeScreenElegante> {
  // Para área de desenvolvedor
  // int _tapCount = 0;
  // DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authState = ref.watch(authControllerProvider);

    // Disparar sincronização de alimentos na inicialização da tela
    ref.watch(alimentosCacheProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _mostrarConfirmacaoSaida(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho com avatar do usuário
                _buildCabecalhoUsuario(textTheme, authState),
                const SizedBox(height: 24),

                // PRIORIDADE 1: Card CTA principal (DESTACADO)
                _buildCardCTADestacado(context, textTheme),
                const SizedBox(height: 24),

                // Carrossel de Banners
                const HomeBannerCarousel(),
                const SizedBox(height: 24),

                // PRIORIDADE 2: Semáforo do dia (logo após saudação)
                _buildSemaforoEstatisticas(context, textTheme),
                const SizedBox(height: 24),

                // Atalho "Seu Dia Hoje"
                _buildAtalhoMeuDia(textTheme),
                const SizedBox(height: 24),

                // Dicas rápidas
                _buildDicasRapidas(textTheme), const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardCTADestacado(BuildContext context, TextTheme textTheme) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            await FeedbackService().strongTap();
            if (mounted) {
              final isAuthenticated = await AuthUtils.requireAuthentication(
                context,
                ref,
                message:
                    'Para montar um prato e salvá-lo, você precisa estar logado.',
              );
              if (isAuthenticated && mounted) {
                context.go(AppRoutes.montarPratoVirtual);
              }
            }
          },
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hora de Montar o Prato!',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Crie uma refeição saudável e balanceada em poucos passos.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Começar Agora',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemaforoEstatisticas(BuildContext context, TextTheme textTheme) {
    final authState = ref.watch(authControllerProvider);

    // Se não está autenticado, mostrar uma versão simplificada sem dados do servidor
    if (!authState.isAuthenticated) {
      return _buildSemaforoSimplificado(context, textTheme);
    }

    final perfilStatusAsync = ref.watch(perfilStatusProvider);

    return perfilStatusAsync.when(
      data: (perfilStatus) {
        // Calcular semáforo hoje com base nas últimas refeições
        Map<String, int> semaforoHoje = {
          'verde': 0,
          'amarelo': 0,
          'vermelho': 0,
          'total': 0,
        };

        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final refeicoesHoje =
            perfilStatus.ultimasRefeicoes
                .where((r) => r.dataRefeicao == today)
                .toList();

        for (var refeicao in refeicoesHoje) {
          semaforoHoje[refeicao.classificacaoFinal] =
              (semaforoHoje[refeicao.classificacaoFinal] ?? 0) + 1;
          semaforoHoje['total'] = (semaforoHoje['total'] ?? 0) + 1;
        }

        String statusDia = _calcularStatusDia(semaforoHoje);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: DicumeElegantCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header com animação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Título com destaque
                          Text(
                            'Seu Dia Hoje',
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Semáforo com pulso
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.9, end: 1.1),
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.easeInOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: DicumeSemaforoNutricional(
                                  nivel: statusDia,
                                  descricao: _getDescricaoStatus(statusDia),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Grid de estatísticas com animação
                      Row(
                        children:
                            semaforoHoje.entries
                                .where((e) => e.key != 'total')
                                .map((entry) {
                                  Color cor = _getCorSemaforo(entry.key);
                                  return Expanded(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: entry.value.toDouble(),
                                      ),
                                      duration: Duration(
                                        milliseconds:
                                            800 +
                                            (semaforoHoje.keys.toList().indexOf(
                                                  entry.key,
                                                ) *
                                                200),
                                      ),
                                      curve: Curves.elasticOut,
                                      builder: (context, animatedValue, child) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: cor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: cor.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Contador animado
                                              Text(
                                                animatedValue
                                                    .toInt()
                                                    .toString(),
                                                style: textTheme.headlineMedium
                                                    ?.copyWith(
                                                      color: cor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),

                                              // Label
                                              Text(
                                                entry.key.toUpperCase(),
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: cor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                })
                                .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Progresso visual
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOut,
                            builder: (context, progress, child) {
                              return Row(
                                children: [
                                  if (semaforoHoje['verde']! > 0)
                                    Expanded(
                                      flex:
                                          (semaforoHoje['verde']! * progress)
                                              .toInt(),
                                      child: Container(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  if (semaforoHoje['amarelo']! > 0)
                                    Expanded(
                                      flex:
                                          (semaforoHoje['amarelo']! * progress)
                                              .toInt(),
                                      child: Container(
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  if (semaforoHoje['vermelho']! > 0)
                                    Expanded(
                                      flex:
                                          (semaforoHoje['vermelho']! * progress)
                                              .toInt(),
                                      child: Container(color: AppColors.error),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Texto motivacional
                      Center(
                        child: Text(
                          'Total: ${semaforoHoje['total']} alimentos hoje',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
    );
  }

  Widget _buildSemaforoSimplificado(BuildContext context, TextTheme textTheme) {
    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seu Dia Hoje',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DicumeSemaforoNutricional(
                nivel: 'verde',
                descricao: 'Novo dia! 🌟',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Icon(Icons.login, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Faça login para acompanhar suas refeições',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: DicumeElegantButton(
                    text: 'Fazer Login',
                    onPressed: () async {
                      final isAuthenticated =
                          await AuthUtils.requireAuthentication(
                            context,
                            ref,
                            message:
                                'Faça login para acompanhar suas refeições.',
                          );
                      if (isAuthenticated) {
                        // Provider será atualizado automaticamente
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calcularStatusDia(Map<String, int> semaforoHoje) {
    final total = semaforoHoje['total']!;
    final verdes = semaforoHoje['verde']!;
    final vermelhos = semaforoHoje['vermelho']!;

    if (total == 0) return 'verde'; // Dia começando

    final percentualVerde = verdes / total;
    final percentualVermelho = vermelhos / total;

    if (percentualVermelho > 0.3) {
      return 'vermelho'; // Muitos alimentos de alto IG
    }
    if (percentualVerde >= 0.6) return 'verde'; // Maioria de baixo IG
    return 'amarelo'; // Moderado
  }

  Color _getCorSemaforo(String semaforo) {
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

  Widget _buildDicasRapidas(TextTheme textTheme) {
    final dicas = [
      {
        'icone': Icons.lightbulb_outline,
        'titulo': 'Dica do Dia',
        'texto':
            'Comece sempre com os alimentos verdes - eles podem ser consumidos à vontade!',
        'cor': AppColors.success,
      },
      {
        'icone': Icons.favorite_outline,
        'titulo': 'Alimentação Regional',
        'texto':
            'Priorizamos alimentos típicos do Nordeste, frescos e nutritivos da nossa terra!',
        'cor': AppColors.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dicas Rápidas',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...dicas.map(
          (dica) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: DicumeElegantCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (dica['cor'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      dica['icone'] as IconData,
                      color: dica['cor'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dica['titulo'] as String,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dica['texto'] as String,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCabecalhoUsuario(TextTheme textTheme, AuthState? authState) {
    // Verificar se está autenticado antes de usar dados do usuário
    final isAuthenticated = authState?.isAuthenticated ?? false;

    // Obter nome do usuário ou usar padrão
    final nomeUsuario =
        isAuthenticated
            ? (authState?.user?.nome ?? 'Usuário DICUMÊ')
            : 'Usuário DICUMÊ';
    final primeiroNome = nomeUsuario.split(' ').first;

    // Gerar iniciais do usuário
    final iniciais = _gerarIniciais(nomeUsuario);

    // Gerar saudação baseada no horário
    final saudacao = _getSaudacaoHorario();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Informações do usuário
        Row(
          children: [
            GestureDetector(
              onTap: () {
                FeedbackService().lightTap();
                context.go('/perfil-usuario');
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                backgroundImage:
                    (isAuthenticated &&
                            authState?.user?.avatarUrl != null &&
                            authState!.user!.avatarUrl!.isNotEmpty)
                        ? NetworkImage(authState.user!.avatarUrl!)
                        : null,
                child:
                    (!isAuthenticated ||
                            authState?.user?.avatarUrl == null ||
                            authState!.user!.avatarUrl!.isEmpty)
                        ? Text(
                          iniciais,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primeiroNome,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  saudacao,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Botão de notificações
        IconButton(
          onPressed: () {
            FeedbackService().lightTap();
            // TODO: Abrir notificações
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAtalhoMeuDia(TextTheme textTheme) {
    final authState = ref.watch(authControllerProvider);

    // Se não está autenticado, mostrar versão simplificada
    if (!authState.isAuthenticated) {
      return _buildAtalhoMeuDiaSimplificado(textTheme);
    }

    final perfilStatusAsync = ref.watch(perfilStatusProvider);

    return perfilStatusAsync.when(
      data: (perfilStatus) {
        Map<String, int> semaforoHoje = {
          'verde': 0,
          'amarelo': 0,
          'vermelho': 0,
          'total': 0,
        };

        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final refeicoesHoje =
            perfilStatus.ultimasRefeicoes
                .where((r) => r.dataRefeicao == today)
                .toList();

        for (var refeicao in refeicoesHoje) {
          semaforoHoje[refeicao.classificacaoFinal] =
              (semaforoHoje[refeicao.classificacaoFinal] ?? 0) + 1;
          semaforoHoje['total'] = (semaforoHoje['total'] ?? 0) + 1;
        }

        return DicumeElegantCard(
          child: InkWell(
            onTap: () async {
              FeedbackService().mediumTap();

              final isAuthenticated = await AuthUtils.requireAuthentication(
                context,
                ref,
                message:
                    'Para ver o histórico personalizado do seu dia, você precisa estar logado.',
              );

              if (isAuthenticated && mounted) {
                context.go('/meu-dia');
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
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
                            'Seu Dia Hoje',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Veja todas as suas refeições de hoje',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Resumo rápido do dia
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildResumoIndicador(
                        cor: AppColors.success,
                        valor: semaforoHoje['verde']!,
                        label: 'Verde',
                      ),
                      const SizedBox(width: 16),
                      _buildResumoIndicador(
                        cor: AppColors.warning,
                        valor: semaforoHoje['amarelo']!,
                        label: 'Amarelo',
                      ),
                      const SizedBox(width: 16),
                      _buildResumoIndicador(
                        cor: AppColors.error,
                        valor: semaforoHoje['vermelho']!,
                        label: 'Vermelho',
                      ),
                      const Spacer(),
                      Text(
                        '${semaforoHoje['total']} alimentos',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading:
          () =>
              const SizedBox.shrink(), // Ou um CircularProgressIndicator menor
      error:
          (err, stack) =>
              const SizedBox.shrink(), // Ou um Text('Erro ao carregar dados')
    );
  }

  Widget _buildAtalhoMeuDiaSimplificado(TextTheme textTheme) {
    return DicumeElegantCard(
      child: InkWell(
        onTap: () async {
          FeedbackService().mediumTap();

          final isAuthenticated = await AuthUtils.requireAuthentication(
            context,
            ref,
            message:
                'Faça login para ver o histórico personalizado do seu dia.',
          );

          if (isAuthenticated && mounted) {
            context.go('/meu-dia');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.today,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seu Dia Hoje',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Faça login para ver suas refeições',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.lock_outline, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Entre para acompanhar seus alimentos do dia',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoIndicador({
    required Color cor,
    required int valor,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$valor',
          style: TextStyle(
            color: cor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // String _calcularStatusDia(Map<String, int> semaforoHoje) {
  //   final total = semaforoHoje['total']!;
  //   final verdes = semaforoHoje['verde']!;
  //   final vermelhos = semaforoHoje['vermelho']!;

  //   if (total == 0) return 'verde'; // Dia começando

  //   final percentualVerde = verdes / total;
  //   final percentualVermelho = vermelhos / total;

  //   if (percentualVermelho > 0.3)
  //     return 'vermelho'; // Muitos alimentos de alto IG
  //   if (percentualVerde >= 0.6) return 'verde'; // Maioria de baixo IG
  //   return 'amarelo'; // Moderado
  // }

  // Color _getCorStatus(String status) {
  //   switch (status) {
  //     case 'verde':
  //       return AppColors.success;
  //     case 'amarelo':
  //       return AppColors.warning;
  //     case 'vermelho':
  //       return AppColors.error;
  //     default:
  //       return AppColors.success;
  //   }
  // }

  String _getDescricaoStatus(String status) {
    switch (status) {
      case 'verde':
        return 'Excelente dia! 🌟';
      case 'amarelo':
        return 'Bom dia! 👍';
      case 'vermelho':
        return 'Atenção hoje 🚨';
      default:
        return 'Excelente dia! 🌟';
    }
  }

  void _mostrarConfirmacaoSaida(BuildContext context) {
    FeedbackService().mediumTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador de arrastar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // Ícone
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: AppColors.warning,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),

                // Título
                Text(
                  'Sair do DICUMÊ?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Descrição
                Text(
                  'Tem certeza que deseja sair do aplicativo? Seus dados estão salvos e você pode voltar a qualquer momento!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32), // Botões
                Row(
                  children: [
                    // Botão Cancelar
                    Expanded(
                      child: DicumeElegantButton(
                        onPressed: () {
                          FeedbackService().lightTap();
                          Navigator.of(context).pop();
                        },
                        text: 'Cancelar',
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: 16), // Botão Sair
                    Expanded(
                      child: DicumeElegantButton(
                        onPressed: () {
                          FeedbackService().strongTap();
                          Navigator.of(context).pop();
                          // Sair do app
                          SystemNavigator.pop();
                        },
                        text: 'Sair',
                        isSecondary: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  // void _handleDeveloperTap() {
  //   // Só funciona em modo debug
  //   if (!kDebugMode) return;

  //   final now = DateTime.now();

  //   // Reset se passou mais de 2 segundos desde o último tap
  //   if (_lastTapTime == null || now.difference(_lastTapTime!).inSeconds > 2) {
  //     _tapCount = 1;
  //   } else {
  //     _tapCount++;
  //   }

  //   _lastTapTime = now;

  //   // Se chegou a 5 taps, abre a área de desenvolvedor
  //   if (_tapCount >= 5) {
  //     _tapCount = 0;
  //     _lastTapTime = null;

  //     FeedbackService().strongTap();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('🧑‍💻 Área de desenvolvedor ativada!'),
  //         backgroundColor: AppColors.error,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );

  //     context.go(AppRoutes.developer);
  //   } else if (_tapCount >= 3) {
  //     // Dica visual após 3 taps
  //     FeedbackService().mediumTap();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('🔓 Continue... ($_tapCount/5)'),
  //         backgroundColor: AppColors.primary,
  //         duration: const Duration(seconds: 1),
  //       ),
  //     );
  //   }
  // }

  // Métodos auxiliares para dados do usuário
  String _gerarIniciais(String nomeCompleto) {
    if (nomeCompleto.isEmpty) return 'U';

    final palavras = nomeCompleto.trim().split(' ');

    if (palavras.length == 1) {
      return palavras[0].substring(0, 1).toUpperCase();
    }

    return '${palavras[0].substring(0, 1)}${palavras[palavras.length - 1].substring(0, 1)}'
        .toUpperCase();
  }

  String _getSaudacaoHorario() {
    final agora = DateTime.now();
    final hora = agora.hour;

    if (hora >= 5 && hora < 12) {
      return 'Bom dia! ☀️';
    } else if (hora >= 12 && hora < 18) {
      return 'Boa tarde! 🌤️';
    } else {
      return 'Boa noite! 🌙';
    }
  }
}

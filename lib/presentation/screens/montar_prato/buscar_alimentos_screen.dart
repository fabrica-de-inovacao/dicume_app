import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/alimento.dart';
import '../../../core/providers/feedback_providers.dart';
import '../../../data/providers/alimento_providers.dart';

// Provider que busca alimentos do BANCO LOCAL (offline-first)
final buscarAlimentosProvider = FutureProvider.family<List<Alimento>, String>((
  ref,
  query,
) async {
  final alimentosRepository = ref.watch(alimentoRepositoryProvider);

  if (query.isEmpty || query.trim().length < 2) {
    // Se não há busca, retorna TODOS os alimentos
    final result = await alimentosRepository.getAllAlimentos();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (alimentos) => alimentos,
    );
  }

  // Se há busca, busca pelos alimentos específicos
  final result = await alimentosRepository.searchAlimentos(query);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (alimentos) => alimentos,
  );
});

// Mapeamentos para exibir valores amigáveis ao usuário
class AlimentoDisplayHelper {
  // Mapeia guia_alimentar_class para textos amigáveis
  static String getGuiaAlimentarFriendly(String guiaAlimentarClass) {
    switch (guiaAlimentarClass.toLowerCase()) {
      case 'in_natura':
        return 'Alimento Natural';
      case 'minimamente_processado':
        return 'Minimamente Processado';
      case 'processado':
        return 'Processado';
      case 'ultraprocessado':
        return 'Ultraprocessado';
      default:
        return guiaAlimentarClass;
    }
  }

  // Mapeia recomendacao_consumo para textos amigáveis
  static String getRecomendacaoConsumoFriendly(String recomendacao) {
    switch (recomendacao.toLowerCase()) {
      case 'a_vontade':
        return 'À Vontade';
      case 'moderado':
        return 'Com Moderação';
      case 'restrito':
        return 'Consumo Restrito';
      case 'evitar':
        return 'Evitar';
      default:
        return recomendacao;
    }
  }

  // Mapeia ig_classificacao para textos amigáveis
  static String getIGClassificacaoFriendly(String igClassificacao) {
    switch (igClassificacao.toLowerCase()) {
      case 'baixo':
        return 'Baixo IG';
      case 'medio':
      case 'médio':
        return 'Médio IG';
      case 'alto':
        return 'Alto IG';
      default:
        return igClassificacao;
    }
  }

  // Constrói URL completa da imagem
  static String getImageUrl(String fotoPorcaoUrl) {
    if (fotoPorcaoUrl.isEmpty) return '';

    // Se já é uma URL completa, retorna como está
    if (fotoPorcaoUrl.startsWith('http://') ||
        fotoPorcaoUrl.startsWith('https://')) {
      return fotoPorcaoUrl;
    }

    // Se é um caminho relativo da API, constrói a URL completa
    if (fotoPorcaoUrl.startsWith('./imgs/')) {
      const baseUrl = 'http://189.90.44.226:5050';
      return '$baseUrl/imgs/${fotoPorcaoUrl.substring(7)}'; // Remove './imgs/'
    }

    return fotoPorcaoUrl;
  }
}

class BuscarAlimentosScreen extends ConsumerStatefulWidget {
  const BuscarAlimentosScreen({super.key});

  @override
  ConsumerState<BuscarAlimentosScreen> createState() =>
      _BuscarAlimentosScreenState();
}

class _BuscarAlimentosScreenState extends ConsumerState<BuscarAlimentosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = value.trim();
        });
        // Feedback sutil para busca
        final feedbackService = ref.read(feedbackServiceProvider);
        if (value.trim().isNotEmpty) {
          feedbackService.searchFeedback();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final alimentosAsync = ref.watch(buscarAlimentosProvider(_searchQuery));
    final feedbackService = ref.watch(feedbackServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // AppBar moderna e acessível
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: Semantics(
          label: 'Botão voltar',
          button: true,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brown50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () async {
              // Feedback tátil e sonoro ao voltar
              await feedbackService.backFeedback();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        title: Text(
          'Buscar Comidas',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Campo de busca moderno e acessível
            Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Semantics(
                label: 'Campo de busca de alimentos',
                textField: true,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Montserrat',
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ex: arroz, feijão...',
                    hintStyle: textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey500,
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.blue50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? Semantics(
                              label: 'Limpar busca',
                              button: true,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.grey600,
                                    size: 16,
                                  ),
                                ),
                                onPressed: () async {
                                  // Feedback ao limpar busca
                                  final feedbackService = ref.read(
                                    feedbackServiceProvider,
                                  );
                                  await feedbackService.lightTap();
                                  await feedbackService.playTapSound();

                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              ),
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Resultados da busca
            Expanded(
              child: alimentosAsync.when(
                data: (alimentos) => _buildSearchResults(alimentos, textTheme),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(
                      child: Text('Erro ao carregar alimentos: $error'),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Alimento> alimentos, TextTheme textTheme) {
    if (alimentos.isEmpty) {
      if (_searchQuery.isEmpty || _searchQuery.length < 2) {
        return _buildEmptyState(textTheme);
      } else {
        return _buildNoResultsState(textTheme);
      }
    }

    return _buildAlimentosList(alimentos, textTheme);
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone grande e expressivo
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue50, AppColors.blue100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.2),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 70,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 40),

            // Título visual e acessível
            Semantics(
              header: true,
              child: Text(
                'Carregando Alimentos...',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Descrição minimalista
            Text(
              'Aguarde enquanto carregamos os alimentos ou digite para buscar',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.grey600,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone expressivo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Opa! Não Achei',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              'Tente outro nome',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.grey600,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlimentosList(List<Alimento> alimentos, TextTheme textTheme) {
    if (alimentos.isEmpty) {
      return _buildNoResultsState(textTheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: alimentos.length,
      itemBuilder: (context, index) {
        if (index >= alimentos.length) {
          return const SizedBox.shrink();
        }

        final alimento = alimentos[index];
        return _buildAlimentoCard(alimento, textTheme);
      },
    );
  }

  Widget _buildAlimentoCard(Alimento alimento, TextTheme textTheme) {
    // Cor do semáforo nutricional
    Color getSemaforoColor() {
      switch (alimento.classificacaoCor) {
        case 'verde':
          return AppColors.semaforoVerde;
        case 'amarelo':
          return AppColors.semaforoAmarelo;
        case 'vermelho':
          return AppColors.semaforoVermelho;
        default:
          return AppColors.grey500;
      }
    }

    // Ícone do semáforo
    IconData getSemaforoIcon() {
      switch (alimento.classificacaoCor) {
        case 'verde':
          return Icons.thumb_up_rounded;
        case 'amarelo':
          return Icons.warning_rounded;
        case 'vermelho':
          return Icons.block_rounded;
        default:
          return Icons.help_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: getSemaforoColor().withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Semantics(
        label: 'Alimento ${alimento.nomePopular}',
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            // Feedback específico baseado no semáforo nutricional
            final feedbackService = ref.read(feedbackServiceProvider);
            await feedbackService.semaforoFeedback(alimento.classificacaoCor);
            await feedbackService.addAlimentoFeedback();

            // Mostrar detalhes do alimento em bottom sheet
            if (context.mounted) {
              _mostrarDetalhesAlimento(context, alimento, textTheme);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Imagem do alimento ou ícone
                _buildAlimentoImage(
                  alimento,
                  getSemaforoColor(),
                  getSemaforoIcon(),
                ),

                const SizedBox(width: 16),

                // Informações do alimento
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome do alimento
                      Text(
                        alimento.nomePopular,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Informação nutricional em destaque
                      _buildAlimentoInfo(alimento, textTheme),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Botão de adicionar moderno
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Semantics(
                    label: 'Adicionar ${alimento.nomePopular} ao prato',
                    button: true,
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.onSecondary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlimentoImage(
    Alimento alimento,
    Color semaforoColor,
    IconData semaforoIcon,
  ) {
    final imageUrl = AlimentoDisplayHelper.getImageUrl(alimento.fotoPorcaoUrl);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: semaforoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: semaforoColor.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child:
            imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Se der erro ao carregar a imagem, mostra o ícone
                    return Icon(semaforoIcon, color: semaforoColor, size: 28);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: semaforoColor,
                        strokeWidth: 2,
                      ),
                    );
                  },
                )
                : Icon(semaforoIcon, color: semaforoColor, size: 28),
      ),
    );
  }

  Widget _buildAlimentoInfo(Alimento alimento, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grupo DICUMÊ
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            alimento.grupoDicume.length > 20
                ? '${alimento.grupoDicume.substring(0, 20)}...'
                : alimento.grupoDicume,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        // IG Classificação amigável
        Text(
          AlimentoDisplayHelper.getIGClassificacaoFriendly(
            alimento.igClassificacao,
          ),
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.grey600,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  void _mostrarDetalhesAlimento(
    BuildContext context,
    Alimento alimento,
    TextTheme textTheme,
  ) {
    // Cor do semáforo nutricional
    Color getSemaforoColor() {
      switch (alimento.classificacaoCor) {
        case 'verde':
          return AppColors.semaforoVerde;
        case 'amarelo':
          return AppColors.semaforoAmarelo;
        case 'vermelho':
          return AppColors.semaforoVermelho;
        default:
          return AppColors.grey500;
      }
    }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de arrastar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Título e status
                Row(
                  children: [
                    // Imagem do alimento
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: getSemaforoColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: getSemaforoColor().withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _buildAlimentoImageForModal(
                          alimento,
                          getSemaforoColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alimento.nomePopular,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getSemaforoColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: getSemaforoColor().withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: getSemaforoColor(),
                                  size: 12,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  alimento.classificacaoCor.toUpperCase(),
                                  style: textTheme.labelMedium?.copyWith(
                                    color: getSemaforoColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Informações detalhadas
                _buildDetailRow(
                  'Grupo DICUMÊ',
                  alimento.grupoDicume,
                  textTheme,
                ),
                _buildDetailRow(
                  'Índice Glicêmico',
                  AlimentoDisplayHelper.getIGClassificacaoFriendly(
                    alimento.igClassificacao,
                  ),
                  textTheme,
                ),
                _buildDetailRow(
                  'Grupo Nutricional',
                  alimento.grupoNutricional,
                  textTheme,
                ),
                _buildDetailRow(
                  'Tipo de Alimento',
                  AlimentoDisplayHelper.getGuiaAlimentarFriendly(
                    alimento.guiaAlimentarClass,
                  ),
                  textTheme,
                ),
                _buildDetailRow(
                  'Recomendação',
                  AlimentoDisplayHelper.getRecomendacaoConsumoFriendly(
                    alimento.recomendacaoConsumo,
                  ),
                  textTheme,
                ),

                const SizedBox(height: 24),

                // Botão para adicionar ao prato
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final feedbackService = ref.read(feedbackServiceProvider);
                      await feedbackService.addAlimentoFeedback();

                      if (context.mounted) {
                        Navigator.of(context).pop(); // Fecha bottom sheet
                        Navigator.of(context).pop(alimento); // Retorna alimento
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Adicionar ao Prato'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlimentoImageForModal(Alimento alimento, Color semaforoColor) {
    final imageUrl = AlimentoDisplayHelper.getImageUrl(alimento.fotoPorcaoUrl);

    // Ícone baseado na classificação
    IconData getIcon() {
      switch (alimento.classificacaoCor) {
        case 'verde':
          return Icons.eco_rounded;
        case 'amarelo':
          return Icons.warning_amber_rounded;
        case 'vermelho':
          return Icons.local_fire_department_rounded;
        default:
          return Icons.restaurant_rounded;
      }
    }

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: semaforoColor.withOpacity(0.1),
            child: Icon(getIcon(), color: semaforoColor, size: 40),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: semaforoColor.withOpacity(0.1),
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: semaforoColor,
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        color: semaforoColor.withOpacity(0.1),
        child: Icon(getIcon(), color: semaforoColor, size: 40),
      );
    }
  }
}

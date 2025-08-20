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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Poderíamos ajustar comportamento do ScrollController aqui, se necessário
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

    return Scaffold(
      backgroundColor: AppColors.background,

      // AppBar moderna e acessível
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        // Não exibir o botão de voltar — navegação via barra inferior
        automaticallyImplyLeading: false,
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
                    color: AppColors.primary.withValues(alpha: 0.1),
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
                    color: AppColors.secondary.withValues(alpha: 0.2),
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
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
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

    return RefreshIndicator(
      onRefresh: () async {
        // Tenta sincronizar com a API e depois força a requisição do provider
        final repo = ref.read(alimentoRepositoryProvider);
        final result = await repo.syncAlimentosFromAPI();
        result.fold(
          (failure) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erro ao atualizar alimentos: ${failure.message}',
                  ),
                ),
              );
            }
          },
          (count) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Atualizados $count alimentos')),
              );
            }
          },
        );

        // Força o provider de busca a refazer a consulta
        ref.invalidate(buscarAlimentosProvider(_searchQuery));
      },
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        radius: const Radius.circular(8),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          itemCount: alimentos.length,
          itemBuilder: (context, index) {
            if (index >= alimentos.length) {
              return const SizedBox.shrink();
            }

            final alimento = alimentos[index];
            return _buildAlimentoCard(alimento, textTheme);
          },
        ),
      ),
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
            color: getSemaforoColor().withValues(alpha: 0.1),
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

                // Botão de adicionar moderno mais discreto (tamanho fixo)
                Semantics(
                  label: 'Adicionar ${alimento.nomePopular} ao prato',
                  button: true,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        final feedbackService = ref.read(
                          feedbackServiceProvider,
                        );
                        await feedbackService.addAlimentoFeedback();
                        if (context.mounted) {
                          Navigator.of(context).pop(alimento);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.onSecondary,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Icon(Icons.add_rounded, size: 20),
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

    // Usar Hero na miniatura para permitir transição para preview
    final heroTag = 'alimento_image_${alimento.id}';

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Hero(
          tag: heroTag,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  imageUrl.isNotEmpty
                      ? () => _openImagePreview(
                        context,
                        imageUrl,
                        heroTag,
                        semaforoColor,
                      )
                      : null,
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: semaforoColor.withValues(alpha: 0.08),
                            child: const Icon(
                              Icons.restaurant_menu_rounded,
                              size: 30,
                              color: AppColors.grey600,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                color: semaforoColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        color: semaforoColor.withValues(alpha: 0.08),
                        child: const Icon(
                          Icons.restaurant_menu_rounded,
                          size: 30,
                          color: AppColors.grey600,
                        ),
                      ),
            ),
          ),
        ),
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
            color: AppColors.primary.withValues(alpha: 0.1),
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

    final heroTag = 'alimento_image_${alimento.id}';
    final imageUrl = AlimentoDisplayHelper.getImageUrl(alimento.fotoPorcaoUrl);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.48,
            minChildSize: 0.3,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag indicator
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
                      const SizedBox(height: 16),

                      // Header: imagem + título + chip
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // imagem clicável com Hero e overlay de lupa
                          GestureDetector(
                            onTap:
                                imageUrl.isNotEmpty
                                    ? () => _openImagePreview(
                                      context,
                                      imageUrl,
                                      heroTag,
                                      getSemaforoColor(),
                                    )
                                    : null,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: getSemaforoColor().withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: getSemaforoColor().withValues(
                                        alpha: 0.25,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Hero(
                                      tag: heroTag,
                                      child: _buildAlimentoImageForModal(
                                        alimento,
                                        getSemaforoColor(),
                                      ),
                                    ),
                                  ),
                                ),

                                // overlay lupa quando existe imagem
                                if (imageUrl.isNotEmpty)
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.45),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.zoom_in_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                              ],
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getSemaforoColor().withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: getSemaforoColor().withValues(
                                        alpha: 0.3,
                                      ),
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
                                      const SizedBox(width: 8),
                                      Text(
                                        alimento.classificacaoCor.toUpperCase(),
                                        style: textTheme.labelMedium?.copyWith(
                                          color: getSemaforoColor(),
                                          fontWeight: FontWeight.w700,
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

                      const SizedBox(height: 20),

                      // informações detalhadas em seções com espaçamento maior
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

                      const SizedBox(height: 20),

                      // Botões: adicionar ao prato + fechar
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final feedbackService = ref.read(
                                  feedbackServiceProvider,
                                );
                                await feedbackService.addAlimentoFeedback();
                                if (context.mounted) {
                                  Navigator.of(
                                    context,
                                  ).pop(); // fecha bottom sheet
                                  Navigator.of(
                                    context,
                                  ).pop(alimento); // retorna alimento
                                }
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Adicionar ao Prato'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 120,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize:
                                    Size.zero, // permite o SizedBox controlar o tamanho
                              ),
                              child: const Text('Fechar'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
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
            color: semaforoColor.withValues(alpha: 0.08),
            child: Icon(getIcon(), color: semaforoColor, size: 44),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: semaforoColor.withValues(alpha: 0.08),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
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
            ),
          );
        },
      );
    } else {
      return Container(
        color: semaforoColor.withValues(alpha: 0.08),
        child: Icon(getIcon(), color: semaforoColor, size: 44),
      );
    }
  }

  // Preview fullscreen com InteractiveViewer + Hero
  void _openImagePreview(
    BuildContext context,
    String imageUrl,
    String heroTag,
    Color semaforoColor,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.85),
        pageBuilder: (context, animation, secondaryAnimation) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: heroTag,
                        child: InteractiveViewer(
                          maxScale: 5.0,
                          minScale: 1.0,
                          child:
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          color: semaforoColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: semaforoColor.withValues(
                                          alpha: 0.08,
                                        ),
                                        child: Icon(
                                          Icons.broken_image_rounded,
                                          color: semaforoColor,
                                          size: 80,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    width: double.infinity,
                                    color: semaforoColor.withValues(
                                      alpha: 0.08,
                                    ),
                                    child: Icon(
                                      Icons.restaurant_menu_rounded,
                                      color: semaforoColor,
                                      size: 80,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    // Botão fechar visível
                    Positioned(
                      top: 20,
                      right: 16,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

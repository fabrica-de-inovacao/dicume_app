import 'package:dicume_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/alimento.dart';
import '../../../core/providers/feedback_providers.dart';
import '../../../data/providers/alimento_providers.dart';
import '../../../core/utils/alimento_display_helper.dart'; // Importar o helper
import '../../widgets/alimento_details_bottom_sheet.dart'; // Importar o novo modal

// SliverPersistentHeaderDelegate para busca + filtros (top-level)
class _SearchFilterHeader extends SliverPersistentHeaderDelegate {
  final double minExtentValue;
  final double maxExtentValue;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final Widget filtersWidget;

  _SearchFilterHeader({
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.searchController,
    required this.onSearchChanged,
    required this.filtersWidget,
  });

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // altura atual disponível para o header (clamp entre min/max)
    final currentHeight = (maxExtent - shrinkOffset).clamp(
      minExtent,
      maxExtent,
    );
    // somente mostrar filtros quando houver espaço extra suficiente
    final showFilters = currentHeight >= (minExtent + 40);

    return Container(
      height: currentHeight,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // Título (mantém tamanho compacto quando colapsado)
          // SizedBox(
          //   height: 28,
          //   child: Row(
          //     spacing: 12,
          //     children: [
          //       BackButton(
          //         color: AppColors.textPrimary,
          //         onPressed: () => context.pop(),
          //       ),
          //       Expanded(
          //         child: Text(
          //           'Buscar Comidas',
          //           style: textTheme.titleMedium?.copyWith(
          //             color: AppColors.primary,
          //             fontWeight: FontWeight.w700,
          //             fontSize: 24,
          //             fontFamily: 'Montserrat',
          //           ),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 18),

          // Campo de busca com altura fixa para evitar corte
          SizedBox(
            height: 62,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
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
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),

          if (showFilters) ...[const SizedBox(height: 10), filtersWidget],
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchFilterHeader oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.filtersWidget != filtersWidget;
  }
}

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

class BuscarAlimentoScreen extends ConsumerStatefulWidget {
  const BuscarAlimentoScreen({super.key});

  @override
  ConsumerState<BuscarAlimentoScreen> createState() =>
      _BuscarAlimentoScreenState();
}

class _BuscarAlimentoScreenState extends ConsumerState<BuscarAlimentoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;
  final ScrollController _scrollController = ScrollController();
  // Filtros de lista
  String _selectedColorFilter = 'Todos';
  String _selectedGroupFilter = 'Todos grupos';

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
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: const Text('Buscar comidas'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
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

            ref.invalidate(buscarAlimentosProvider(_searchQuery));
          },
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(8),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SearchFilterHeader(
                    minExtentValue: 90,
                    maxExtentValue: 200,
                    searchController: _searchController,
                    onSearchChanged: _onSearchChanged,
                    filtersWidget: alimentosAsync.when(
                      data:
                          (alimentos) => _buildFilterBar(alimentos, textTheme),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),

                // Conteúdo principal: quando dados, construir SliverList; quando loading/error, SliverFillRemaining
                alimentosAsync.when(
                  data: (alimentos) {
                    // Aplicar filtros client-side aqui
                    final filtered =
                        alimentos.where((a) {
                          if (_selectedColorFilter != 'Todos') {
                            final valor = a.classificacaoCor.toLowerCase();
                            if (valor != _selectedColorFilter.toLowerCase()) {
                              return false;
                            }
                          }
                          if (_selectedGroupFilter != 'Todos grupos') {
                            if (a.grupoDicume != _selectedGroupFilter) {
                              return false;
                            }
                          }
                          return true;
                        }).toList();

                    if (filtered.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildNoResultsState(textTheme),
                      );
                    }

                    // Ordenar
                    filtered.sort(
                      (a, b) => a.nomePopular.toLowerCase().compareTo(
                        b.nomePopular.toLowerCase(),
                      ),
                    );

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final alimento = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildAlimentoCard(alimento, textTheme),
                          );
                        }, childCount: filtered.length),
                      ),
                    );
                  },
                  loading:
                      () => SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  error:
                      (error, stack) => SliverFillRemaining(
                        child: Center(
                          child: Text('Erro ao carregar alimentos: $error'),
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

  // ...search results logic moved into CustomScrollView; helper methods below

  Widget _buildFilterBar(List<Alimento> alimentos, TextTheme textTheme) {
    // construir lista de grupos a partir dos alimentos disponíveis
    final groups = <String>{};
    for (final a in alimentos) {
      if (a.grupoDicume.isNotEmpty) groups.add(a.grupoDicume);
    }
    final groupOptions = ['Todos grupos', ...groups.toList()..sort()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                constraints: const BoxConstraints(minHeight: 48),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: PopupMenuButton<String>(
                  initialValue: _selectedGroupFilter,
                  color: AppColors.surface,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(0, 8),
                  onSelected: (v) {
                    setState(() => _selectedGroupFilter = v);
                  },
                  itemBuilder:
                      (context) => List.generate(groupOptions.length, (i) {
                        final g = groupOptions[i];
                        return PopupMenuItem<String>(
                          value: g,
                          height: 56,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration:
                                i < groupOptions.length - 1
                                    ? BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.grey100,
                                        ),
                                      ),
                                    )
                                    : null,
                            child: Text(
                              _friendlyGroupLabel(g),
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        );
                      }),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _friendlyGroupLabel(_selectedGroupFilter),
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: 'Montserrat',
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down_rounded, size: 22),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Botão para limpar filtros rapidamente
            Semantics(
              label: 'Limpar filtros',
              button: true,
              child: SizedBox(
                height: 44,
                width: 44,
                child: OutlinedButton(
                  onPressed:
                      () => setState(() {
                        _selectedColorFilter = 'Todos';
                        _selectedGroupFilter = 'Todos grupos';
                      }),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.filter_alt_off_rounded, size: 20),
                ),
              ),
            ),
          ],
        ),

        // Dropdown de grupos (itens maiores e menu estilizado para facilitar toque)
        const SizedBox(height: 8),

        // Chips de cor do semáforo (sem o botão 'Todos' — usar limpar filtros para reset)
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _buildColorFilterChip('Verde'),
            _buildColorFilterChip('Amarelo'),
            _buildColorFilterChip('Vermelho'),
          ],
        ),
      ],
    );
  }

  Widget _buildColorFilterChip(String label) {
    final selected = _selectedColorFilter == label;
    // map label to color
    Color chipColor;
    switch (label.toLowerCase()) {
      case 'verde':
        chipColor = AppColors.success;
        break;
      case 'amarelo':
        chipColor = AppColors.warning;
        break;
      case 'vermelho':
        chipColor = AppColors.error;
        break;
      default:
        chipColor = AppColors.primary;
    }

    return ChoiceChip(
      avatar: CircleAvatar(radius: 8, backgroundColor: chipColor),
      label: Text(label, style: const TextStyle(fontFamily: 'Montserrat')),
      selected: selected,
      onSelected: (v) {
        setState(() {
          _selectedColorFilter = v ? label : 'Todos';
        });
      },
      selectedColor: chipColor.withValues(alpha: 0.12),
      backgroundColor: AppColors.surface,
      side:
          selected
              ? BorderSide(color: chipColor, width: 1.5)
              : BorderSide(color: Colors.transparent),
      labelStyle: TextStyle(
        color: selected ? chipColor : AppColors.onSurface,
        fontFamily: 'Montserrat',
      ),
    );
  }

  // Formata labels de grupo para Title Case e limpeza
  String _friendlyGroupLabel(String raw) {
    final s = raw.replaceAll('_', ' ').toLowerCase().trim();
    if (s.isEmpty) return raw;
    return s
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  // Widget _buildEmptyState(TextTheme textTheme) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(40.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Ícone grande e expressivo
  //           Container(
  //             width: 140,
  //             height: 140,
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [AppColors.blue50, AppColors.blue100],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               shape: BoxShape.circle,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: AppColors.secondary.withValues(alpha: 0.2),
  //                   blurRadius: 25,
  //                   offset: const Offset(0, 10),
  //                 ),
  //               ],
  //             ),
  //             child: const Icon(
  //               Icons.restaurant_menu_rounded,
  //               size: 70,
  //               color: AppColors.secondary,
  //             ),
  //           ),
  //           const SizedBox(height: 40),

  //           // Título visual e acessível
  //           Semantics(
  //             header: true,
  //             child: Text(
  //               'Carregando Alimentos...',
  //               style: textTheme.headlineMedium?.copyWith(
  //                 color: AppColors.primary,
  //                 fontWeight: FontWeight.w700,
  //                 fontFamily: 'Montserrat',
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           const SizedBox(height: 20),

  //           // Descrição minimalista
  //           Text(
  //             'Aguarde enquanto carregamos os alimentos ou digite para buscar',
  //             style: textTheme.bodyLarge?.copyWith(
  //               color: AppColors.grey600,
  //               fontFamily: 'Montserrat',
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  // _buildAlimentosList removed: list rendering now uses SliverList in the CustomScrollView

  // (definição de _SearchFilterHeader movida para o topo do arquivo)

  Widget _buildAlimentoCard(Alimento alimento, TextTheme textTheme) {
    final semaforoColor = AlimentoDisplayHelper.getSemaforoColor(
      alimento.classificacaoCor,
    );
    final semaforoIcon = AlimentoDisplayHelper.getIconForClassification(
      alimento.classificacaoCor,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: semaforoColor.withValues(alpha: 0.1),
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
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder:
                    (context) => Wrap(
                      children: [
                        AlimentoDetailsBottomSheet(alimento: alimento),
                      ],
                    ),
              );

              if (result != null) {
                // Retorna o alimento e a quantidade para a tela anterior (MontarPratoVirtualScreen)
                if (context.mounted) {
                  Navigator.of(context).pop(result);
                }
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Imagem do alimento ou ícone
                _buildAlimentoImage(alimento, semaforoColor, semaforoIcon),

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

                      // Informação nutricional em destaque: chip acima,
                      // em seguida uma linha com IG (esquerda) e Grupo Nutricional (direita)
                      Row(
                        children: [
                          // Chip do Grupo DICUMÊ
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: semaforoColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              alimento.grupoDicume.length > 20
                                  ? '${alimento.grupoDicume.substring(0, 20)}...'
                                  : alimento.grupoDicume,
                              style: textTheme.labelSmall?.copyWith(
                                color: semaforoColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Linha com IG e Grupo Nutricional, agora mais próximos e com divisor vertical
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AlimentoDisplayHelper.getIGClassificacaoFriendly(
                                alimento.igClassificacao,
                              ),
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.grey600,
                                fontFamily: 'Montserrat',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 6),
                            // divisor vertical compacto
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                width: 8,
                                thickness: 1,
                                color: AppColors.grey300,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                alimento.grupoNutricional,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey600,
                                  fontFamily: 'Montserrat',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        // Feedback específico baseado no semáforo nutricional
                        final feedbackService = ref.read(
                          feedbackServiceProvider,
                        );
                        await feedbackService.semaforoFeedback(
                          alimento.classificacaoCor,
                        );
                        await feedbackService.addAlimentoFeedback();

                        // Mostrar detalhes do alimento em bottom sheet
                        if (context.mounted) {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder:
                                    (context) => Wrap(
                                      children: [
                                        AlimentoDetailsBottomSheet(
                                          alimento: alimento,
                                        ),
                                      ],
                                    ),
                              );

                          if (result != null) {
                            // Retorna o alimento e a quantidade para a tela anterior (MontarPratoVirtualScreen)
                            if (context.mounted) {
                              Navigator.of(context).pop(result);
                            }
                          }
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
    final imageUrl = AlimentoDisplayHelper.getImageUrl(
      alimento.fotoPorcaoUrl,
      AppConstants.apiBaseUrl,
    );

    // Usar Hero na miniatura para permitir transição para preview
    // final heroTag = 'alimento_image_${alimento.id}'; // Removido para evitar crash

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
        // child: Hero( // Removido para evitar crash
        //   tag: heroTag,
        //   child:
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                imageUrl.isNotEmpty
                    ? () => _openImagePreview(
                      context,
                      imageUrl,
                      // heroTag, // Removido para evitar crash
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
                                      ? loadingProgress.cumulativeBytesLoaded /
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
        // ), // Removido para evitar crash
      ),
    );
  }

  // Preview fullscreen com InteractiveViewer
  void _openImagePreview(
    BuildContext context,
    String imageUrl,
    // String heroTag, // Removido para evitar crash
    Color semaforoColor,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.85),
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
                      // child: Hero( // Removido para evitar crash
                      //   tag: heroTag,
                      //   child:
                      child: SizedBox(
                        width: 360,
                        height: 360,
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
                      // ), // Removido para evitar crash
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

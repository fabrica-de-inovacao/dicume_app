import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/alimento.dart';
import '../../../core/providers/feedback_providers.dart';
import '../../../data/providers/alimento_providers.dart';

// Provider que busca alimentos do BANCO LOCAL (offline-first)
final buscarAlimentosProvider =
    Provider.family<AsyncValue<List<Alimento>>, String>((ref, query) {
      if (query.isEmpty || query.trim().length < 2) {
        return const AsyncValue.data(<Alimento>[]);
      }

      // Busca APENAS do repositório local (offline-first)
      final alimentosRepository = ref.watch(alimentoRepositoryProvider);

      return ref.watch(
        FutureProvider<List<Alimento>>((ref) async {
          final result = await alimentosRepository.searchAlimentos(query);
          return result.fold(
            (failure) => throw Exception(failure.message),
            (alimentos) => alimentos,
          );
        }).select((asyncValue) => asyncValue),
      );
    });

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
    if (_searchQuery.isEmpty || _searchQuery.length < 2) {
      return _buildEmptyState(textTheme);
    }

    if (alimentos.isEmpty) {
      return _buildNoResultsState(textTheme);
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
                'Bora Buscar!',
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
              'Digite o nome da comida',
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

            if (context.mounted) {
              Navigator.of(context).pop(alimento);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Ícone do semáforo nutricional grande
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: getSemaforoColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: getSemaforoColor().withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    getSemaforoIcon(),
                    color: getSemaforoColor(),
                    size: 28,
                  ),
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
                      ),
                      const SizedBox(height: 8),

                      // Informação nutricional em destaque
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brown50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alimento.grupoDicume,
                              style: textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alimento.igClassificacao,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

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
}

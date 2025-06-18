import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/alimento_simples.dart';
import '../../../core/providers/feedback_providers.dart';

// Provider simples para buscar alimentos mock
final buscarAlimentosProvider = Provider.family<List<AlimentoSimples>, String>((
  ref,
  query,
) {
  if (query.isEmpty || query.trim().length < 2) return <AlimentoSimples>[];
  try {
    return AlimentoSimples.buscar(query.trim());
  } catch (e) {
    return <AlimentoSimples>[];
  }
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

        // Feedback leve quando busca é realizada
        if (_searchQuery.isNotEmpty && _searchQuery.length >= 2) {
          final feedbackService = ref.read(feedbackServiceProvider);
          feedbackService.searchFeedback();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme =
        theme.textTheme; // Watch do provider de busca de alimentos
    final alimentos = ref.watch(buscarAlimentosProvider(_searchQuery));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () async {
            // Feedback tátil e sonoro
            final feedbackService = ref.read(feedbackServiceProvider);
            await feedbackService.backFeedback();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Buscar Comidas',
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Campo de busca
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.surface,
              child: Semantics(
                label: 'Campo de busca de alimentos',
                hint: 'Digite o nome da comida que você quer buscar',
                textField: true,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome da comida...',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.grey600,
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? Semantics(
                              label: 'Limpar busca',
                              button: true,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.grey600,
                                ),
                                onPressed: () async {
                                  // Feedback tátil e sonoro
                                  final feedbackService = ref.read(
                                    feedbackServiceProvider,
                                  );
                                  await feedbackService.searchFeedback();

                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              ),
                            )
                            : null,
                    filled: true,
                    fillColor: AppColors.grey50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Resultados da busca
            Expanded(child: _buildSearchResults(alimentos, textTheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    List<AlimentoSimples> alimentos,
    TextTheme textTheme,
  ) {
    if (_searchQuery.isEmpty || _searchQuery.length < 2) {
      return _buildEmptyState(textTheme);
    }

    if (alimentos.isEmpty) {
      return _buildNoResultsState(textTheme);
    }

    return _buildAlimentosList(alimentos, textTheme);
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Semantics(
      label:
          'Tela de busca vazia. Digite pelo menos 2 letras para buscar alimentos.',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone grande e amigável
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue200.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 60,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // Título visual e grande
              Text(
                'Busque uma Comida',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16), // Descrição minimalista
              Text(
                'Digite para começar',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey600,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsState(TextTheme textTheme) {
    return Semantics(
      label:
          'Nenhum alimento encontrado para a busca "$_searchQuery". Tente buscar com outro nome.',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: AppColors.grey400),
              const SizedBox(height: 16),
              Text(
                'Nenhuma comida encontrada',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tente buscar com outro nome ou termo',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey600,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlimentosList(
    List<AlimentoSimples> alimentos,
    TextTheme textTheme,
  ) {
    // Verificação adicional de segurança
    if (alimentos.isEmpty) {
      return _buildNoResultsState(textTheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: alimentos.length,
      itemBuilder: (context, index) {
        // Verificação de bounds
        if (index >= alimentos.length) {
          return const SizedBox.shrink();
        }

        final alimento = alimentos[index];
        return _buildAlimentoCard(alimento, textTheme);
      },
    );
  }

  Widget _buildAlimentoCard(AlimentoSimples alimento, TextTheme textTheme) {
    // Cor baseada na classificação nutricional
    Color getClassificationColor() {
      switch (alimento.classificacao) {
        case 'verde':
          return AppColors.green600;
        case 'amarelo':
          return AppColors.warning;
        case 'vermelho':
          return AppColors.danger;
        default:
          return AppColors.grey600;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          // Feedback baseado na classificação nutricional
          final feedbackService = ref.read(feedbackServiceProvider);
          await feedbackService.semaforoFeedback(alimento.classificacao);

          if (mounted && context.mounted) {
            Navigator.of(context).pop(alimento);
          }
        },
        child: Semantics(
          label:
              'Alimento ${alimento.nome}, ${alimento.calorias.toStringAsFixed(0)} calorias por 100 gramas, classificação ${alimento.classificacao}, toque para adicionar',
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar com indicador visual da classificação
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.green50,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: getClassificationColor(),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: getClassificationColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Conteúdo expandido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nome do alimento
                      Text(
                        alimento.nome,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Calorias
                      Text(
                        '${alimento.calorias.toStringAsFixed(0)} kcal/100g',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.grey600,
                          fontFamily: 'Montserrat',
                        ),
                      ),

                      // Macronutrientes (se existirem)
                      if (alimento.carboidratos > 0 ||
                          alimento.proteinas > 0 ||
                          alimento.gorduras > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          'C: ${alimento.carboidratos.toStringAsFixed(1)}g | '
                          'P: ${alimento.proteinas.toStringAsFixed(1)}g | '
                          'G: ${alimento.gorduras.toStringAsFixed(1)}g',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.grey600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Indicador visual da classificação (semáforo)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: getClassificationColor(),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/mock_data_service_regional.dart';

class BuscarAlimentoScreen extends StatefulWidget {
  const BuscarAlimentoScreen({super.key});

  @override
  State<BuscarAlimentoScreen> createState() => _BuscarAlimentoScreenState();
}

class _BuscarAlimentoScreenState extends State<BuscarAlimentoScreen> {
  final mockService = SuperMockDataService();
  final searchController = TextEditingController();
  List<AlimentoNutricional> alimentosFiltrados = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    // Carrega todos os alimentos inicialmente
    alimentosFiltrados = mockService.getTodosAlimentos();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _buscarAlimentos(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        alimentosFiltrados = mockService.getTodosAlimentos();
      } else {
        alimentosFiltrados =
            mockService
                .getTodosAlimentos()
                .where(
                  (alimento) =>
                      alimento.nome.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      alimento.descricao.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  Color _getCorIndiceGlicemico(String semaforo) {
    switch (semaforo.toLowerCase()) {
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

  IconData _getIconeIndiceGlicemico(String semaforo) {
    switch (semaforo.toLowerCase()) {
      case 'verde':
        return Icons.check_circle;
      case 'amarelo':
        return Icons.warning;
      case 'vermelho':
        return Icons.error;
      default:
        return Icons.help;
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
          'Buscar Alimento',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _buscarAlimentos,
              decoration: InputDecoration(
                hintText: 'Digite o nome do alimento...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    isSearching
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            _buscarAlimentos('');
                            FeedbackService().lightTap();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),

          // Lista de alimentos
          Expanded(
            child:
                alimentosFiltrados.isEmpty
                    ? _buildEstadoVazio()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: alimentosFiltrados.length,
                      itemBuilder: (context, index) {
                        final alimento = alimentosFiltrados[index];
                        return _buildAlimentoCard(alimento, textTheme);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Nenhum alimento encontrado',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar com outras palavras',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAlimentoCard(AlimentoNutricional alimento, TextTheme textTheme) {
    final corIndice = _getCorIndiceGlicemico(alimento.semaforo);
    final iconeIndice = _getIconeIndiceGlicemico(alimento.semaforo);

    return DicumeElegantCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => _mostrarDetalhesAlimento(alimento),
      child: Row(
        children: [
          // Imagem do alimento
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: corIndice.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: corIndice, width: 1),
            ),
            child: Icon(
              Icons
                  .restaurant, // Placeholder - será substituído por imagem real
              color: corIndice,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Informações do alimento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alimento.nome,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(iconeIndice, color: corIndice, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alimento.descricao,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip('${alimento.calorias.toInt()} kcal'),
                    const SizedBox(width: 8),
                    _buildInfoChip('IG: ${alimento.semaforo}', corIndice),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, [Color? color]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.grey400).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (color ?? AppColors.grey400).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color ?? AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _mostrarDetalhesAlimento(AlimentoNutricional alimento) async {
    await FeedbackService().mediumTap();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetalhesAlimento(alimento),
    );
  }

  Widget _buildDetalhesAlimento(AlimentoNutricional alimento) {
    final corIndice = _getCorIndiceGlicemico(alimento.semaforo);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle do modal
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Conteúdo
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: corIndice.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: corIndice, width: 2),
                        ),
                        child: Icon(
                          Icons.restaurant,
                          color: corIndice,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alimento.nome,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: corIndice.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: corIndice),
                              ),
                              child: Text(
                                'Índice Glicêmico: ${alimento.semaforo.toUpperCase()}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: corIndice,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Descrição
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alimento.descricao,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informações nutricionais
                  Text(
                    'Informações Nutricionais (100g)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoNutricional(
                    'Calorias',
                    '${alimento.calorias.toInt()} kcal',
                  ),
                  _buildInfoNutricional(
                    'Carboidratos',
                    '${alimento.carboidratos.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    'Proteínas',
                    '${alimento.proteinas.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    'Gorduras',
                    '${alimento.gorduras.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    'Fibras',
                    '${alimento.fibras.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    'Sódio',
                    '${alimento.sodio.toStringAsFixed(1)}mg',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNutricional(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            valor,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

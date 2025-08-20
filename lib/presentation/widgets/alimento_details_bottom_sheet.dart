import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/feedback_service.dart';
import '../../core/services/mock_data_service_regional.dart'; // Assumindo que AlimentoNutricional está aqui

class AlimentoDetailsBottomSheet extends StatelessWidget {
  final AlimentoNutricional alimento;

  const AlimentoDetailsBottomSheet({
    super.key,
    required this.alimento,
  });

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

  @override
  Widget build(BuildContext context) {
    final corIndice = _getCorIndiceGlicemico(alimento.semaforo);
    final textTheme = Theme.of(context).textTheme;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8), // Espaçamento adicionado
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
                                style: textTheme.bodyMedium?.copyWith(
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
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alimento.descricao,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informações nutricionais
                  Text(
                    'Informações Nutricionais (100g)',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoNutricional(
                    context,
                    'Calorias',
                    '${alimento.calorias.toInt()} kcal',
                  ),
                  _buildInfoNutricional(
                    context,
                    'Carboidratos',
                    '${alimento.carboidratos.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    context,
                    'Proteínas',
                    '${alimento.proteinas.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    context,
                    'Gorduras',
                    '${alimento.gorduras.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    context,
                    'Fibras',
                    '${alimento.fibras.toStringAsFixed(1)}g',
                  ),
                  _buildInfoNutricional(
                    context,
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

  Widget _buildInfoNutricional(BuildContext context, String label, String valor) {
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

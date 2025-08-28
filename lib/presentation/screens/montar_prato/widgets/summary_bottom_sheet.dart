import 'package:flutter/material.dart';
import 'slide_to_confirm.dart';
import '../../../../core/services/mock_data_service_regional.dart';
import '../../../../core/theme/app_colors.dart';

class SummaryBottomSheet extends StatelessWidget {
  final List<AlimentoNutricional> itens;
  final Map<String, dynamic> estatisticas;
  final ValueChanged<bool> onResult;

  const SummaryBottomSheet({
    Key? key,
    required this.itens,
    required this.estatisticas,
    required this.onResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Drag indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resumo da Refeição',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text('Itens: ${itens.length}', style: textTheme.bodyMedium),

            const SizedBox(height: 12),

            if (itens.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: itens.length,
                  separatorBuilder: (_, _) => const Divider(height: 8),
                  itemBuilder: (context, index) {
                    final a = itens[index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(a.nome, style: textTheme.bodySmall),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${a.quantidadeBase}',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 32),

            // Slide to confirm component
            SlideToConfirm(
              onConfirmed: () => Navigator.of(context).pop(true),
              text: 'Deslize para confirmar a finalização',
              height: 56,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

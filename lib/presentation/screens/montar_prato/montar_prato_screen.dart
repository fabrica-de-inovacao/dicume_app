import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/providers/feedback_providers.dart';
import 'buscar_alimentos_screen_v2.dart';

class MontarPratoScreen extends ConsumerWidget {
  const MontarPratoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final feedbackService = ref.watch(feedbackServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bora Montar o Prato!', // Título principal conforme guia
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700, // Bold conforme guia
            fontFamily: 'Montserrat',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Saudação personalizada
              Card(
                color: AppColors.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Cantos arredondados conforme guia
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.waving_hand,
                        size: 32,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'E aí! Vamos botar as comidas no prato?',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700, // Bold conforme guia
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monte seu prato e vamos ver como ficou!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Área de composição do prato (empty state)
              Expanded(
                child: Card(
                  color: AppColors.surface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ilustração do prato vazio
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.brown50,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.brown200,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.dinner_dining,
                            size: 60,
                            color: AppColors.brown300,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Seu prato tá vazio!',
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight:
                                FontWeight.w600, // SemiBold conforme guia
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Toca no botão "Botar Comida" para começar',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.grey600,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Dica visual
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.blue200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Quanto mais verde, melhor!',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Feedback tátil e sonoro ao abrir busca
          await feedbackService.navigationFeedback();
          await feedbackService.playNavigationSound();

          // Navegar para busca de alimentos
          final result = await Navigator.of(context).push<dynamic>(
            MaterialPageRoute(
              builder: (context) => const BuscarAlimentosScreen(),
            ),
          );

          if (result != null) {
            // Feedback de sucesso ao adicionar alimento
            await feedbackService.addAlimentoFeedback();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Adicionado: ${result.nome}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.onPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        backgroundColor: AppColors.secondary, // Azul vibrante conforme guia
        foregroundColor: AppColors.onSecondary,
        elevation: 4,
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          'Botar Comida', // Palavreado regional conforme guia
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600, // SemiBold conforme guia
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

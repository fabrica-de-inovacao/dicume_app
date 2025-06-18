import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

class HistoricoScreen extends ConsumerWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Meu Rango de Hoje', // Palavreado regional conforme guia
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
              // Card de seleção de data
              Card(
                color: AppColors.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Cantos arredondados conforme guia
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hoje - 18 de Junho',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight:
                                FontWeight.w600, // SemiBold conforme guia
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar seletor de data
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Em breve: Seletor de data!',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              backgroundColor: AppColors.primary,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'Mudar',
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
              ),

              const SizedBox(height: 24),

              // Lista de refeições (empty state)
              Expanded(
                child: Column(
                  children: [
                    // Seções das refeições
                    _buildRefeicaoSection(
                      context,
                      textTheme,
                      '☀️',
                      'Café da Manhã',
                      'Ainda não botou nada aqui',
                    ),

                    const SizedBox(height: 16),

                    _buildRefeicaoSection(
                      context,
                      textTheme,
                      '🌞',
                      'Almoço',
                      'Ainda não botou nada aqui',
                    ),

                    const SizedBox(height: 16),

                    _buildRefeicaoSection(
                      context,
                      textTheme,
                      '🌙',
                      'Jantar',
                      'Ainda não botou nada aqui',
                    ),

                    const Spacer(),

                    // Estado vazio com dica
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.brown50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.brown200, width: 1),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu_outlined,
                            size: 48,
                            color: AppColors.brown400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhum prato montado hoje',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vai na aba "Montar Prato" e bora botar as comidas!',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey600,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefeicaoSection(
    BuildContext context,
    TextTheme textTheme,
    String emoji,
    String titulo,
    String subtitulo,
  ) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Emoji da refeição conforme guia
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600, // SemiBold conforme guia
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),

            // Semáforo placeholder (empty state)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.circle_outlined,
                color: AppColors.grey400,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/grupo_alimento.dart';
import '../../../core/providers/feedback_providers.dart';
import '../buscar/buscar_alimento_screen.dart';

class SelecionarGrupoScreen extends ConsumerWidget {
  const SelecionarGrupoScreen({super.key});

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
          'Que Tipo de Comida?',
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
        leading: Semantics(
          label: 'Botão voltar para tela anterior',
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            color: AppColors.primary,
            onPressed: () async {
              await feedbackService.navigationFeedback();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instrução amigável
              Card(
                color: AppColors.blue50,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Toca no grupo da comida que você quer botar no prato',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.secondary,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Grid de grupos
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        0.85, // Cards mais altos para acomodar texto
                  ),
                  itemCount: GrupoAlimento.grupos.length,
                  itemBuilder: (context, index) {
                    final grupo = GrupoAlimento.grupos[index];
                    return _buildGrupoCard(
                      context,
                      grupo,
                      textTheme,
                      feedbackService,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrupoCard(
    BuildContext context,
    GrupoAlimento grupo,
    TextTheme textTheme,
    dynamic feedbackService,
  ) {
    // Converter cor hex para Color
    final cor = Color(int.parse(grupo.cor.replaceFirst('#', '0xFF')));

    return Semantics(
      label:
          'Grupo ${grupo.nomeRegional}. ${grupo.descricao}. Toque para ver os alimentos.',
      child: Card(
        color: AppColors.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // Feedback tátil e sonoro
            await feedbackService.navigationFeedback();

            if (context.mounted) {
              // Navegar para lista de alimentos do grupo
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BuscarAlimentoScreen(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone do grupo com fundo colorido
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      grupo.icone,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Nome regional do grupo
                Text(
                  grupo.nomeRegional,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Descrição curta
                Text(
                  grupo.descricao,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.grey600,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Exemplos de alimentos (preview)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  children:
                      grupo.exemplos.take(2).map((exemplo) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            exemplo,
                            style: textTheme.bodySmall?.copyWith(
                              color: cor,
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

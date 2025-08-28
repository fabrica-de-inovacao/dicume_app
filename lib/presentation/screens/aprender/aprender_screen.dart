import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';

class AprenderScreen extends StatelessWidget {
  const AprenderScreen({super.key});
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
          'Aprender',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de construção
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.construction,
                  size: 60,
                  color: AppColors.primaryLight,
                ),
              ),

              const SizedBox(height: 24),

              // Título
              Text(
                'Em Construção',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Descrição
              Text(
                'Esta seção está sendo desenvolvida!\n\nEm breve você terá acesso a conteúdos educativos sobre alimentação saudável, dicas nutricionais e muito mais.',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Card com informações futuras
              DicumeElegantCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.warning,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'O que vem por aí',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildFuturaFuncionalidade(
                      Icons.school,
                      'Guias Educativos',
                      'Aprenda sobre nutrição de forma simples',
                      textTheme,
                    ),

                    const SizedBox(height: 12),

                    _buildFuturaFuncionalidade(
                      Icons.tips_and_updates,
                      'Dicas Personalizadas',
                      'Sugestões baseadas no seu perfil',
                      textTheme,
                    ),

                    const SizedBox(height: 12),

                    _buildFuturaFuncionalidade(
                      Icons.quiz,
                      'Quiz Interativo',
                      'Teste seus conhecimentos',
                      textTheme,
                    ),

                    const SizedBox(height: 12),

                    _buildFuturaFuncionalidade(
                      Icons.video_library,
                      'Vídeos Explicativos',
                      'Conteúdo visual e didático',
                      textTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuturaFuncionalidade(
    IconData icone,
    String titulo,
    String descricao,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icone, color: AppColors.primaryLight, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                descricao,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

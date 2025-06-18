import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

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
          'Meu Perfil', // Palavreado regional conforme guia
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
              // Card do perfil
              Card(
                color: AppColors.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Cantos arredondados conforme guia
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Usuário DICUMÊ',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700, // Bold conforme guia
                          fontFamily: 'Montserrat',
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Bem-vindo ao app!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.grey600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Seção de informações opcionais
              Text(
                'Minhas Coisas', // Palavreado regional conforme guia
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w700, // Bold conforme guia
                  fontFamily: 'Montserrat',
                ),
              ),

              const SizedBox(height: 16),

              // Lista de opções
              Expanded(
                child: Column(
                  children: [
                    _buildOptionCard(
                      context,
                      textTheme,
                      Icons.edit_outlined,
                      'Editar Informações',
                      'Dados pessoais opcionais',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Em breve: Edição de perfil!',
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
                    ),

                    const SizedBox(height: 12),

                    _buildOptionCard(
                      context,
                      textTheme,
                      Icons.help_outline,
                      'Ajuda',
                      'Como usar o app',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Em breve: Central de ajuda!',
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
                    ),

                    const SizedBox(height: 12),

                    _buildOptionCard(
                      context,
                      textTheme,
                      Icons.info_outline,
                      'Sobre o DICUMÊ',
                      'Conheça o projeto',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Em breve: Sobre o projeto!',
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
                    ),

                    const Spacer(),

                    // Botão de sair
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implementar logout
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Em breve: Logout!',
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.error, // Vermelho para ação destrutiva
                          foregroundColor: AppColors.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Sair do App',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight:
                                FontWeight.w600, // SemiBold conforme guia
                            fontFamily: 'Montserrat',
                          ),
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
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    TextTheme textTheme,
    IconData icon,
    String titulo,
    String subtitulo, {
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brown50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
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

              Icon(Icons.arrow_forward_ios, color: AppColors.grey400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

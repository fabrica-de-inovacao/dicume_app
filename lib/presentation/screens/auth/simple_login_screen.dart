import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo e Título
              _buildHeader(),

              const SizedBox(height: 48),

              // Botão de Login com Google
              if (authState.isLoading) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 16),
                Text(
                  'Entrando...',
                  style: AppTextStyles.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed:
                      () =>
                          ref
                              .read(authControllerProvider.notifier)
                              .signInWithGoogle(),
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: Text(
                    'Entrar com Google',
                    style: AppTextStyles.botaoPrincipal,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Mensagem de erro
              if (authState.hasError) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          authState.errorMessage ?? 'Erro desconhecido',
                          style: AppTextStyles.textoErro,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () =>
                                ref
                                    .read(authControllerProvider.notifier)
                                    .clearError(),
                        icon: const Icon(Icons.close, size: 20),
                        color: AppColors.error,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant,
            size: 60,
            color: AppColors.onPrimary,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          AppConstants.appName,
          style: AppTextStyles.screenTitle,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Educação nutricional para uma vida mais saudável',
          style: AppTextStyles.textTheme.bodyMedium!.copyWith(
            color: AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

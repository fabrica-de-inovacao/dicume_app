import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/feedback_service.dart';
import '../theme/app_colors.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/providers/auth_providers.dart';

/// Utilitário para verificar se o usuário está autenticado
/// e mostrar o bottom sheet de login quando necessário
class AuthUtils {
  /// Verifica se o usuário está autenticado. Se não estiver,
  /// mostra o bottom sheet de login e retorna false.
  /// Se estiver autenticado, retorna true.
  static Future<bool> requireAuthentication(
    BuildContext context,
    WidgetRef ref, {
    String? message,
  }) async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      return true;
    }

    // Mostrar bottom sheet de login
    await _showLoginBottomSheet(context, ref, message: message);

    // Verificar novamente após o login
    final newIsLoggedIn = await authService.isLoggedIn();
    return newIsLoggedIn;
  }

  /// Mostra o bottom sheet de login
  static Future<void> _showLoginBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    String? message,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicador de arrastar
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outline,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Logo/Ícone
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.login,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        Text(
                          'Login Necessário',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Mensagem personalizada ou padrão
                        Text(
                          message ??
                              'Para usar esta funcionalidade, você precisa estar logado.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 32),

                        // Botão Google Sign-In
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              FeedbackService().mediumTap();

                              // Fechar o bottom sheet
                              Navigator.of(context).pop();

                              // Mostrar loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );

                              try {
                                // Usar o AuthService (lógica correta)
                                final authService = AuthService();
                                final result =
                                    await authService.signInWithGoogle();

                                if (!result.success) {
                                  // Fechar loading
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result.message ??
                                              'Erro ao fazer login',
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                  return;
                                }

                                // Google login OK, agora enviar idToken para API DICUMÊ
                                if (result.googleToken != null) {
                                  try {
                                    final remoteDataSource = ref.read(
                                      authRemoteDataSourceProvider,
                                    );
                                    final authResponse = await remoteDataSource
                                        .signInWithGoogle(result.googleToken!);

                                    // Salvar dados do usuário e token
                                    await authService.saveUserData(
                                      authResponse.usuario.toJson(),
                                    );
                                    await authService.saveToken(
                                      authResponse.token,
                                    );

                                    // Fechar loading
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Bem-vindo, ${authResponse.usuario.nome}!',
                                          ),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  } catch (apiError) {
                                    // Erro na API DICUMÊ
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Erro ao conectar com servidor DICUMÊ: $apiError',
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                } else {
                                  // Fechar loading
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Token do Google não disponível',
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                // Fechar loading
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao fazer login: $e'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: AppColors.outline,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.g_mobiledata, size: 24),
                            label: const Text(
                              'Continuar com Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Botão para continuar sem login
                        TextButton(
                          onPressed: () {
                            FeedbackService().lightTap();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Continuar sem login',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Texto informativo
                        Text(
                          'Ao continuar, você concorda com nossos Termos de Serviço e Política de Privacidade.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }
}

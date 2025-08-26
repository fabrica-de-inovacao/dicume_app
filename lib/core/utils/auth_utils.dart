import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../../presentation/screens/auth/auth_modal_screen.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../data/providers/refeicao_providers.dart';

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
    // Preferir checar o estado via AuthController (Riverpod)
    try {
      final authState = ref.read(authControllerProvider);
      debugPrint(
        '[AUTH_UTILS] Estado atual: isAuthenticated=${authState.isAuthenticated}, user=${authState.user?.nome}',
      );
      if (authState.isAuthenticated) return true;
    } catch (e) {
      debugPrint('[AUTH_UTILS] Erro ao ler AuthController: $e');
      // Se por algum motivo não houver provider disponível, fallback para AuthService
    }

    // Verificar AuthService apenas como fallback se AuthController falhou
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    debugPrint('[AUTH_UTILS] AuthService.isLoggedIn: $isLoggedIn');

    // Se AuthService diz que está logado mas AuthController diz que não,
    // vamos forçar uma reinicialização do AuthController antes de abrir o modal
    if (isLoggedIn) {
      debugPrint(
        '[AUTH_UTILS] Inconsistência detectada. Reinicializando AuthController...',
      );
      try {
        await ref.read(authControllerProvider.notifier).initialize();
        // Verificar novamente após inicialização
        final authStateAfter = ref.read(authControllerProvider);
        debugPrint(
          '[AUTH_UTILS] Após reinicialização: isAuthenticated=${authStateAfter.isAuthenticated}',
        );
        if (authStateAfter.isAuthenticated) return true;
      } catch (e) {
        debugPrint('[AUTH_UTILS] Erro ao reinicializar AuthController: $e');
      }
    }

    // Verificar se o context ainda está montado antes de abrir modal
    if (!context.mounted) {
      debugPrint(
        '[AUTH_UTILS] Context não está montado, cancelando autenticação',
      );
      return false;
    }

    debugPrint('[AUTH_UTILS] Abrindo modal de autenticação...');
    // Abrir modal de autenticação
    final authenticated = await showAuthModal(context);
    debugPrint('[AUTH_UTILS] Modal retornou: $authenticated');

    // Se autenticou via modal, forçar atualização completa do estado
    if (authenticated) {
      try {
        // Invalidar providers relacionados ao usuário
        ref.invalidate(perfilStatusProvider);

        // Inicializar o AuthController para propagar estado
        await ref.read(authControllerProvider.notifier).initialize();

        debugPrint('[AUTH_UTILS] Estado de autenticação atualizado após login');
      } catch (e) {
        debugPrint('[AUTH_UTILS] falha ao inicializar auth controller: $e');
      }
    }

    return authenticated;
  }
}

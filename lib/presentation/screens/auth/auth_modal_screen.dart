import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';

class AuthModalScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const AuthModalScreen({super.key, this.onSuccess, this.onCancel});

  @override
  State<AuthModalScreen> createState() => _AuthModalScreenState();
}

class _AuthModalScreenState extends State<AuthModalScreen> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  Future<void> _signInWithGoogle() async {
    debugPrint('[AUTH_MODAL] Iniciando processo de login com Google...');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('[AUTH_MODAL] Passo 1: Fazendo login com Google...');

      // 1. Fazer login com Google
      final googleResult = await _authService.signInWithGoogle();

      debugPrint(
        '[AUTH_MODAL] Resultado do Google Sign-In: success=${googleResult.success}',
      );

      if (!googleResult.success) {
        debugPrint(
          '[AUTH_MODAL] ERRO no Google Sign-In: ${googleResult.message}',
        );
        throw Exception(googleResult.message ?? 'Erro no login com Google');
      }

      debugPrint('[AUTH_MODAL] Token Google obtido com sucesso');
      debugPrint('[AUTH_MODAL] Passo 2: Autenticando com API do DICUMÊ...');

      // 2. Autenticar com a API do DICUMÊ
      final apiResult = await _apiService.authenticateWithGoogle(
        googleResult.googleToken!,
      );

      debugPrint(
        '[AUTH_MODAL] Resultado da API DICUMÊ: success=${apiResult.success}',
      );

      if (!apiResult.success) {
        debugPrint('[AUTH_MODAL] ERRO na autenticação API: ${apiResult.error}');
        throw Exception(apiResult.error ?? 'Erro na autenticação');
      }

      debugPrint('[AUTH_MODAL] Passo 3: Login realizado com sucesso!');

      // 3. Login realizado com sucesso
      await FeedbackService().strongTap();
      debugPrint('[AUTH_MODAL] Passo 3: Login realizado com sucesso!');

      // 3. Login realizado com sucesso
      await FeedbackService().strongTap();

      if (mounted) {
        debugPrint(
          '[AUTH_MODAL] Fechando modal e executando callback de sucesso',
        );
        // Fechar modal e executar callback de sucesso
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      }
    } catch (e) {
      debugPrint('[AUTH_MODAL] ERRO GERAL no processo de login: $e');
      debugPrint('[AUTH_MODAL] Tipo do erro: ${e.runtimeType}');

      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      await FeedbackService().mediumTap();
    } finally {
      debugPrint('[AUTH_MODAL] Finalizando processo de login');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cancel() {
    debugPrint('[AUTH_MODAL] Usuário cancelou o login');
    FeedbackService().lightTap();
    Navigator.of(context).pop();
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de arrastar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Ícone
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),

          // Título
          Text(
            'Entre no DICUMÊ',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Descrição
          Text(
            'Para salvar seus pratos e acompanhar seu progresso, você precisa fazer login.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Mensagem de erro
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Botão Google Sign-In
          SizedBox(
            width: double.infinity,
            child: DicumeElegantButton(
              onPressed: _isLoading ? null : _signInWithGoogle,
              text: _isLoading ? 'Entrando...' : 'Entrar com Google',
              icon: _isLoading ? null : Icons.login,
              isLoading: _isLoading,
            ),
          ),
          const SizedBox(height: 12),

          // Botão cancelar
          SizedBox(
            width: double.infinity,
            child: DicumeElegantButton(
              onPressed: _isLoading ? null : _cancel,
              text: 'Continuar sem entrar',
              isOutlined: true,
            ),
          ),
          const SizedBox(height: 16),

          // Texto legal
          Text(
            'Ao entrar, você concorda com nossos Termos de Uso e Política de Privacidade.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Função helper para mostrar o modal de autenticação
Future<bool> showAuthModal(BuildContext context) async {
  debugPrint('[AUTH_MODAL] Abrindo modal de autenticação');
  bool authenticated = false;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    builder:
        (context) => AuthModalScreen(
          onSuccess: () {
            debugPrint('[AUTH_MODAL] Callback de sucesso executado');
            authenticated = true;
          },
          onCancel: () {
            debugPrint('[AUTH_MODAL] Callback de cancelamento executado');
            authenticated = false;
          },
        ),
  );

  debugPrint('[AUTH_MODAL] Modal fechado. Usuário autenticado: $authenticated');
  return authenticated;
}

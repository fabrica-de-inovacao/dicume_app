import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';

// Provider local para controlar estado de carregamento do modal
final _authModalLoadingProvider = StateProvider<bool>((ref) => false);

class AuthModalScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const AuthModalScreen({super.key, this.onSuccess, this.onCancel});

  @override
  ConsumerState<AuthModalScreen> createState() => _AuthModalScreenState();
}

enum _AuthMethod { google, email }

class _AuthModalScreenState extends ConsumerState<AuthModalScreen> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  // _isLoading agora gerenciado por Riverpod (_authModalLoadingProvider)
  String? _errorMessage;
  // Email/Password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  _AuthMethod _method = _AuthMethod.google;
  bool _isSignup = false;
  Future<void> _signInWithGoogle() async {
    debugPrint('[AUTH_MODAL] Iniciando processo de login com Google...');
    // marcar carregamento via provider
    ref.read(_authModalLoadingProvider.notifier).state = true;
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }

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
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
      await FeedbackService().mediumTap();
    } finally {
      debugPrint('[AUTH_MODAL] Finalizando processo de login');
      // finalizar carregamento via provider
      ref.read(_authModalLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _signinWithEmail() async {
    ref.read(_authModalLoadingProvider.notifier).state = true;
    if (mounted) {
      setState(() => _errorMessage = null);
    }

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      if (email.isEmpty || senha.isEmpty) {
        throw Exception('Preencha email e senha');
      }

      final result = await _apiService.signinWithEmail(email, senha);
      if (!result.success || result.data == null) {
        throw Exception(result.error ?? 'Erro no login');
      }

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      ref.read(_authModalLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _signupWithEmail() async {
    ref.read(_authModalLoadingProvider.notifier).state = true;
    if (mounted) {
      setState(() => _errorMessage = null);
    }

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();
      final nome = _nomeController.text.trim();

      if (email.isEmpty || senha.isEmpty || nome.isEmpty) {
        throw Exception('Preencha nome, email e senha');
      }

      final result = await _apiService.signupWithEmail(email, senha, nome);
      if (!result.success || result.data == null) {
        throw Exception(result.error ?? 'Erro ao criar conta');
      }

      // Conta criada com sucesso, fazer signin automático
      await _signinWithEmail();
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      ref.read(_authModalLoadingProvider.notifier).state = false;
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
    // Usar provider local para estado de carregamento
    final isLoading = ref.watch(_authModalLoadingProvider);
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
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: drag indicator + close button
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                // Close icon
                IconButton(
                  onPressed: _cancel,
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ícone principal
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
              _method == _AuthMethod.google
                  ? 'Entre no DICUMÊ'
                  : (_isSignup ? 'Crie sua conta' : 'Entre no DICUMÊ'),
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Descrição
            Text(
              _method == _AuthMethod.google
                  ? 'Use sua conta Google para entrar rapidamente.'
                  : (_isSignup
                      ? 'Crie uma conta para salvar seus pratos e acompanhar seu progresso.'
                      : 'Entre com seu email e senha para acessar sua conta.'),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Segment control: Google | Conta (email)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Google'),
                  selected: _method == _AuthMethod.google,
                  onSelected:
                      (_) => setState(() {
                        _method = _AuthMethod.google;
                        _isSignup = false;
                        _errorMessage = null;
                      }),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Conta (email)'),
                  selected: _method == _AuthMethod.email,
                  onSelected:
                      (_) => setState(() {
                        _method = _AuthMethod.email;
                        _errorMessage = null;
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Campos de email/senha apenas quando método = email
            if (_method == _AuthMethod.email) ...[
              if (_isSignup) ...[
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome de Exibição',
                  ),
                ),
                const SizedBox(height: 8),
              ],

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              const SizedBox(height: 12),
            ],

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

            // Botões de ação por método
            if (_method == _AuthMethod.google) ...[
              SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  onPressed: isLoading ? null : _signInWithGoogle,
                  text: isLoading ? 'Entrando...' : 'Entrar com Google',
                  icon: isLoading ? null : Icons.login,
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(height: 12),
              // Link para entrar com email caso queira
              TextButton(
                onPressed:
                    () => setState(() {
                      _method = _AuthMethod.email;
                      _isSignup = false;
                    }),
                child: const Text('Ou prefere entrar com email e senha?'),
              ),
            ] else ...[
              // método email
              SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  onPressed:
                      isLoading
                          ? null
                          : (_isSignup ? _signupWithEmail : _signinWithEmail),
                  text:
                      isLoading
                          ? (_isSignup ? 'Criando conta...' : 'Entrando...')
                          : (_isSignup ? 'Criar Conta' : 'Entrar'),
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(height: 8),
              // Toggle link between signup/signin
              TextButton(
                onPressed:
                    () => setState(() {
                      _isSignup = !_isSignup;
                      _errorMessage = null;
                    }),
                child: Text(
                  _isSignup
                      ? 'Já possui conta? Entrar'
                      : 'Não possui uma conta? crie agora',
                ),
              ),
            ],
            const SizedBox(height: 12),

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
    builder: (context) {
      return AuthModalScreen(
        onSuccess: () {
          debugPrint('[AUTH_MODAL] Callback de sucesso executado');
          authenticated = true;
        },
        onCancel: () {
          debugPrint('[AUTH_MODAL] Callback de cancelamento executado');
          authenticated = false;
        },
      );
    },
  );

  debugPrint('[AUTH_MODAL] Modal fechado. Usuário autenticado: $authenticated');

  // Se autenticado, solicitar que o AuthController revalide o estado
  if (authenticated) {
    try {
      // Usar ProviderScope.containerOf para acessar providers sem ter WidgetRef
      final container = ProviderScope.containerOf(context);
      container.read(authControllerProvider.notifier).initialize();
    } catch (e) {
      debugPrint(
        '[AUTH_MODAL] Não foi possível inicializar AuthController: $e',
      );
    }
  }

  return authenticated;
}

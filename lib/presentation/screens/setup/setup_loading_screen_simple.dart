import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/auth_service.dart';

class SetupLoadingScreen extends StatefulWidget {
  const SetupLoadingScreen({super.key});

  @override
  State<SetupLoadingScreen> createState() => _SetupLoadingScreenState();
}

class _SetupLoadingScreenState extends State<SetupLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final AuthService _authService = AuthService();

  String _currentStep = 'Iniciando...';
  double _progress = 0.0;
  bool _hasError = false;
  String? _errorMessage;

  final List<SetupStep> _steps = [
    SetupStep('Verificando conexão...', 0.25),
    SetupStep('Preparando dados...', 0.5),
    SetupStep('Configurando ambiente...', 0.75),
    SetupStep('Finalizando...', 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSetup();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startSetup() async {
    try {
      for (int i = 0; i < _steps.length; i++) {
        await _updateStep(i);
        await Future.delayed(const Duration(milliseconds: 800));
      }

      // Marcar primeiro lançamento como completo
      await _authService.markFirstLaunchComplete();

      // Navegar para home
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Erro durante a configuração: $e';
      });
    }
  }

  Future<void> _updateStep(int stepIndex) async {
    if (stepIndex < _steps.length) {
      setState(() {
        _currentStep = _steps[stepIndex].description;
        _progress = _steps[stepIndex].progress;
      });
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _currentStep = 'Iniciando...';
      _progress = 0.0;
    });
    _startSetup();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animação de loading
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Título
              Text(
                'Preparando o DICUMÊ',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Descrição do passo atual
              if (!_hasError) ...[
                Text(
                  _currentStep,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Barra de progresso
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Porcentagem
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              // Mensagem de erro
              if (_hasError) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Algo deu errado',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage ?? 'Erro desconhecido',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Botão de retry
                DicumeElegantButton(
                  onPressed: _retry,
                  text: 'Tentar Novamente',
                  icon: Icons.refresh,
                ),
              ],

              const Spacer(),

              // Texto de rodapé
              Text(
                'Isso pode levar alguns segundos...',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupStep {
  final String description;
  final double progress;

  SetupStep(this.description, this.progress);
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/animation_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(AnimationConstants.splashDuration);

    if (mounted) {
      // Navegar usando go_router em vez de Navigator
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Ícone do app (placeholder por enquanto)
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
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: AppColors.onPrimary,
                    ),
                  )
                  .animate()
                  .scale(
                    duration: AnimationConstants.slowAnimation,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: AnimationConstants.normalAnimation),

              const SizedBox(height: 32),

              // Nome do app
              Text(AppConstants.appName, style: AppTextStyles.splashTitle)
                  .animate(delay: 200.ms)
                  .fadeIn(duration: AnimationConstants.normalAnimation)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: AnimationConstants.normalAnimation,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 16),

              // Descrição
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'App educacional nutricional\npara Imperatriz-MA',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: AnimationConstants.normalAnimation)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: AnimationConstants.normalAnimation,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 64),

              // Loading indicator
              SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: AnimationConstants.normalAnimation)
                  .scale(
                    duration: AnimationConstants.normalAnimation,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela temporária para testar o setup
class TemporaryHomeScreen extends StatelessWidget {
  const TemporaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DICUMÊ Setup Completo!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 120,
              color: AppColors.semaforoVerde,
            ).animate().scale(
              duration: AnimationConstants.slowAnimation,
              curve: Curves.elasticOut,
            ),

            const SizedBox(height: 32),

            Text(
              '🎉 Checkpoint 1.1 Completo!',
              style: AppTextStyles.screenTitle,
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '✅ Flutter com FVM configurado\n'
                '✅ Estrutura Clean Architecture\n'
                '✅ Dependências instaladas\n'
                '✅ Tema maranhense aplicado\n'
                '✅ Riverpod configurado\n'
                '✅ Animações funcionando',
                style: AppTextStyles.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pronto para o próximo checkpoint! 🚀'),
                    backgroundColor: AppColors.semaforoVerde,
                  ),
                );
              },
              icon: Icon(Icons.rocket_launch),
              label: Text('Próximo Checkpoint'),
            ).animate(delay: 600.ms).fadeIn().scale(curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }
}

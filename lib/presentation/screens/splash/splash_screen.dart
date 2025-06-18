import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/animation_constants.dart';
import '../../../core/router/app_router.dart';
import '../../controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Aguarda um tempo mínimo para mostrar a splash screen
    await Future.delayed(AnimationConstants.splashDuration);

    if (mounted && !_hasNavigated) {
      _hasNavigated = true;

      // Lê o estado de autenticação
      final authState = ref.read(authControllerProvider);

      // Decide para onde navegar baseado no estado
      if (authState.isAuthenticated) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.login);
      }
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

// Tela temporária para testar o setup (removida pois não é mais necessária)

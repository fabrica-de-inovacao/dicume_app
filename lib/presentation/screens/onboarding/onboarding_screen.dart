import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao DICUMÊ!',
      subtitle: 'Seu companheiro para uma alimentação mais saudável',
      description:
          'Descubra como tornar suas refeições mais equilibradas com nosso semáforo nutricional regionalizado.',
      imagePath: 'assets/images/onboarding_welcome.png',
      animation: 'assets/lottie/celebration.json',
    ),
    OnboardingPage(
      title: 'Monte Pratos Inteligentes',
      subtitle: 'Cada alimento tem sua cor no semáforo',
      description:
          'Verde para consumir à vontade, amarelo com moderação e vermelho apenas ocasionalmente.',
      imagePath: 'assets/images/onboarding_plate.png',
      animation: 'assets/lottie/cooking.json',
    ),
    OnboardingPage(
      title: 'Acompanhe seu Progresso',
      subtitle: 'Visualize seu dia alimentar',
      description:
          'Registre suas refeições e veja como está seu equilíbrio nutricional ao longo do dia.',
      imagePath: 'assets/images/onboarding_progress.png',
      animation: 'assets/lottie/plate_empty.json',
    ),
    OnboardingPage(
      title: 'Vamos Começar!',
      subtitle: 'Preparando seu ambiente personalizado',
      description:
          'Estamos configurando tudo para você ter a melhor experiência possível.',
      imagePath: 'assets/images/onboarding_start.png',
      isLastPage: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      FeedbackService().lightTap();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      FeedbackService().lightTap();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    FeedbackService().strongTap();
    context.go('/setup-loading');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progresso
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Botão voltar (só a partir da segunda página)
                  if (_currentIndex > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.textSecondary,
                    )
                  else
                    const SizedBox(width: 48),

                  // Indicadores de progresso
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentIndex ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                index == _currentIndex
                                    ? AppColors.primary
                                    : AppColors.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Botão pular (só nas primeiras páginas)
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        'Pular',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // Conteúdo das páginas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], textTheme);
                },
              ),
            ),

            // Botão de ação
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  onPressed: _nextPage,
                  text:
                      _currentIndex == _pages.length - 1
                          ? 'Preparar Ambiente'
                          : 'Continuar',
                  icon:
                      _currentIndex == _pages.length - 1
                          ? Icons.rocket_launch
                          : Icons.arrow_forward,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Imagem ou animação
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                page.animation != null
                    ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    )
                    : page.imagePath != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        page.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: AppColors.grey300,
                          );
                        },
                      ),
                    )
                    : Icon(
                      Icons.restaurant_menu,
                      size: 100,
                      color: AppColors.primary,
                    ),
          ),

          const SizedBox(height: 40),

          // Título
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Subtítulo
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          // Descrição
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String? imagePath;
  final String? animation;
  final bool isLastPage;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    this.imagePath,
    this.animation,
    this.isLastPage = false,
  });
}

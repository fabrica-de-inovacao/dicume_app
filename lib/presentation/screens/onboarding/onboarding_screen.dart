import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../auth/auth_modal_screen.dart';
import '../../../core/services/database_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  static const List<IconData> _pageIcons = [
    Icons.celebration_rounded,
    Icons.restaurant_menu_rounded,
    Icons.trending_up_rounded,
    Icons.track_changes_rounded,
    Icons.login_rounded,
    Icons.rocket_launch_rounded,
  ];

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao DICUMÊ!',
      subtitle: 'Seu companheiro para uma alimentação mais saudável',
      description:
          'Descubra como tornar suas refeições mais equilibradas com nosso semáforo nutricional regionalizado.',
    ),
    OnboardingPage(
      title: 'Monte Pratos Inteligentes',
      subtitle: 'Cada alimento tem sua cor no semáforo',
      description:
          'Verde para consumir à vontade, amarelo com moderação e vermelho apenas ocasionalmente.',
    ),
    OnboardingPage(
      title: 'Acompanhe seu Progresso',
      subtitle: 'Visualize seu dia alimentar',
      description:
          'Registre suas refeições e veja como está seu equilíbrio nutricional ao longo do dia.',
    ),
    OnboardingPage(
      title: 'Qual sua meta?',
      subtitle: 'Defina um objetivo simples',
      description:
          'Escreva uma meta curta que descreva seu objetivo com o app (ex: controlar carboidratos, reduzir peso, manter glicemia estável).',
    ),
    OnboardingPage(
      title: 'Faça login para salvar',
      subtitle: 'Salve seu progresso',
      description:
          'Faça login para salvar sua meta e sincronizar seu progresso entre dispositivos. Você pode pular se preferir salvar apenas localmente.',
    ),
    OnboardingPage(
      title: 'Vamos Começar!',
      subtitle: 'Preparando seu ambiente personalizado',
      description:
          'Estamos configurando tudo para você ter a melhor experiência possível.',
      isLastPage: true,
    ),
  ];

  // Controller para a nova página de meta
  final TextEditingController _metaController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentIndex < _pages.length - 1) {
      FeedbackService().lightTap();

      // Se estivermos na página de meta, salvar localmente antes de avançar
      if (_pages[_currentIndex].title == 'Qual sua meta?') {
        final meta = _metaController.text.trim();
        if (meta.isNotEmpty) {
          try {
            await ref
                .read(databaseServiceProvider)
                .setCacheValue('meta_atual', meta);
            await FeedbackService().successFeedback();
          } catch (e) {
            await FeedbackService().errorFeedback();
          }
        }
      }

      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipPage() {
    // Avança sem salvar (usado pelo botão Pular nas steps)
    FeedbackService().lightTap();
    if (_currentIndex < _pages.length - 1) {
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
                      onPressed: _skipPage,
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
    final icon = _pageIcons[_pages.indexOf(page)];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),

          // Ícone principal estilizado
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primaryLight.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: AppColors.primary),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Subtítulo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Descrição
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Se for a página de login, renderizar botão para abrir modal de autenticação
          if (page.title == 'Faça login para salvar') ...[
            const SizedBox(height: 8),
            if (_isLoggedIn)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      'Login realizado com sucesso!',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  text: 'Fazer login',
                  onPressed: () async {
                    FeedbackService().lightTap();
                    final loggedIn = await showAuthModal(context);
                    if (loggedIn && mounted) {
                      setState(() => _isLoggedIn = true);
                      await FeedbackService().successFeedback();
                      await Future.delayed(
                        const Duration(milliseconds: 1200),
                      );
                      if (mounted) _nextPage();
                    }
                  },
                  isSmall: false,
                  icon: Icons.login,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _skipPage,
                child: const Text('Pular, depois faço login'),
              ),
            ],
          ] else
          // Se for a página de meta, renderizar campo de entrada e botões
          if (page.title == 'Qual sua meta?') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _metaController,
              maxLength: 80,
              decoration: InputDecoration(
                hintText: 'Ex: Controlar carboidratos em cada refeição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                // Se a largura for pequena, empilhar verticalmente para evitar overflow
                if (constraints.maxWidth < 360) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DicumeElegantButton(
                          text: 'Salvar localmente',
                          onPressed: () async {
                            FeedbackService().lightTap();
                            final meta = _metaController.text.trim();
                            if (meta.isNotEmpty) {
                              try {
                                await ref
                                    .read(databaseServiceProvider)
                                    .setCacheValue('meta_atual', meta);
                                await FeedbackService().successFeedback();
                              } catch (e) {
                                await FeedbackService().errorFeedback();
                              }
                            }
                          },
                          isSmall: true,
                          icon: Icons.save,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: DicumeElegantButton(
                          text: 'Salvar e continuar',
                          onPressed: () async {
                            FeedbackService().lightTap();
                            final meta = _metaController.text.trim();
                            if (meta.isNotEmpty) {
                              try {
                                await ref
                                    .read(databaseServiceProvider)
                                    .setCacheValue('meta_atual', meta);
                                await FeedbackService().successFeedback();
                                _nextPage();
                              } catch (e) {
                                await FeedbackService().errorFeedback();
                              }
                            } else {
                              _nextPage();
                            }
                          },
                          isSmall: true,
                          icon: Icons.save,
                        ),
                      ),
                    ],
                  );
                }

                // Largura suficiente: manter os botões lado a lado
                return Row(
                  children: [
                    Expanded(
                      child: DicumeElegantButton(
                        text: 'Salvar localmente',
                        onPressed: () async {
                          FeedbackService().lightTap();
                          final meta = _metaController.text.trim();
                          if (meta.isNotEmpty) {
                            try {
                              await ref
                                  .read(databaseServiceProvider)
                                  .setCacheValue('meta_atual', meta);
                              await FeedbackService().successFeedback();
                            } catch (e) {
                              await FeedbackService().errorFeedback();
                            }
                          }
                        },
                        isSmall: true,
                        icon: Icons.save,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DicumeElegantButton(
                        text: 'Salvar e continuar',
                        onPressed: () async {
                          FeedbackService().lightTap();
                          final meta = _metaController.text.trim();
                          if (meta.isNotEmpty) {
                            try {
                              await ref
                                  .read(databaseServiceProvider)
                                  .setCacheValue('meta_atual', meta);
                              await FeedbackService().successFeedback();
                              _nextPage();
                            } catch (e) {
                              await FeedbackService().errorFeedback();
                            }
                          } else {
                            _nextPage();
                          }
                        },
                        isSmall: true,
                        icon: Icons.save,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                FeedbackService().lightTap();
                _nextPage();
              },
              child: const Text('Pular'),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final bool isLastPage;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    this.isLastPage = false,
  });
}

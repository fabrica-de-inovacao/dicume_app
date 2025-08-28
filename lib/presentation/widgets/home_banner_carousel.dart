import 'package:flutter/material.dart';
import 'dart:async';

import '../../core/theme/app_colors.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Conteúdo dos banners
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Descubra os Sabores do Nordeste',
      'subtitle': 'Alimentos frescos e nutritivos da nossa terra para uma vida mais saudável.',
      'icon': Icons.eco_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Monte seu Prato Ideal',
      'subtitle': 'Use nosso guia para criar refeições balanceadas e deliciosas em minutos.',
      'icon': Icons.restaurant_menu_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'Entenda o Semáforo Nutricional',
      'subtitle': 'Faça escolhas inteligentes e controle sua alimentação de forma visual e fácil.',
      'icon': Icons.traffic_rounded,
      'color': AppColors.warning,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Inicia a troca automática de banners
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuint,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: banner['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: banner['color'].withOpacity(0.3), width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(banner['icon'], size: 48, color: banner['color']),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner['title'],
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                banner['subtitle'],
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: _currentPage == index ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.primary : AppColors.grey300,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

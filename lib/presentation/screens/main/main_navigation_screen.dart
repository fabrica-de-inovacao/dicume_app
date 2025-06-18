import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/feedback_providers.dart';

// Provider para controlar a tab ativa
final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (index) => _onTabTapped(context, ref, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey600,
          selectedFontSize: 14, // Fonte maior para acessibilidade
          unselectedFontSize: 12,
          iconSize: 26, // Ícones maiores para acessibilidade
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600, // SemiBold conforme guia
            fontFamily: 'Montserrat',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              activeIcon: Icon(Icons.restaurant_menu, size: 30),
              label: 'Montar Prato', // Palavreado regional conforme guia
              tooltip: 'Botar Comida',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), // 📖 conforme guia
              activeIcon: Icon(Icons.book, size: 30),
              label: 'Meu Rango', // Palavreado regional conforme guia
              tooltip: 'Meu Rango de Hoje',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), // 👤 conforme guia
              activeIcon: Icon(Icons.person, size: 30),
              label: 'Meu Perfil', // Palavreado regional conforme guia
              tooltip: 'Minhas Coisas',
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, WidgetRef ref, int index) async {
    // Feedback tátil e sonoro para navegação entre tabs
    final feedbackService = ref.read(feedbackServiceProvider);
    await feedbackService.tabNavigationFeedback();

    ref.read(selectedTabProvider.notifier).state = index;

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.historico);
        break;
      case 2:
        context.go(AppRoutes.perfil);
        break;
    }
  }
}

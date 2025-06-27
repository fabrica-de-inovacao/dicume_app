import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/theme/app_colors.dart';

// Provider para controlar a tab ativa (Home é index 1 - meio)
final selectedTabProvider = StateProvider<int>((ref) => 1);

class MainNavigationScreen extends ConsumerWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Se estamos na home, mostra confirmação de saída
          if (selectedTab == 1) {
            _mostrarConfirmacaoSaida(context);
          } else {
            // Se não estamos na home, volta para a home
            FeedbackService().lightTap();
            _onTabTapped(context, ref, 1); // Volta para a home (index 1)
          }
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: DicumeBottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (index) => _onTabTapped(context, ref, index),
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, WidgetRef ref, int index) async {
    // Feedback tátil para navegação entre tabs
    await FeedbackService().lightTap();

    ref.read(selectedTabProvider.notifier).state = index;
    switch (index) {
      case 0:
        context.go(AppRoutes.buscar);
        break;
      case 1:
        context.go(AppRoutes.home);
        break;
      case 2:
        context.go(AppRoutes.meuDia);
        break;
      case 3:
        context.go(AppRoutes.aprender);
        break;
    }
  }

  void _mostrarConfirmacaoSaida(BuildContext context) {
    FeedbackService().mediumTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
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
                    color: AppColors.warning.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: AppColors.warning,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),

                // Título
                Text(
                  'Sair do DICUMÊ?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Descrição
                Text(
                  'Tem certeza que deseja sair do aplicativo? Seus dados estão salvos e você pode voltar a qualquer momento!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Botões
                Row(
                  children: [
                    // Botão Cancelar
                    Expanded(
                      child: DicumeElegantButton(
                        onPressed: () {
                          FeedbackService().lightTap();
                          Navigator.of(context).pop();
                        },
                        text: 'Cancelar',
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botão Sair
                    Expanded(
                      child: DicumeElegantButton(
                        onPressed: () {
                          FeedbackService().strongTap();
                          Navigator.of(context).pop();
                          // Sair do app
                          SystemNavigator.pop();
                        },
                        text: 'Sair',
                        isSecondary: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }
}

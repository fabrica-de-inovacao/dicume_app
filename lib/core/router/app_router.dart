import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/setup/setup_loading_screen.dart';
import '../../presentation/screens/auth/simple_login_screen.dart';
import '../../presentation/screens/main/main_navigation_screen.dart';
import '../../presentation/screens/home/home_screen_elegante.dart';
import '../../presentation/screens/montar_prato/buscar_alimentos_screen.dart';
import '../../presentation/screens/aprender/aprender_screen.dart';
import '../../presentation/screens/montar_prato/montar_prato_virtual_screen.dart';
import '../../presentation/screens/montar_prato/montar_prato_screen_v3.dart';
import '../../presentation/screens/historico/historico_screen_v3.dart';
import '../../presentation/screens/perfil/perfil_screen_v3.dart';
import '../../presentation/screens/meu_dia/meu_dia_screen.dart';
import '../../presentation/screens/perfil/perfil_usuario_screen.dart';
import '../../presentation/screens/developer/developer_screen.dart';

// Definição das rotas
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String setupLoading = '/setup-loading';
  static const String login = '/login';
  static const String buscar = '/buscar';
  static const String home = '/home';
  static const String aprender = '/aprender';
  static const String montarPrato = '/home/montar-prato';
  static const String montarPratoVirtual = '/montar-prato-virtual';
  static const String historico = '/home/historico';
  static const String perfil = '/home/perfil';
  static const String meuDia = '/meu-dia';
  static const String perfilUsuario = '/perfil-usuario';
  static const String developer = '/developer';
}

// Provider para o router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Iniciar sempre pela SplashScreen
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Setup Loading
      GoRoute(
        path: AppRoutes.setupLoading,
        builder: (context, state) => const SetupLoadingScreen(),
      ), // Login Screen
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ), // Tela de Montar Prato Virtual (fora da navegação principal)
      GoRoute(
        path: AppRoutes.montarPratoVirtual,
        builder: (context, state) => const MontarPratoVirtualScreen(),
      ), // Tela Perfil do Usuário (fora da navegação principal)
      GoRoute(
        path: AppRoutes.perfilUsuario,
        builder: (context, state) => const PerfilUsuarioScreen(),
      ),

      // Tela Developer (só disponível em debug)
      GoRoute(
        path: AppRoutes.developer,
        builder: (context, state) => const DeveloperScreen(),
      ),

      // Main Navigation (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          // Buscar Alimento (esquerda)
          GoRoute(
            path: AppRoutes.buscar,
            builder: (context, state) => const BuscarAlimentosScreen(),
          ), // Home Elegante (centro)
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreenElegante(),
          ),

          // Meu Dia
          GoRoute(
            path: AppRoutes.meuDia,
            builder: (context, state) => const MeuDiaScreen(),
          ),

          // Aprender (direita)
          GoRoute(
            path: AppRoutes.aprender,
            builder: (context, state) => const AprenderScreen(),
          ),

          // Montar Prato (tela completa)
          GoRoute(
            path: AppRoutes.montarPrato,
            builder: (context, state) => const MontarPratoScreenV3(),
          ),

          // Histórico
          GoRoute(
            path: AppRoutes.historico,
            builder: (context, state) => const HistoricoScreenV3(),
          ),

          // Perfil
          GoRoute(
            path: AppRoutes.perfil,
            builder: (context, state) => const PerfilScreenV3(),
          ),
        ],
      ),
    ],
  );
});

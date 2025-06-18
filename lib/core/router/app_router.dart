import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/simple_login_screen.dart';
import '../../presentation/screens/main/main_navigation_screen.dart';
import '../../presentation/screens/montar_prato/montar_prato_screen.dart';
import '../../presentation/screens/historico/historico_screen.dart';
import '../../presentation/screens/perfil/perfil_screen.dart';

// Definição das rotas
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String montarPrato = '/home/montar-prato';
  static const String historico = '/home/historico';
  static const String perfil = '/home/perfil';
}

// Provider para o router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // DEBUG: Bypass do auth - vai direto para a tela principal
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      // DEBUG: Comentado para testar navegação principal
      // TODO: Reativar quando auth estiver pronto
      // A SplashScreen fará o direcionamento correto baseado no estado de auth
      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Login Screen
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Main Navigation (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          // Home/Montar Prato
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const MontarPratoScreen(),
          ),

          // Histórico
          GoRoute(
            path: AppRoutes.historico,
            builder: (context, state) => const HistoricoScreen(),
          ),

          // Perfil
          GoRoute(
            path: AppRoutes.perfil,
            builder: (context, state) => const PerfilScreen(),
          ),
        ],
      ),
    ],
  );
});

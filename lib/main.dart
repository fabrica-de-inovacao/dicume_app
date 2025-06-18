import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/screens/auth/simple_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurações da StatusBar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Orientações permitidas (apenas portrait por enquanto)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: DicumeApp()));
}

class DicumeApp extends ConsumerWidget {
  const DicumeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppNavigator(),

      // Configurações de acessibilidade
      builder: (context, child) {
        return MediaQuery(
          // Garante que o texto respeite as configurações do sistema
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 2.0),
          ),
          child: child!,
        );
      },
    );
  }
}

// Navigator principal que controla o fluxo da aplicação
class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Exibe diferentes telas baseado no estado de autenticação
    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const SplashScreen();

      case AuthStatus.authenticated:
        return const HomeScreen(); // Placeholder por enquanto

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginScreen();
    }
  }
}

// Tela Home placeholder (será implementada posteriormente)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DICUMÊ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout placeholder
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bem-vindo ao DICUMÊ!\n\nAqui será implementada a tela principal.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

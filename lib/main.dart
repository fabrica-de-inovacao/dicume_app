import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/auth_service.dart';
import 'presentation/controllers/auth_controller.dart';
import 'core/services/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar serviços
  AuthService().initialize();
  // Inicializar HttpService para configurar Dio antes de qualquer requisição
  HttpService().initialize();

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
    final router = ref.watch(routerProvider);

    // Observar o AuthController globalmente para evitar que o provider
    // AutoDispose seja descartado logo após a inicialização.
    final authState = ref.watch(authControllerProvider);

    // Inicializar o AuthController apenas uma vez: quando o estado estiver
    // em `initial`. Isso evita reagendar initialize() em todos os rebuilds
    // (que aconteciam quando o provider mudava e causavam um loop).
    if (authState.status == AuthStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ref.read(authControllerProvider.notifier).initialize();
        } catch (e) {
          debugPrint('[MAIN] Falha ao inicializar AuthController: $e');
        }
      });
    }

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR'), const Locale('en', 'US')],
      routerConfig: router,

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

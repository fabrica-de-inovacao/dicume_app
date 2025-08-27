import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/failures.dart';
import '../../data/providers/auth_providers.dart';
import '../../data/providers/refeicao_providers.dart';
import '../../core/services/auth_service.dart';
// ...existing code...

part 'auth_controller.g.dart';

// ============================================================================
// AUTH STATE
// ============================================================================

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

// SMS flows removed from controller - not used

// ============================================================================
// AUTH CONTROLLER
// ============================================================================

@riverpod
class AuthController extends _$AuthController {
  bool _checking = false;
  @override
  AuthState build() {
    // Retorna estado inicial e verifica autenticação depois
    return const AuthState();
  }

  // Método para inicializar verificação de autenticação
  Future<void> initialize() async {
    // Inscrever-se nas mudanças de estado do repositório para reagir
    // a atualizações que venham de outros pontos do app (ex: cache local
    // atualizado por datasources, SMS, etc.).
    try {
      final repo = ref.read(authRepositoryProvider);
      // Cancelar inscrição antiga se houver
      _authSubscription?.cancel();
      _authSubscription = repo.authStateChanges.listen((user) {
        if (user != null) {
          updateAuthenticatedUser(user);
        } else {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        }
      });
    } catch (e) {
      debugPrint(
        '[AUTH_CONTROLLER] falha ao inscrever em authStateChanges: $e',
      );
    }

    await _checkAuthStatus();
    // Garantir cancelamento ao descartar o provider
    ref.onDispose(() {
      _authSubscription?.cancel();
    });
  }

  StreamSubscription<User?>? _authSubscription;

  // Verifica status de autenticação atual
  Future<void> _checkAuthStatus() async {
    if (_checking) {
      debugPrint(
        '[AUTH_CONTROLLER] _checkAuthStatus: já em execução, ignorando chamada concorrente',
      );
      return;
    }
    _checking = true;
    try {
      state = state.copyWith(status: AuthStatus.loading);
      debugPrint('[AUTH_CONTROLLER] _checkAuthStatus: iniciado');

      final isAuthenticatedUseCase = ref.read(isAuthenticatedUseCaseProvider);
      final isAuthenticated = await isAuthenticatedUseCase();

      debugPrint(
        '[AUTH_CONTROLLER] isAuthenticatedUseCase retornou: $isAuthenticated',
      );

      if (isAuthenticated) {
        final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
        final user = await getCurrentUserUseCase();

        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        debugPrint('[AUTH_CONTROLLER] usuário vindo do usecase: ${user?.nome}');
      } else {
        // Se não está autenticado, não fazer fallback - limpar completamente
        debugPrint('[AUTH_CONTROLLER] Não autenticado - limpando estado');
        state = const AuthState(
          status: AuthStatus.unauthenticated,
          user: null,
          errorMessage: null,
        );
      }
    } catch (e) {
      debugPrint('[AUTH_CONTROLLER] Erro em _checkAuthStatus: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro ao verificar autenticação: $e',
      );
    } finally {
      _checking = false;
    }
  }

  // Login com Google
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final signInWithGoogleUseCase = ref.read(signInWithGoogleUseCaseProvider);
      final result = await signInWithGoogleUseCase();

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: _getErrorMessage(failure),
          );
        },
        (user) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro inesperado durante login: $e',
      );
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final signOutUseCase = ref.read(signOutUseCaseProvider);
      final result = await signOutUseCase();

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: _getErrorMessage(failure),
          );
        },
        (_) {
          // Invalidar providers relacionados ao usuário
          ref.invalidate(perfilStatusProvider);

          // Limpar completamente o estado
          state = const AuthState(
            status: AuthStatus.unauthenticated,
            user: null,
            errorMessage: null,
          );

          // Garantir que AuthService também esteja limpo
          try {
            final authService = AuthService();
            authService.logout();
            debugPrint('[AUTH_CONTROLLER] AuthService logout executado');
          } catch (e) {
            debugPrint(
              '[AUTH_CONTROLLER] Erro ao executar AuthService.logout: $e',
            );
          }

          debugPrint('[AUTH_CONTROLLER] Logout realizado com sucesso');
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro inesperado durante logout: $e',
      );
    }
  }

  // Limpa erros
  void clearError() {
    state = state.copyWith(
      status:
          state.user != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }

  // Converte falhas em mensagens legíveis
  String _getErrorMessage(AuthFailure failure) {
    switch (failure.runtimeType) {
      case NetworkAuthFailure _:
        return 'Sem conexão com a internet. Verifique sua conexão e tente novamente.';
      case GoogleSignInCancelledFailure _:
        return 'Login cancelado.';
      case GoogleSignInFailure _:
        final googleFailure = failure as GoogleSignInFailure;
        return 'Erro no login com Google: ${googleFailure.message}';
      case InvalidCredentialsFailure _:
        return 'Credenciais inválidas. Tente novamente.';
      case UserNotFoundFailure _:
        return 'Usuário não encontrado.';
      case UserAccountDisabledFailure _:
        return 'Conta desabilitada. Entre em contato com o suporte.';
      case TooManyAttemptsFailure _:
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case ServerAuthFailure _:
        final serverFailure = failure as ServerAuthFailure;
        return 'Erro do servidor: ${serverFailure.message}';
      default:
        return 'Erro desconhecido. Tente novamente.';
    }
  }

  // Método público para atualizar usuário autenticado (usado por outros módulos)
  void updateAuthenticatedUser(User user) {
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
    debugPrint(
      '[AUTH_CONTROLLER] updateAuthenticatedUser executado: ${user.nome}',
    );
  }
}

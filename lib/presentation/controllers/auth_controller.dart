import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/failures.dart';
import '../../data/providers/auth_providers.dart';
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

// ============================================================================
// SMS VERIFICATION STATE
// ============================================================================

enum SMSVerificationStatus {
  initial,
  requesting,
  codeSent,
  verifying,
  verified,
  error,
}

class SMSVerificationState {
  final SMSVerificationStatus status;
  final String? sessionId;
  final String? phoneNumber;
  final String? errorMessage;
  final DateTime? codeExpiresAt;

  const SMSVerificationState({
    this.status = SMSVerificationStatus.initial,
    this.sessionId,
    this.phoneNumber,
    this.errorMessage,
    this.codeExpiresAt,
  });

  SMSVerificationState copyWith({
    SMSVerificationStatus? status,
    String? sessionId,
    String? phoneNumber,
    String? errorMessage,
    DateTime? codeExpiresAt,
  }) {
    return SMSVerificationState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      codeExpiresAt: codeExpiresAt ?? this.codeExpiresAt,
    );
  }

  bool get isLoading =>
      status == SMSVerificationStatus.requesting ||
      status == SMSVerificationStatus.verifying;

  bool get hasError => status == SMSVerificationStatus.error;

  bool get canVerify =>
      status == SMSVerificationStatus.codeSent &&
      sessionId != null &&
      phoneNumber != null;

  bool get isCodeExpired =>
      codeExpiresAt != null && DateTime.now().isAfter(codeExpiresAt!);
}

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

      if (isAuthenticated) {
        final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
        final user = await getCurrentUserUseCase();

        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        debugPrint('[AUTH_CONTROLLER] usuário vindo do usecase: ${user?.nome}');
      } else {
        // Tentar fallback: talvez o token/usuario tenham sido salvos pelo
        // AuthService (usado por ApiService) em chaves diferentes.
        try {
          final authService = AuthService();
          final userMap = await authService.getUserData();
          if (userMap != null) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(userMap);

            // Extrair campos com tolerância a nulos/formats
            final id =
                (map['id'] ?? map['sub'] ?? map['user_metadata']?['sub'])
                    ?.toString() ??
                '';
            final nome =
                (map['user_metadata']?['nome_exibicao'] ??
                        map['user_metadata']?['full_name'] ??
                        map['user_metadata']?['name'] ??
                        map['nome'] ??
                        '')
                    ?.toString() ??
                '';
            final email =
                (map['email'] ?? map['user_metadata']?['email'])?.toString() ??
                '';

            DateTime createdAt;
            try {
              createdAt = DateTime.parse(
                (map['created_at'] ?? map['createdAt'])?.toString() ??
                    DateTime.now().toIso8601String(),
              );
            } catch (_) {
              createdAt = DateTime.now();
            }

            DateTime updatedAt;
            try {
              updatedAt = DateTime.parse(
                (map['updated_at'] ?? map['updatedAt'])?.toString() ??
                    createdAt.toIso8601String(),
              );
            } catch (_) {
              updatedAt = createdAt;
            }

            final avatarUrl =
                (map['user_metadata']?['avatar_url'] ??
                        map['user_metadata']?['picture'] ??
                        map['avatar_url'])
                    ?.toString();

            final userEntity = User(
              id: id,
              nome:
                  nome.isNotEmpty
                      ? nome
                      : (email.isNotEmpty
                          ? email.split('@').first
                          : 'Usuário DICUMÊ'),
              email: email,
              telefone: null,
              avatarUrl: avatarUrl,
              createdAt: createdAt,
              updatedAt: updatedAt,
              preferences: const UserPreferences(),
            );

            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: userEntity,
            );
            debugPrint(
              '[AUTH_CONTROLLER] usuário vindo do fallback: ${userEntity.nome}',
            );
            return;
          }
        } catch (e) {
          debugPrint('[AUTH_CONTROLLER] Fallback getUserData falhou: $e');
        }

        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
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
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
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

  // Método público para atualizar usuário autenticado (usado pelo SMS controller)
  void updateAuthenticatedUser(User user) {
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
    debugPrint(
      '[AUTH_CONTROLLER] updateAuthenticatedUser executado: ${user.nome}',
    );
  }
}

// ============================================================================
// SMS VERIFICATION CONTROLLER
// ============================================================================

@riverpod
class SMSVerificationController extends _$SMSVerificationController {
  @override
  SMSVerificationState build() {
    return const SMSVerificationState();
  }

  // Solicita código SMS
  Future<void> requestSMSCode(String phoneNumber) async {
    try {
      state = state.copyWith(status: SMSVerificationStatus.requesting);

      final requestSMSCodeUseCase = ref.read(requestSMSCodeUseCaseProvider);
      final result = await requestSMSCodeUseCase(phoneNumber);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: SMSVerificationStatus.error,
            errorMessage: _getSMSErrorMessage(failure),
          );
        },
        (sessionId) {
          state = state.copyWith(
            status: SMSVerificationStatus.codeSent,
            sessionId: sessionId,
            phoneNumber: phoneNumber,
            codeExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: SMSVerificationStatus.error,
        errorMessage: 'Erro inesperado ao solicitar código: $e',
      );
    }
  }

  // Verifica código SMS e faz login
  Future<void> verifyAndSignIn(String verificationCode) async {
    if (!state.canVerify) {
      state = state.copyWith(
        status: SMSVerificationStatus.error,
        errorMessage: 'Não é possível verificar o código no momento.',
      );
      return;
    }

    try {
      state = state.copyWith(status: SMSVerificationStatus.verifying);

      final request = SMSVerificationRequest(
        phoneNumber: state.phoneNumber!,
        verificationCode: verificationCode,
        sessionId: state.sessionId!,
      );

      final verifyAndSignInWithSMSUseCase = ref.read(
        verifyAndSignInWithSMSUseCaseProvider,
      );
      final result = await verifyAndSignInWithSMSUseCase(request);

      // Capturar resultado sem usar `await` dentro do fold
      User? returnedUser;
      result.fold(
        (failure) {
          state = state.copyWith(
            status: SMSVerificationStatus.error,
            errorMessage: _getSMSErrorMessage(failure),
          );
        },
        (user) {
          returnedUser = user;
        },
      );

      if (returnedUser != null) {
        // Tentar ler dados adicionais salvos pelo AuthService e atualizar o AuthController
        try {
          final authService = AuthService();
          final userMap = await authService.getUserData();
          if (userMap != null) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(userMap);

            // Extrair campos essenciais com tolerância a nulos/formatos diferentes
            final id =
                (map['id'] ?? map['sub'] ?? map['user_metadata']?['sub'])
                    ?.toString() ??
                '';
            final nome =
                (map['user_metadata']?['nome_exibicao'] ??
                        map['user_metadata']?['name'] ??
                        map['nome'] ??
                        '')
                    ?.toString() ??
                '';
            final email =
                (map['email'] ?? map['user_metadata']?['email'])?.toString() ??
                '';

            DateTime createdAt;
            try {
              createdAt = DateTime.parse(
                (map['created_at'] ?? map['createdAt'])?.toString() ??
                    DateTime.now().toIso8601String(),
              );
            } catch (_) {
              createdAt = DateTime.now();
            }

            DateTime updatedAt;
            try {
              updatedAt = DateTime.parse(
                (map['updated_at'] ?? map['updatedAt'])?.toString() ??
                    createdAt.toIso8601String(),
              );
            } catch (_) {
              updatedAt = createdAt;
            }

            final avatarUrl =
                (map['user_metadata']?['avatar_url'] ?? map['avatar_url'])
                    ?.toString();

            final userEntity = User(
              id: id.isNotEmpty ? id : returnedUser!.id,
              nome: nome.isNotEmpty ? nome : returnedUser!.nome,
              email: email.isNotEmpty ? email : returnedUser!.email,
              telefone: returnedUser!.telefone,
              avatarUrl: avatarUrl ?? returnedUser!.avatarUrl,
              createdAt: createdAt,
              updatedAt: updatedAt,
              preferences: returnedUser!.preferences,
            );

            // Atualizar AuthController globalmente
            try {
              ref
                  .read(authControllerProvider.notifier)
                  .updateAuthenticatedUser(userEntity);
            } catch (e) {
              debugPrint(
                '[SMS_CONTROLLER] Falha ao atualizar AuthController: $e',
              );
            }
          }
        } catch (e) {
          debugPrint('[SMS_CONTROLLER] Fallback getUserData falhou: $e');
        }

        state = state.copyWith(status: SMSVerificationStatus.verified);
      }
    } catch (e) {
      state = state.copyWith(
        status: SMSVerificationStatus.error,
        errorMessage: 'Erro inesperado ao verificar código: $e',
      );
    }
  }

  // Limpa o estado
  void reset() {
    state = const SMSVerificationState();
  }

  // Limpa erros
  void clearError() {
    state = state.copyWith(
      status:
          state.sessionId != null
              ? SMSVerificationStatus.codeSent
              : SMSVerificationStatus.initial,
      errorMessage: null,
    );
  }

  // Converte falhas específicas de SMS em mensagens legíveis
  String _getSMSErrorMessage(AuthFailure failure) {
    switch (failure.runtimeType) {
      case SMSVerificationFailure _:
        final smsFailure = failure as SMSVerificationFailure;
        return smsFailure.message;
      case InvalidSMSCodeFailure _:
        return 'Código inválido. Verifique e tente novamente.';
      case SMSCodeExpiredFailure _:
        return 'Código expirado. Solicite um novo código.';
      case TooManyAttemptsFailure _:
        return 'Muitas tentativas. Aguarde antes de tentar novamente.';
      case NetworkAuthFailure _:
        return 'Sem conexão com a internet. Verifique sua conexão.';
      default:
        return 'Erro desconhecido. Tente novamente.';
    }
  }
}

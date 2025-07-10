import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/failures.dart';
import '../../data/providers/auth_providers.dart';

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
  @override
  AuthState build() {
    // Verifica se há usuário autenticado ao inicializar
    _checkAuthStatus();
    return const AuthState();
  }

  // Verifica status de autenticação atual
  Future<void> _checkAuthStatus() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final isAuthenticatedUseCase = ref.read(isAuthenticatedUseCaseProvider);
      final isAuthenticated = await isAuthenticatedUseCase();

      if (isAuthenticated) {
        final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
        final user = await getCurrentUserUseCase();

        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro ao verificar autenticação: $e',
      );
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

      result.fold(
        (failure) {
          state = state.copyWith(
            status: SMSVerificationStatus.error,
            errorMessage: _getSMSErrorMessage(failure),
          );
        },
        (user) {
          state = state.copyWith(
            status: SMSVerificationStatus.verified,
          ); // Atualiza o estado de autenticação
          ref
              .read(authControllerProvider.notifier)
              .updateAuthenticatedUser(user);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: SMSVerificationStatus.error,
        errorMessage: 'Erro inesperado durante verificação: $e',
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

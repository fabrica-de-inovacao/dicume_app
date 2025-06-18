import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable {
  const AuthFailure();

  @override
  List<Object?> get props => [];
}

// Falhas de Rede
class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure();
}

// Falhas de Servidor
class ServerAuthFailure extends AuthFailure {
  final int statusCode;
  final String message;

  const ServerAuthFailure(this.statusCode, this.message);

  @override
  List<Object?> get props => [statusCode, message];
}

// Falhas de Credenciais
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();
}

class ExpiredTokenFailure extends AuthFailure {
  const ExpiredTokenFailure();
}

// Falhas específicas do Google
class GoogleSignInFailure extends AuthFailure {
  final String message;

  const GoogleSignInFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GoogleSignInCancelledFailure extends AuthFailure {
  const GoogleSignInCancelledFailure();
}

// Falhas específicas do SMS
class SMSVerificationFailure extends AuthFailure {
  final String message;

  const SMSVerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InvalidSMSCodeFailure extends AuthFailure {
  const InvalidSMSCodeFailure();
}

class SMSCodeExpiredFailure extends AuthFailure {
  const SMSCodeExpiredFailure();
}

class TooManyAttemptsFailure extends AuthFailure {
  final DateTime? retryAfter;

  const TooManyAttemptsFailure(this.retryAfter);

  @override
  List<Object?> get props => [retryAfter];
}

// Falhas de cache/storage
class CacheFailure extends AuthFailure {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Falhas de usuário
class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure();
}

class UserAccountDisabledFailure extends AuthFailure {
  const UserAccountDisabledFailure();
}

// Falha genérica
class UnknownAuthFailure extends AuthFailure {
  final String message;

  const UnknownAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

enum AuthProviderType { google }

class AuthCredential extends Equatable {
  final AuthProviderType provider;
  final String token;
  final Map<String, dynamic>? additionalData;

  const AuthCredential({
    required this.provider,
    required this.token,
    this.additionalData,
  });

  @override
  List<Object?> get props => [provider, token, additionalData];
}

class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get willExpireSoon {
    final now = DateTime.now();
    final fiveMinutesFromNow = now.add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, tokenType];

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }
}

class LoginRequest extends Equatable {
  final AuthProviderType provider;
  final String credential;
  final Map<String, dynamic>? metadata;

  const LoginRequest({
    required this.provider,
    required this.credential,
    this.metadata,
  });

  @override
  List<Object?> get props => [provider, credential, metadata];
}

// SMS flows removed from the domain - not used in this project

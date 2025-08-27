import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthTokenModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'expires_at')
  final String expiresAt;
  @JsonKey(name: 'token_type')
  final String tokenType;

  const AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.parse(expiresAt),
      tokenType: tokenType,
    );
  }

  factory AuthTokenModel.fromEntity(AuthToken token) {
    return AuthTokenModel(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      expiresAt: token.expiresAt.toIso8601String(),
      tokenType: token.tokenType,
    );
  }
}

@JsonSerializable()
class LoginRequestModel {
  final String provider;
  final String credential;
  final Map<String, dynamic>? metadata;

  const LoginRequestModel({
    required this.provider,
    required this.credential,
    this.metadata,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  factory LoginRequestModel.fromEntity(LoginRequest request) {
    return LoginRequestModel(
      provider: request.provider.name,
      credential: request.credential,
      metadata: request.metadata,
    );
  }
}

// SMS models removed - not used

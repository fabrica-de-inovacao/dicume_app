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

@JsonSerializable()
class SMSVerificationRequestModel {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'verification_code')
  final String verificationCode;
  @JsonKey(name: 'session_id')
  final String sessionId;

  const SMSVerificationRequestModel({
    required this.phoneNumber,
    required this.verificationCode,
    required this.sessionId,
  });

  factory SMSVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SMSVerificationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SMSVerificationRequestModelToJson(this);

  factory SMSVerificationRequestModel.fromEntity(
    SMSVerificationRequest request,
  ) {
    return SMSVerificationRequestModel(
      phoneNumber: request.phoneNumber,
      verificationCode: request.verificationCode,
      sessionId: request.sessionId,
    );
  }
}

@JsonSerializable()
class SMSCodeRequestModel {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  const SMSCodeRequestModel({required this.phoneNumber});

  factory SMSCodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SMSCodeRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SMSCodeRequestModelToJson(this);

  factory SMSCodeRequestModel.fromEntity(SMSCodeRequest request) {
    return SMSCodeRequestModel(phoneNumber: request.phoneNumber);
  }
}

@JsonSerializable()
class SMSCodeResponseModel {
  @JsonKey(name: 'session_id')
  final String sessionId;
  final String message;
  @JsonKey(name: 'expires_at')
  final String expiresAt;

  const SMSCodeResponseModel({
    required this.sessionId,
    required this.message,
    required this.expiresAt,
  });

  factory SMSCodeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SMSCodeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SMSCodeResponseModelToJson(this);
}

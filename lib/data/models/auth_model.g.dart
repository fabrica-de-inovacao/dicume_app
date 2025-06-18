// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: json['expires_at'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt,
      'token_type': instance.tokenType,
    };

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) =>
    LoginRequestModel(
      provider: json['provider'] as String,
      credential: json['credential'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LoginRequestModelToJson(LoginRequestModel instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'credential': instance.credential,
      'metadata': instance.metadata,
    };

SMSVerificationRequestModel _$SMSVerificationRequestModelFromJson(
        Map<String, dynamic> json) =>
    SMSVerificationRequestModel(
      phoneNumber: json['phone_number'] as String,
      verificationCode: json['verification_code'] as String,
      sessionId: json['session_id'] as String,
    );

Map<String, dynamic> _$SMSVerificationRequestModelToJson(
        SMSVerificationRequestModel instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'verification_code': instance.verificationCode,
      'session_id': instance.sessionId,
    };

SMSCodeRequestModel _$SMSCodeRequestModelFromJson(Map<String, dynamic> json) =>
    SMSCodeRequestModel(
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$SMSCodeRequestModelToJson(
        SMSCodeRequestModel instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
    };

SMSCodeResponseModel _$SMSCodeResponseModelFromJson(
        Map<String, dynamic> json) =>
    SMSCodeResponseModel(
      sessionId: json['session_id'] as String,
      message: json['message'] as String,
      expiresAt: json['expires_at'] as String,
    );

Map<String, dynamic> _$SMSCodeResponseModelToJson(
        SMSCodeResponseModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'message': instance.message,
      'expires_at': instance.expiresAt,
    };

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();

  Future<void> cacheToken(AuthTokenModel token);
  Future<AuthTokenModel?> getCachedToken();
  Future<void> clearCachedToken();

  Future<void> clearAllCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  // Usar as mesmas chaves que o AuthService para manter consistência
  static const String _userKey = 'dicume_user_data';
  static const String _tokenKey = 'dicume_auth_token';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await secureStorage.write(key: _userKey, value: userJson);
    } catch (e) {
      throw Exception('Erro ao salvar usuário no cache: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      debugPrint('🔍 [LOCAL_DS] getCachedUser: iniciado');
      final userJson = await secureStorage.read(key: _userKey);
      debugPrint('🔍 [LOCAL_DS] userJson encontrado: ${userJson != null}');
      if (userJson != null) {
        debugPrint(
          '🔍 [LOCAL_DS] userJson content: ${userJson.substring(0, 100)}...',
        );
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userMap);
        debugPrint('🔍 [LOCAL_DS] UserModel criado: ${userModel.nome}');
        return userModel;
      }
      debugPrint('🔍 [LOCAL_DS] getCachedUser: retornando null');
      return null;
    } catch (e) {
      debugPrint('🔍 [LOCAL_DS] Erro em getCachedUser: $e');
      // Se houver erro na desserialização, remove o cache corrompido
      await secureStorage.delete(key: _userKey);
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await secureStorage.delete(key: _userKey);
    } catch (e) {
      throw Exception('Erro ao limpar usuário do cache: $e');
    }
  }

  @override
  Future<void> cacheToken(AuthTokenModel token) async {
    try {
      final tokenJson = json.encode(token.toJson());
      await secureStorage.write(key: _tokenKey, value: tokenJson);
    } catch (e) {
      throw Exception('Erro ao salvar token no cache: $e');
    }
  }

  @override
  Future<AuthTokenModel?> getCachedToken() async {
    try {
      final tokenString = await secureStorage.read(key: _tokenKey);
      if (tokenString != null && tokenString.isNotEmpty) {
        // Extrair data de expiração do JWT
        DateTime expiresAt;
        try {
          final decodedToken = JwtDecoder.decode(tokenString);
          debugPrint('🔍 [JWT_DECODE] Token decodificado: $decodedToken');
          final exp = decodedToken['exp'] as int?;
          debugPrint('🔍 [JWT_DECODE] exp field: $exp');
          if (exp != null) {
            expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
            debugPrint('🔍 [JWT_DECODE] expiresAt extraído: $expiresAt');
            debugPrint('🔍 [JWT_DECODE] DateTime.now(): ${DateTime.now()}');
            debugPrint(
              '🔍 [JWT_DECODE] Token expirado? ${DateTime.now().isAfter(expiresAt)}',
            );
          } else {
            // Fallback: 1 hora no futuro
            expiresAt = DateTime.now().add(const Duration(hours: 1));
            debugPrint('🔍 [JWT_DECODE] FALLBACK: expiresAt = $expiresAt');
          }
        } catch (e) {
          // Se falhou ao decodificar, usar 1 hora padrão
          expiresAt = DateTime.now().add(const Duration(hours: 1));
          debugPrint(
            '🔍 [JWT_DECODE] ERRO ao decodificar: $e, usando fallback',
          );
        }

        final tokenModel = AuthTokenModel(
          accessToken: tokenString,
          refreshToken: '', // AuthService não gerencia refresh token
          expiresAt: expiresAt.toIso8601String(),
          tokenType: 'Bearer',
        );

        debugPrint('🔍 [TOKEN_MODEL] AuthTokenModel criado:');
        debugPrint(
          '🔍 [TOKEN_MODEL] - accessToken: ${tokenString.substring(0, 30)}...',
        );
        debugPrint('🔍 [TOKEN_MODEL] - expiresAt: ${tokenModel.expiresAt}');
        debugPrint(
          '🔍 [TOKEN_MODEL] - toEntity().isExpired: ${tokenModel.toEntity().isExpired}',
        );

        return tokenModel;
      }
      return null;
    } catch (e) {
      debugPrint('🔍 [TOKEN_ERROR] Erro ao obter token: $e');
      // Se houver erro, remove o cache corrompido
      await secureStorage.delete(key: _tokenKey);
      return null;
    }
  }

  @override
  Future<void> clearCachedToken() async {
    try {
      await secureStorage.delete(key: _tokenKey);
    } catch (e) {
      throw Exception('Erro ao limpar token do cache: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await Future.wait([clearCachedUser(), clearCachedToken()]);
    } catch (e) {
      throw Exception('Erro ao limpar todo o cache: $e');
    }
  }
}

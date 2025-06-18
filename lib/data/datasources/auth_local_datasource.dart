import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
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

  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'cached_token';

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
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
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
      final tokenJson = await secureStorage.read(key: _tokenKey);
      if (tokenJson != null) {
        final tokenMap = json.decode(tokenJson) as Map<String, dynamic>;
        return AuthTokenModel.fromJson(tokenMap);
      }
      return null;
    } catch (e) {
      // Se houver erro na desserialização, remove o cache corrompido
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

import 'dart:async';
// imports de File e path_provider removidos (não usamos gravação de arquivos aqui)
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final GoogleSignIn googleSignIn;
  final Connectivity connectivity;

  // Stream controller para mudanças no estado de autenticação
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.googleSignIn,
    required this.connectivity,
  });

  @override
  Future<Either<AuthFailure, User>> signInWithGoogle() async {
    try {
      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkAuthFailure());
      }

      // Tenta fazer login com Google
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Obtém o token de autenticação do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // ✅ PATCH 1: NÃO salvar idToken em arquivo aqui (removed file writes)
      final idToken = googleAuth.idToken;
      if (idToken != null) {
        // Apenas logar tamanho e trecho para depuração
        // ignore: avoid_print
        print('🔍 [GOOGLE] idToken tamanho: ${idToken.length} caracteres');
      }

      // ✅ PATCH 2: Exibir idToken em partes no console
      if (idToken != null) {
        print(
          '🔍 [GOOGLE] idToken (primeiros 100 chars): ${idToken.substring(0, 100)}',
        );
        print(
          '🔍 [GOOGLE] idToken (últimos 100 chars): ${idToken.substring(idToken.length - 100)}',
        );
        print(
          '🔍 [GOOGLE] idToken tamanho total: ${idToken.length} caracteres',
        );
      }

      final String? googleToken = googleAuth.idToken;

      if (googleToken == null) {
        return const Left(
          GoogleSignInFailure('Token do Google não disponível'),
        );
      }

      // Salva dados do Google para debug (apenas log, sem gravação em arquivo)
      await _logGoogleResponseForDebug(googleUser, googleAuth);

      // Envia o token para nossa API e recebe token + usuário
      final authResponse = await remoteDataSource.signInWithGoogle(googleToken);
      final user = authResponse.usuario.toEntity();

      // Cache do token e usuário
      final tokenModel = AuthTokenModel(
        accessToken: authResponse.token,
        refreshToken: '', // API não fornece refresh token no Google auth
        expiresAt:
            DateTime.now()
                .add(const Duration(hours: 24))
                .toIso8601String(), // Valor padrão
        tokenType: 'Bearer',
      );

      await localDataSource.cacheToken(tokenModel);
      await localDataSource.cacheUser(authResponse.usuario);

      // Emite mudança no estado de autenticação
      _authStateController.add(user);

      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return const Left(GoogleSignInCancelledFailure());
      }
      return Left(GoogleSignInFailure(e.toString()));
    } catch (e) {
      return Left(GoogleSignInFailure(e.toString()));
    }
  }

  @override
  // SMS flows removed
  // SMS flows removed
  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      // Tenta fazer logout remoto se houver token
      final token = await localDataSource.getCachedToken();
      if (token != null) {
        try {
          final connectivityResult = await connectivity.checkConnectivity();
          if (!connectivityResult.contains(ConnectivityResult.none)) {
            await remoteDataSource.signOut(token.accessToken);
          }
        } catch (e) {
          // Ignora erros de logout remoto - continua com logout local
        }
      }

      // Logout do Google
      await googleSignIn.signOut();

      // Limpa cache local
      await localDataSource.clearAllCache();

      // Emite mudança no estado de autenticação
      _authStateController.add(null);

      return const Right(null);
    } catch (e) {
      return Left(UnknownAuthFailure(e.toString()));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      debugPrint('🔍 [REPO] getCurrentUser: iniciado');
      final userModel = await localDataSource.getCachedUser();
      debugPrint('🔍 [REPO] getCachedUser retornou: ${userModel?.toJson()}');
      final user = userModel?.toEntity();
      debugPrint('🔍 [REPO] getCurrentUser retornará: ${user?.nome}');
      return user;
    } catch (e) {
      debugPrint('🔍 [REPO] Erro em getCurrentUser: $e');
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      debugPrint('🔍 [REPO] isAuthenticated: iniciado');
      final user = await getCurrentUser();
      final token = await getCurrentToken();

      debugPrint('🔍 [REPO] user is null? ${user == null}');
      debugPrint('🔍 [REPO] token is null? ${token == null}');

      if (user == null || token == null) {
        debugPrint('🔍 [REPO] isAuthenticated: false (user ou token null)');
        return false;
      }

      debugPrint('🔍 [REPO] token.isExpired: ${token.isExpired}');
      final result = !token.isExpired;
      debugPrint('🔍 [REPO] isAuthenticated resultado final: $result');

      // Verifica se o token não expirou
      return result;
    } catch (e) {
      debugPrint('🔍 [REPO] Erro em isAuthenticated: $e');
      return false;
    }
  }

  @override
  Future<Either<AuthFailure, AuthToken>> refreshToken() async {
    try {
      final cachedToken = await localDataSource.getCachedToken();
      if (cachedToken == null) {
        return const Left(ExpiredTokenFailure());
      }

      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkAuthFailure());
      }

      final newTokenModel = await remoteDataSource.refreshToken(
        cachedToken.refreshToken,
      );
      final newToken = newTokenModel.toEntity();

      // Cache do novo token
      await localDataSource.cacheToken(newTokenModel);

      return Right(newToken);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(e.toString()));
    }
  }

  @override
  Future<AuthToken?> getCurrentToken() async {
    try {
      final tokenModel = await localDataSource.getCachedToken();
      return tokenModel?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<AuthFailure, User>> updateUser(User user) async {
    try {
      final token = await localDataSource.getCachedToken();
      if (token == null) {
        return const Left(ExpiredTokenFailure());
      }

      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkAuthFailure());
      }

      final userModel = UserModel.fromEntity(user);
      final updatedUserModel = await remoteDataSource.updateUser(
        token.accessToken,
        userModel,
      );
      final updatedUser = updatedUserModel.toEntity();

      // Atualiza cache local
      await localDataSource.cacheUser(updatedUserModel);

      // Emite mudança no estado de autenticação
      _authStateController.add(updatedUser);

      return Right(updatedUser);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  // Método privado para tratar exceções do Dio
  AuthFailure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkAuthFailure();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message =
            e.response?.data?['message'] ?? e.message ?? 'Erro desconhecido';

        switch (statusCode) {
          case 401:
            return const InvalidCredentialsFailure();
          case 403:
            return const UserAccountDisabledFailure();
          case 404:
            return const UserNotFoundFailure();
          case 429:
            final retryAfter = e.response?.headers['retry-after']?.first;
            DateTime? retryAfterDate;
            if (retryAfter != null) {
              final seconds = int.tryParse(retryAfter);
              if (seconds != null) {
                retryAfterDate = DateTime.now().add(Duration(seconds: seconds));
              }
            }
            return TooManyAttemptsFailure(retryAfterDate);
          default:
            return ServerAuthFailure(statusCode, message);
        }

      case DioExceptionType.cancel:
        return const GoogleSignInCancelledFailure();

      case DioExceptionType.unknown:
      default:
        return UnknownAuthFailure(e.message ?? 'Erro desconhecido');
    }
  }

  /// Loga dados da resposta do Google para debug (sem salvar em arquivo)
  Future<void> _logGoogleResponseForDebug(
    GoogleSignInAccount googleUser,
    GoogleSignInAuthentication googleAuth,
  ) async {
    try {
      final googleResponseData = {
        'user': {
          'id': googleUser.id,
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        },
        'authentication': {
          'hasIdToken': googleAuth.idToken != null,
          'tokenUsedForAPI': googleAuth.idToken,
        },
        'timestamp': DateTime.now().toIso8601String(),
        'debugInfo': {
          'idTokenLength': googleAuth.idToken?.length ?? 0,
        },
      };

      // Apenas imprimir versão sanitizada para evitar logs muito grandes
      // ignore: avoid_print
      print('🔍 [GOOGLE_LOG] ========== GOOGLE RESPONSE DEBUG ==========');
      // ignore: avoid_print
      print(googleResponseData);
      // ignore: avoid_print
      print('🔍 [GOOGLE_LOG] ============================================');
    } catch (e) {
      // ignore: avoid_print
      print('❌ [GOOGLE_LOG] Erro ao logar dados do Google: $e');
    }
  }

  // Dispose do stream controller
  void dispose() {
    _authStateController.close();
  }
}

import 'dart:async';
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
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkAuthFailure());
      }

      // Tenta fazer login com Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return const Left(GoogleSignInCancelledFailure());
      }

      // Obtém o token de autenticação do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? googleToken = googleAuth.accessToken;

      if (googleToken == null) {
        return const Left(
          GoogleSignInFailure('Token do Google não disponível'),
        );
      }

      // Envia o token para nossa API
      final userModel = await remoteDataSource.signInWithGoogle(googleToken);
      final user = userModel.toEntity();

      // Cache local
      await localDataSource.cacheUser(userModel);

      // Emite mudança no estado de autenticação
      _authStateController.add(user);

      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      if (e.toString().contains('sign_in_canceled')) {
        return const Left(GoogleSignInCancelledFailure());
      }
      return Left(GoogleSignInFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, String>> requestSMSCode(String phoneNumber) async {
    try {
      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkAuthFailure());
      }

      final response = await remoteDataSource.requestSMSCode(phoneNumber);
      return Right(response.sessionId);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(SMSVerificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> verifyAndSignInWithSMS(
    SMSVerificationRequest request,
  ) async {
    try {
      // Verifica conectividade
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkAuthFailure());
      }

      final requestModel = SMSVerificationRequestModel.fromEntity(request);
      final userModel = await remoteDataSource.verifyAndSignInWithSMS(
        requestModel,
      );
      final user = userModel.toEntity();

      // Cache local
      await localDataSource.cacheUser(userModel);

      // Emite mudança no estado de autenticação
      _authStateController.add(user);

      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(SMSVerificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      // Tenta fazer logout remoto se houver token
      final token = await localDataSource.getCachedToken();
      if (token != null) {
        try {
          final connectivityResult = await connectivity.checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
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
      if (connectivityResult == ConnectivityResult.none) {
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
      if (connectivityResult == ConnectivityResult.none) {
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

  // Dispose do stream controller
  void dispose() {
    _authStateController.close();
  }
}

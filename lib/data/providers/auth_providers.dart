import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/request_sms_code_usecase.dart';
import '../../domain/usecases/verify_and_sign_in_with_sms_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_authenticated_usecase.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../repositories/auth_repository_impl.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';

// ============================================================================
// EXTERNAL DEPENDENCIES
// ============================================================================

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl:
          AppConstants.isDevelopment
              ? AppConstants.apiBaseDevUrl
              : AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        ApiEndpoints.contentTypeHeader: ApiEndpoints.jsonContentType,
        ApiEndpoints.acceptHeader: ApiEndpoints.jsonAccept,
      },
    ),
  );

  // Adiciona interceptor de logs apenas em debug
  if (AppConstants.isDevelopment) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  return dio;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email', 'profile']);
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'dicume_secure_prefs',
      preferencesKeyPrefix: 'dicume_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.dicume.app',
      accountName: 'dicume_account',
    ),
  );
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

// ============================================================================
// DATA SOURCES
// ============================================================================

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(secureStorage: secureStorage);
});

// ============================================================================
// REPOSITORIES
// ============================================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  final connectivity = ref.watch(connectivityProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    googleSignIn: googleSignIn,
    connectivity: connectivity,
  );
});

// ============================================================================
// USE CASES
// ============================================================================

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithGoogleUseCase(repository);
});

final requestSMSCodeUseCaseProvider = Provider<RequestSMSCodeUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RequestSMSCodeUseCase(repository);
});

final verifyAndSignInWithSMSUseCaseProvider =
    Provider<VerifyAndSignInWithSMSUseCase>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return VerifyAndSignInWithSMSUseCase(repository);
    });

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return IsAuthenticatedUseCase(repository);
});

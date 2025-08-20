import 'dart:io';
import 'package:dicume_app/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import 'auth_service.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late final Dio _dio;
  final AuthService _authService = AuthService();

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kDebugMode ? AppConstants.apiBaseDevUrl : AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          ApiEndpoints.contentTypeHeader: ApiEndpoints.jsonContentType,
          ApiEndpoints.acceptHeader: ApiEndpoints.jsonAccept,
        },
      ),
    );

    // Interceptor para adicionar token automaticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getToken();
          if (token != null) {
            options.headers[ApiEndpoints
                .authorizationHeader] = ApiEndpoints.bearerToken(token);
          }

          // Para ngrok em desenvolvimento
          if (kDebugMode) {
            options.headers['ngrok-skip-browser-warning'] = 'true';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // Auto-retry para alguns erros
          if (error.response?.statusCode == 401) {
            // Token expirado, tentar refresh ou logout
            await _authService.logout();
          }
          handler.next(error);
        },
      ),
    );

    // Logger para debug
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          'Tempo limite de conexão. Verifique sua internet.',
          type: AppExceptionType.network,
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['mensagem'] ??
            e.response?.data?['message'] ??
            'Erro no servidor';

        if (statusCode == 401) {
          return AppException(
            'Acesso negado. Faça login novamente.',
            type: AppExceptionType.auth,
          );
        } else if (statusCode == 404) {
          return AppException(
            'Recurso não encontrado.',
            type: AppExceptionType.notFound,
          );
        } else if (statusCode! >= 500) {
          return AppException(
            'Erro interno do servidor. Tente novamente.',
            type: AppExceptionType.server,
          );
        }

        return AppException(message, type: AppExceptionType.api);

      case DioExceptionType.cancel:
        return AppException(
          'Requisição cancelada.',
          type: AppExceptionType.cancel,
        );

      default:
        if (e.error is SocketException) {
          return AppException(
            'Sem conexão com a internet.',
            type: AppExceptionType.network,
          );
        }

        return AppException(
          'Erro inesperado: ${e.message}',
          type: AppExceptionType.unknown,
        );
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await _dio.get(ApiEndpoints.healthCheck);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Classe para exceções customizadas
class AppException implements Exception {
  final String message;
  final AppExceptionType type;
  final int? statusCode;

  AppException(this.message, {required this.type, this.statusCode});

  @override
  String toString() => message;
}

enum AppExceptionType { network, auth, api, server, notFound, cancel, unknown }

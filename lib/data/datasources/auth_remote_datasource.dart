import 'dart:convert';
// Removidos imports de File e path_provider - não gravamos arquivos aqui

import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';
import '../models/auth_response_model.dart';
import '../../core/constants/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signInWithGoogle(String googleToken);
  Future<void> signOut(String token);
  Future<AuthTokenModel> refreshToken(String refreshToken);
  Future<UserModel> updateUser(String token, UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> signInWithGoogle(String googleToken) async {
    try {
      // O endpoint da API, conforme a documentação e os logs, espera um 'token_google'.
      final response = await dio.post(
        ApiEndpoints.loginGoogle,
        data: {'token_google': googleToken},
      );

      if (response.statusCode == 200) {
        // Imprime a resposta completa e formatada no console para depuração (sem salvar em arquivo)
        try {
          final jsonString = const JsonEncoder.withIndent(
            '  ',
          ).convert(response.data);
          // ignore: avoid_print
          print('=' * 50);
          // ignore: avoid_print
          print('✅ [DEBUG] RESPOSTA DA API DICUMÊ (/auth/google)\n$jsonString');
          // ignore: avoid_print
          print('=' * 50);
        } catch (e) {
          // ignore: avoid_print
          print('❌ [DEBUG] Erro ao formatar e imprimir a resposta JSON: $e');
        }

        // Extrair token como string mesmo quando a API retorna objeto
        final data = response.data as Map<String, dynamic>;
        String tokenStr = '';
        if (data['token'] is String) {
          tokenStr = data['token'] as String;
        } else if (data['token'] is Map<String, dynamic>) {
          final tokenObj = data['token'] as Map<String, dynamic>;
          tokenStr =
              (tokenObj['access_token'] ?? tokenObj['token'] ?? '') as String;
        }

        final rawUsuario =
            (data['usuario'] is Map<String, dynamic>)
                ? data['usuario'] as Map<String, dynamic>
                : <String, dynamic>{};

        // Normalizar o objeto 'usuario' para o formato esperado por UserModel
        // O backend fornece muitos campos em user_metadata; mapeamos os campos
        // essenciais e fornecemos valores padrão quando ausentes para evitar
        // casts nulos que lançariam em UserModel.fromJson.
        final userMeta =
            (rawUsuario['user_metadata'] is Map<String, dynamic>)
                ? rawUsuario['user_metadata'] as Map<String, dynamic>
                : <String, dynamic>{};

        final createdAt =
            rawUsuario['created_at'] ?? DateTime.now().toIso8601String();
        final updatedAt = rawUsuario['updated_at'] ?? createdAt;

        final usuarioNormalized = <String, dynamic>{
          'id': rawUsuario['id'] ?? userMeta['sub'] ?? '',
          // nome esperado pelo UserModel
          'nome':
              userMeta['full_name'] ??
              userMeta['name'] ??
              userMeta['nome_exibicao'] ??
              rawUsuario['email'] ??
              '',
          'email': rawUsuario['email'] ?? userMeta['email'] ?? '',
          'telefone': rawUsuario['phone'] ?? '',
          'avatar_url': userMeta['avatar_url'] ?? userMeta['picture'],
          'created_at': createdAt,
          'updated_at': updatedAt,
          // is_first_login e preferences podem não existir no payload; usar defaults
          'is_first_login': rawUsuario['is_first_login'] ?? false,
          'preferences':
              rawUsuario['preferences'] ??
              {
                'notificacoes_ativas': true,
                'hora_lembrete_almoco': 12,
                'hora_lembrete_jantar': 19,
                'lembrar_agua': true,
                'usar_semaforo': true,
                'tamanho_fonte': 14.0,
                'contraste_alto': false,
              },
        };

        return AuthResponseModel(
          token: tokenStr,
          usuario: UserModel.fromJson(usuarioNormalized),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha na autenticação Google',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.loginGoogle),
        message: 'Erro desconhecido: $e',
      );
    }
  }

  @override
  Future<void> signOut(String token) async {
    try {
      await dio.post(
        ApiEndpoints.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.logout),
        message: 'Erro desconhecido: $e',
      );
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokenModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha ao renovar token',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
        message: 'Erro desconhecido: $e',
      );
    }
  }

  @override
  Future<UserModel> updateUser(String token, UserModel user) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.users}/${user.id}',
        data: user.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha ao atualizar usuário',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.users}/${user.id}',
        ),
        message: 'Erro desconhecido: $e',
      );
    }
  }

  // Não salvamos JSON em arquivo aqui; manter tudo via logs para evitar erros de I/O
}

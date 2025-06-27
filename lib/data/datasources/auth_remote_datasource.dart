import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';
import '../models/auth_response_model.dart';
import '../../core/constants/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signInWithGoogle(String googleToken);
  Future<SMSCodeResponseModel> requestSMSCode(String phoneNumber);
  Future<UserModel> verifyAndSignInWithSMS(SMSVerificationRequestModel request);
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
      // Enviar apenas o idToken diretamente para a API DICUMÊ
      final response = await dio.post(
        ApiEndpoints.loginGoogle,
        data: googleToken, // Apenas o idToken, não um objeto
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
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
  Future<SMSCodeResponseModel> requestSMSCode(String phoneNumber) async {
    try {
      final response = await dio.post(
        ApiEndpoints.requestSMSCode,
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode == 200) {
        return SMSCodeResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha ao solicitar código SMS',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.requestSMSCode),
        message: 'Erro desconhecido: $e',
      );
    }
  }

  @override
  Future<UserModel> verifyAndSignInWithSMS(
    SMSVerificationRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.verifySMSCode,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Código SMS inválido',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.verifySMSCode),
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
}

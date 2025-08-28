import 'package:dio/dio.dart';
import '../models/refeicao_pendente_model.dart';
import '../../core/constants/api_endpoints.dart';

abstract class RefeicaoRemoteDataSource {
  Future<Map<String, dynamic>> enviarRefeicao(
    String token,
    RefeicaoApiRequestModel refeicao,
  );
}

class RefeicaoRemoteDataSourceImpl implements RefeicaoRemoteDataSource {
  final Dio dio;

  RefeicaoRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> enviarRefeicao(
    String token,
    RefeicaoApiRequestModel refeicao,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.diarioRefeicoes,
        data: refeicao.toJson(),
        options: Options(
          headers: {
            ApiEndpoints.authorizationHeader: ApiEndpoints.bearerToken(token),
            ApiEndpoints.contentTypeHeader: ApiEndpoints.jsonContentType,
            ApiEndpoints.acceptHeader: ApiEndpoints.jsonAccept,
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha ao enviar refeição para API',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.diarioRefeicoes),
        message: 'Erro desconhecido ao enviar refeição: $e',
      );
    }
  }
}

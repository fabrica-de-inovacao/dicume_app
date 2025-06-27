import 'package:dio/dio.dart';
import '../models/alimento_model.dart';
import '../../core/constants/api_endpoints.dart';

abstract class AlimentoRemoteDataSource {
  Future<List<AlimentoModel>> getAllAlimentos();
}

class AlimentoRemoteDataSourceImpl implements AlimentoRemoteDataSource {
  final Dio dio;

  AlimentoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AlimentoModel>> getAllAlimentos() async {
    try {
      final response = await dio.get(
        ApiEndpoints.dadosAlimentos,
        options: Options(
          headers: {
            ApiEndpoints.contentTypeHeader: ApiEndpoints.jsonContentType,
            ApiEndpoints.acceptHeader: ApiEndpoints.jsonAccept,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => AlimentoModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Falha ao obter alimentos da API',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.dadosAlimentos),
        message: 'Erro desconhecido ao obter alimentos: $e',
      );
    }
  }
}

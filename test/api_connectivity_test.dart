import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

/// Teste simples para verificar se a API está acessível
void main() {
  group('API Connectivity Tests', () {
    test('should fetch alimentos from API', () async {
      final dio = Dio();

      try {
        final response = await dio.get(
          'http://189.90.44.226:5050/api/v1/dados/alimentos',
        );

        expect(response.statusCode, 200);
        expect(response.data, isA<List>());

        if (response.data is List && (response.data as List).isNotEmpty) {
          final firstAlimento = (response.data as List).first;
          expect(firstAlimento, isA<Map>());
          expect(firstAlimento['id'], isNotNull);
          expect(firstAlimento['nome_popular'], isNotNull);
          expect(firstAlimento['grupo_dicume'], isNotNull);

          print('✅ API retornou ${(response.data as List).length} alimentos');
          print('✅ Primeiro alimento: ${firstAlimento['nome_popular']}');
          print('✅ Grupo: ${firstAlimento['grupo_dicume']}');
        }
      } catch (e) {
        fail('Erro ao acessar API: $e');
      }
    });

    test('should validate alimento structure', () async {
      final dio = Dio();

      try {
        final response = await dio.get(
          'http://189.90.44.226:5050/api/v1/dados/alimentos',
        );

        if (response.data is List && (response.data as List).isNotEmpty) {
          final alimento = (response.data as List).first;

          // Verifica se tem os campos necessários para o offline-first
          expect(alimento['id'], isA<String>());
          expect(alimento['nome_popular'], isA<String>());
          expect(alimento['grupo_dicume'], isA<String>());
          expect(alimento['classificacao_cor'], isA<String>());

          print('✅ Estrutura do alimento válida para offline-first');
          print('✅ ID: ${alimento['id']} (String UUID)');
          print('✅ Nome: ${alimento['nome_popular']}');
          print('✅ Cor: ${alimento['classificacao_cor']}');
        }
      } catch (e) {
        fail('Erro ao validar estrutura: $e');
      }
    });
  });
}

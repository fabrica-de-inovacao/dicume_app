import 'package:flutter/foundation.dart';
// import 'dart:io' removido - não salvamos arquivos de resposta mais
import 'dart:convert';
import '../constants/api_endpoints.dart';
import 'http_service.dart';
import 'auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/perfil_status_model.dart';
import '../../data/models/refeicao_do_dia_model.dart'; // Importar o novo modelo

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  ApiService(); // Construtor público para Riverpod

  // Removido o singleton _instance e factory para permitir injeção via Riverpod
  // static final ApiService _instance = ApiService._internal();
  // factory ApiService() => _instance;
  // ApiService._internal();

  final HttpService _http = HttpService();
  final AuthService _auth = AuthService();

  // Método auxiliar para salvar dados de debug
  Future<void> _saveDebugData(
    Map<String, dynamic> responseData,
    String token,
  ) async {
    try {
      // Preparar dados para salvar com tratamento de nulos
      final debugData = {
        'timestamp': DateTime.now().toIso8601String(),
        'api_response_completa': _sanitizeMap(responseData),
        'token_extraido': token.isNotEmpty ? token : '',
        'token_length': token.length,
        'token_preview':
            token.length > 50 ? '${token.substring(0, 50)}...' : token,
      };

      // Apenas fazer log dos dados (não salvar arquivo por enquanto devido ao read-only)
      debugPrint('📁 [DEBUG] ========== DADOS DE DEBUG ==========');
      debugPrint(
        '📁 [DEBUG] Response completa: ${debugData['api_response_completa']}',
      );
      debugPrint('📁 [DEBUG] Token extraído: ${debugData['token_preview']}');
      debugPrint('📁 [DEBUG] Token length: ${debugData['token_length']}');
      debugPrint('📁 [DEBUG] ==========================================');
    } catch (e) {
      debugPrint('❌ [DEBUG] Erro ao processar dados de debug: $e');
    }
  }

  // Método auxiliar para sanitizar Map<String, dynamic> tratando nulos
  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
    final sanitized = <String, dynamic>{};

    map.forEach((key, value) {
      if (value == null) {
        sanitized[key] = '';
      } else if (value is Map<String, dynamic>) {
        sanitized[key] = _sanitizeMap(value);
      } else if (value is List) {
        sanitized[key] = _sanitizeList(value);
      } else {
        sanitized[key] = value;
      }
    });

    return sanitized;
  }

  // Método auxiliar para sanitizar listas
  List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item == null) {
        return '';
      } else if (item is Map<String, dynamic>) {
        return _sanitizeMap(item);
      } else if (item is List) {
        return _sanitizeList(item);
      } else {
        return item;
      }
    }).toList();
  }

  // Método para logar response completa da API (status 200) sem salvar em arquivo
  Future<void> _saveApiResponse(Map<String, dynamic> responseData) async {
    try {
      final completeData = {
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'SUCCESS',
        'response_keys': responseData.keys.toList(),
        'response_size': responseData.toString().length,
      };

      debugPrint(
        '📁 [API_RESPONSE] Response completa (não salva): ${const JsonEncoder.withIndent('  ').convert(completeData)}',
      );
    } catch (e) {
      debugPrint('❌ [API_RESPONSE] Erro ao processar response para debug: $e');
    }
  }

  // Health Check da API
  Future<ApiResult<Map<String, dynamic>>> healthCheck() async {
    try {
      final response = await _http.get(ApiEndpoints.healthCheck);
      return ApiResult.success(response.data);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro inesperado: $e');
    }
  }

  // Autenticação com Google
  Future<ApiResult<AuthResponse>> authenticateWithGoogle(
    String googleToken,
  ) async {
    try {
      debugPrint('🌐 [API] Iniciando autenticação com Google na API...');
      debugPrint(
        '🌐 [API] Token Google (primeiros 30 chars): ${googleToken.substring(0, 30)}...',
      );
      debugPrint('🌐 [API] Endpoint: ${ApiEndpoints.loginGoogle}');

      final response = await _http.post(
        ApiEndpoints.loginGoogle,
        data: {'token_google': googleToken},
      );

      debugPrint('🌐 [API] ✅ Resposta recebida da API');
      debugPrint('🌐 [API] Status Code: ${response.statusCode}');
      debugPrint('🌐 [API] Response data: ${response.data}');

      // 📁 SALVAR RESPONSE COMPLETA DA API (STATUS 200)
      await _saveApiResponse(response.data);

      final authResponse = AuthResponse.fromJson(response.data);
      debugPrint('🌐 [API] ✅ AuthResponse criado com sucesso');
      debugPrint(
        '🌐 [API] Token recebido (primeiros 30 chars): ${authResponse.token.length > 30 ? "${authResponse.token.substring(0, 30)}..." : authResponse.token}',
      );

      // 📁 SALVAR DADOS DE DEBUG
      await _saveDebugData(response.data, authResponse.token);

      // Salvar token e dados do usuário
      debugPrint('🌐 [API] Salvando token e dados do usuário...');
      await _auth.saveToken(authResponse.token);
      await _auth.saveUserData(authResponse.usuario);
      debugPrint('🌐 [API] ✅ Token e dados salvos com sucesso');

      return ApiResult.success(authResponse);
    } on AppException catch (e) {
      debugPrint('🌐 [API] ❌ AppException: ${e.message} (${e.type})');
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      debugPrint('🌐 [API] ❌ ERRO na autenticação: $e');
      debugPrint('🌐 [API] ❌ Stack trace: ${StackTrace.current}');
      return ApiResult.error('Erro na autenticação: $e');
    }
  }

  // Registrar usuário via email/senha (signup)
  Future<ApiResult<Map<String, dynamic>>> signupWithEmail(
    String email,
    String senha,
    String nomeExibicao,
  ) async {
    try {
      debugPrint('[API] Iniciando signup via email: $email');
      final response = await _http.post(
        ApiEndpoints.signup,
        data: {'email': email, 'senha': senha, 'nome_exibicao': nomeExibicao},
      );

      debugPrint('[API] Signup response: ${response.data}');
      await _saveApiResponse(response.data);

      return ApiResult.success(
        _sanitizeMap(Map<String, dynamic>.from(response.data)),
      );
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro no signup: $e');
    }
  }

  // Login via email/senha (signin)
  Future<ApiResult<AuthResponse>> signinWithEmail(
    String email,
    String senha,
  ) async {
    try {
      debugPrint('[API] Iniciando signin via email: $email');
      final response = await _http.post(
        ApiEndpoints.signin,
        data: {'email': email, 'senha': senha},
      );

      debugPrint('[API] ✅ Resposta signin recebida');
      debugPrint('🌐 [API] Status Code: ${response.statusCode}');
      debugPrint('🌐 [API] Response data: ${response.data}');

      await _saveApiResponse(response.data);

      final authResponse = AuthResponse.fromJson(response.data);

      // Salvar token e dados do usuário
      await _auth.saveToken(authResponse.token);
      await _auth.saveUserData(authResponse.usuario);

      return ApiResult.success(authResponse);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro no signin: $e');
    }
  }

  // Obter perfil do usuário
  Future<ApiResult<UserProfile>> getUserProfile() async {
    try {
      final response = await _http.get(ApiEndpoints.perfil);
      final profile = UserProfile.fromJson(response.data);
      return ApiResult.success(profile);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao obter perfil: $e');
    }
  }

  // Atualizar perfil do usuário
  Future<ApiResult<Map<String, dynamic>>> updateUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _http.put(ApiEndpoints.perfil, data: profileData);
      return ApiResult.success(response.data);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao atualizar perfil: $e');
    }
  }

  // Buscar CEP via ViaCEP (API pública)
  Future<ApiResult<Map<String, dynamic>>> buscarCep(String cep) async {
    try {
      final response = await _http.get('https://viacep.com.br/ws/$cep/json/');
      final data = Map<String, dynamic>.from(response.data);
      if (data.containsKey('erro') && (data['erro'] == true)) {
        return ApiResult.error('CEP não encontrado', AppExceptionType.notFound);
      }
      return ApiResult.success(data);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao buscar CEP: $e');
    }
  }

  // Obter lista de alimentos
  Future<ApiResult<List<ApiAlimento>>> getAlimentos() async {
    try {
      final response = await _http.get(ApiEndpoints.dadosAlimentos);

      final List<dynamic> data = response.data;
      final alimentos = data.map((json) => ApiAlimento.fromJson(json)).toList();

      return ApiResult.success(alimentos);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao obter alimentos: $e');
    }
  }

  // Registrar refeição
  Future<ApiResult<RefeicaoResponse>> registrarRefeicao({
    required String tipoRefeicao,
    required String dataRefeicao,
    required List<RefeicaoItem> itens,
  }) async {
    try {
      debugPrint('🍽️ [REFEICAO] Iniciando registro de refeição...');
      debugPrint('🍽️ [REFEICAO] Tipo: $tipoRefeicao');
      debugPrint('🍽️ [REFEICAO] Data: $dataRefeicao');
      debugPrint('🍽️ [REFEICAO] Itens: ${itens.length}');

      final data = {
        'tipo_refeicao': tipoRefeicao,
        'data_refeicao': dataRefeicao,
        'itens': itens.map((item) => item.toJson()).toList(),
      };

      debugPrint('🍽️ [REFEICAO] Payload: $data');
      debugPrint('🍽️ [REFEICAO] Endpoint: ${ApiEndpoints.diarioRefeicoes}');

      final response = await _http.post(
        ApiEndpoints.diarioRefeicoes,
        data: data,
      );

      debugPrint('🍽️ [REFEICAO] ✅ Resposta recebida');
      debugPrint('🍽️ [REFEICAO] Status: ${response.statusCode}');
      debugPrint('🍽️ [REFEICAO] Response: ${response.data}');

      final refeicaoResponse = RefeicaoResponse.fromJson(response.data);
      return ApiResult.success(refeicaoResponse);
    } on AppException catch (e) {
      debugPrint('🍽️ [REFEICAO] ❌ AppException: ${e.message} (${e.type})');
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      debugPrint('🍽️ [REFEICAO] ❌ ERRO: $e');
      debugPrint('🍽️ [REFEICAO] ❌ Stack trace: ${StackTrace.current}');
      return ApiResult.error('Erro ao registrar refeição: $e');
    }
  }

  // Obter refeições por data
  Future<ApiResult<List<HistoricoRefeicao>>> getRefeicoesByData(
    String data,
  ) async {
    try {
      final response = await _http.get(
        ApiEndpoints.diarioRefeicoesByData(data),
      );

      final List<dynamic> dataList = response.data;
      final refeicoes =
          dataList.map((json) => HistoricoRefeicao.fromJson(json)).toList();

      return ApiResult.success(refeicoes);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao obter histórico: $e');
    }
  }

  // Novo método para obter refeições do dia
  Future<List<RefeicaoDoDiaModel>> getRefeicoesDoDia(String data) async {
    try {
      debugPrint('🍽️ [REFEICAO] Buscando refeições para a data: $data');
      final response = await _http.get(
        ApiEndpoints.diarioRefeicoesByData(data),
      );

      debugPrint('🍽️ [REFEICAO] ✅ Resposta recebida para data: $data');
      debugPrint('🍽️ [REFEICAO] Status: ${response.statusCode}');
      debugPrint('🍽️ [REFEICAO] Response: ${response.data}');

      final List<dynamic> dataList = response.data;
      final refeicoes =
          dataList.map((json) => RefeicaoDoDiaModel.fromJson(json)).toList();

      return refeicoes;
    } on AppException catch (e) {
      // 404 significa "nenhuma refeição cadastrada" — é um estado vazio, não erro
      if (e.type == AppExceptionType.notFound) {
        debugPrint(
          '🍽️ [REFEICAO] Nenhuma refeição encontrada para $data (válido)',
        );
        return [];
      }
      debugPrint(
        '🍽️ [REFEICAO] ❌ AppException ao buscar refeições: ${e.message} (${e.type})',
      );
      throw Exception('Erro na API: ${e.message}');
    } catch (e) {
      debugPrint('🍽️ [REFEICAO] ❌ ERRO inesperado ao buscar refeições: $e');
      debugPrint('🍽️ [REFEICAO] ❌ Stack trace: ${StackTrace.current}');
      throw Exception('Erro inesperado ao buscar refeições: $e');
    }
  }

  // Obter status do perfil
  Future<ApiResult<PerfilStatusModel>> getPerfilStatus() async {
    try {
      final response = await _http.get(ApiEndpoints.perfilStatus);
      final perfilStatus = PerfilStatusModel.fromJson(response.data);
      return ApiResult.success(perfilStatus);
    } on AppException catch (e) {
      return ApiResult.error(e.message, e.type);
    } catch (e) {
      return ApiResult.error('Erro ao obter status do perfil: $e');
    }
  }
}

// Classes de modelo para API

class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final AppExceptionType? errorType;

  ApiResult.success(this.data) : success = true, error = null, errorType = null;

  ApiResult.error(this.error, [this.errorType]) : success = false, data = null;
}

class AuthResponse {
  final String token;
  final Map<String, dynamic> usuario;

  AuthResponse({required this.token, required this.usuario});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // 🔍 LOG DETALHADO PARA DEBUG
    debugPrint('📋 [AUTH_RESPONSE] ========== PARSING JSON ==========');
    debugPrint('📋 [AUTH_RESPONSE] json completo: $json');
    debugPrint('📋 [AUTH_RESPONSE] json["token"]: ${json['token']}');
    debugPrint(
      '📋 [AUTH_RESPONSE] tipo json["token"]: ${json['token'].runtimeType}',
    );
    debugPrint('📋 [AUTH_RESPONSE] json["usuario"]: ${json['usuario']}');
    debugPrint('📋 [AUTH_RESPONSE] ==========================================');

    // Extrair token - pode ser string direta ou objeto com access_token
    String tokenStr;
    if (json['token'] is String) {
      tokenStr = json['token'];
      debugPrint('📋 [AUTH_RESPONSE] ✅ Token é string direta');
    } else if (json['token'] is Map<String, dynamic>) {
      final tokenObj = json['token'] as Map<String, dynamic>;
      tokenStr = tokenObj['access_token'] ?? tokenObj['token'] ?? '';
      debugPrint('📋 [AUTH_RESPONSE] ✅ Token extraído do objeto: access_token');
    } else {
      tokenStr = '';
      debugPrint(
        '📋 [AUTH_RESPONSE] ❌ Token não encontrado ou formato inválido',
      );
    }

    debugPrint(
      '📋 [AUTH_RESPONSE] tokenStr final: ${tokenStr.length > 30 ? "${tokenStr.substring(0, 30)}..." : tokenStr}',
    );

    return AuthResponse(token: tokenStr, usuario: json['usuario'] ?? {});
  }
}

class UserProfile {
  final String? nomeExibicao;
  final String? dataNascimento;
  final String? genero;
  final String? escolaridade;
  final String? tempoDiagnosticoDm2;
  final bool? fazAcompanhamentoMedico;
  final String? cidade;
  final String? bairro;
  final String? telefone;

  UserProfile({
    this.nomeExibicao,
    this.dataNascimento,
    this.genero,
    this.escolaridade,
    this.tempoDiagnosticoDm2,
    this.fazAcompanhamentoMedico,
    this.cidade,
    this.bairro,
    this.telefone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nomeExibicao: json['nome_exibicao'],
      dataNascimento: json['data_nascimento'],
      genero: json['genero'],
      escolaridade: json['escolaridade'],
      tempoDiagnosticoDm2: json['tempo_diagnostico_dm2'],
      fazAcompanhamentoMedico: json['faz_acompanhamento_medico'],
      cidade: json['cidade'],
      bairro: json['bairro'],
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_exibicao': nomeExibicao,
      'data_nascimento': dataNascimento,
      'genero': genero,
      'escolaridade': escolaridade,
      'tempo_diagnostico_dm2': tempoDiagnosticoDm2,
      'faz_acompanhamento_medico': fazAcompanhamentoMedico,
      'cidade': cidade,
      'bairro': bairro,
      'telefone': telefone,
    }..removeWhere((key, value) => value == null);
  }
}

class ApiAlimento {
  final int id;
  final String nomePopular;
  final String grupoDicume;
  final String classificacaoCor;
  final String recomendacaoConsumo;
  final String? fotoPorcaoUrl;
  final String? grupoNutricional;
  final String? igClassificacao;
  final String? guiaAlimentarClass;

  ApiAlimento({
    required this.id,
    required this.nomePopular,
    required this.grupoDicume,
    required this.classificacaoCor,
    required this.recomendacaoConsumo,
    this.fotoPorcaoUrl,
    this.grupoNutricional,
    this.igClassificacao,
    this.guiaAlimentarClass,
  });

  factory ApiAlimento.fromJson(Map<String, dynamic> json) {
    // Tratar conversões de tipo para evitar erros
    int idParsed = 0;
    if (json['id'] is int) {
      idParsed = json['id'];
    } else if (json['id'] is String) {
      idParsed = int.tryParse(json['id']) ?? 0;
    }

    return ApiAlimento(
      id: idParsed,
      nomePopular: json['nome_popular']?.toString() ?? '',
      grupoDicume: json['grupo_dicume']?.toString() ?? '',
      classificacaoCor: json['classificacao_cor']?.toString() ?? '',
      recomendacaoConsumo: json['recomendacao_consumo']?.toString() ?? '',
      fotoPorcaoUrl: json['foto_porcao_url']?.toString(),
      grupoNutricional: json['grupo_nutricional']?.toString(),
      igClassificacao: json['ig_classificacao']?.toString(),
      guiaAlimentarClass: json['guia_alimentar_class']?.toString(),
    );
  }
}

class RefeicaoItem {
  // Usamos String aqui para suportar UUIDs (ex.: "462e295f-...")
  final String alimentoId;
  final double quantidadeBase;

  RefeicaoItem({required this.alimentoId, required this.quantidadeBase});

  Map<String, dynamic> toJson() {
    // Garantir que o id venha como string para a API
    return {
      'alimento_id': alimentoId.toString(),
      'quantidade_base': quantidadeBase,
    };
  }
}

class RefeicaoResponse {
  final int refeicaoId;
  final String classificacaoFinal;
  final String mensagem;

  RefeicaoResponse({
    required this.refeicaoId,
    required this.classificacaoFinal,
    required this.mensagem,
  });

  factory RefeicaoResponse.fromJson(Map<String, dynamic> json) {
    // Tratar conversões de tipo para evitar erros
    int refeicaoIdParsed = 0;
    if (json['refeicao_id'] is int) {
      refeicaoIdParsed = json['refeicao_id'];
    } else if (json['refeicao_id'] is String) {
      refeicaoIdParsed = int.tryParse(json['refeicao_id']) ?? 0;
    }

    return RefeicaoResponse(
      refeicaoId: refeicaoIdParsed,
      classificacaoFinal: json['classificacao_final']?.toString() ?? '',
      mensagem: json['mensagem']?.toString() ?? '',
    );
  }
}

class HistoricoRefeicao {
  final int id;
  final String tipoRefeicao;
  final String classificacaoFinal;
  final List<HistoricoItem> itens;

  HistoricoRefeicao({
    required this.id,
    required this.tipoRefeicao,
    required this.classificacaoFinal,
    required this.itens,
  });

  factory HistoricoRefeicao.fromJson(Map<String, dynamic> json) {
    // Tratar conversões de tipo para evitar erros
    int idParsed = 0;
    if (json['id'] is int) {
      idParsed = json['id'];
    } else if (json['id'] is String) {
      idParsed = int.tryParse(json['id']) ?? 0;
    }

    return HistoricoRefeicao(
      id: idParsed,
      tipoRefeicao: json['tipo_refeicao']?.toString() ?? '',
      classificacaoFinal: json['classificacao_final']?.toString() ?? '',
      itens:
          (json['itens'] as List? ?? [])
              .map((item) => HistoricoItem.fromJson(item))
              .toList(),
    );
  }
}

class HistoricoItem {
  final String nomePopular;
  final String quantidadeDesc;
  final String? fotoPorcaoUrl;

  HistoricoItem({
    required this.nomePopular,
    required this.quantidadeDesc,
    this.fotoPorcaoUrl,
  });

  factory HistoricoItem.fromJson(Map<String, dynamic> json) {
    return HistoricoItem(
      nomePopular: json['nome_popular'],
      quantidadeDesc: json['quantidade_desc'],
      fotoPorcaoUrl: json['foto_porcao_url'],
    );
  }
}

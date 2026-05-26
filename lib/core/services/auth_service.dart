import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// Removidos imports de File e path_provider - não gravamos arquivos aqui

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Secure Storage para tokens (mesma config do auth_providers.dart)
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      storageNamespace: 'dicume_secure_prefs',
      preferencesKeyPrefix: 'dicume_',
    ),
    iOptions: IOSOptions(
      synchronizable: false,
      groupId: 'group.br.app.dicume',
      accountName: 'dicume_account',
    ),
  );

  bool _isInitialized = false;

  // Keys para storage
  static const String _tokenKey = 'dicume_auth_token';
  static const String _userKey = 'dicume_user_data';
  static const String _isFirstLaunchKey = 'dicume_first_launch';

  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('🔑 [AUTH] AuthService já foi inicializado, pulando...');
      return;
    }

    await GoogleSignIn.instance.initialize(
      serverClientId:
          '1096626549217-05u9n9naj1lt584b703eet41vffn96bv.apps.googleusercontent.com',
    );

    _isInitialized = true;
    debugPrint('🔑 [AUTH] AuthService inicializado com sucesso');
  }

  // Verificar se é o primeiro lançamento do app
  Future<bool> isFirstLaunch() async {
    try {
      final value = await _storage.read(key: _isFirstLaunchKey);
      final isFirst = value == null;
      debugPrint('🔑 [AUTH] isFirstLaunch: valor=$value, resultado=$isFirst');
      return isFirst;
    } catch (e) {
      debugPrint('🔑 [AUTH] Erro ao verificar first launch: $e');
      return true;
    }
  }

  // Marcar que o app já foi lançado
  Future<void> markFirstLaunchComplete() async {
    try {
      await _storage.write(key: _isFirstLaunchKey, value: 'false');
      debugPrint('🔑 [AUTH] markFirstLaunchComplete: marcado como false');
    } catch (e) {
      debugPrint('🔑 [AUTH] Erro ao marcar first launch: $e');
    }
  }

  // Verificar se usuário está logado
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      // Verificar se token não expirou
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      debugPrint('Erro ao verificar login: $e');
      return false;
    }
  }

  // Obter token salvo
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('Erro ao obter token: $e');
      return null;
    }
  }

  // Salvar token
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('Erro ao salvar token: $e');
    }
  }

  // Obter dados do usuário salvos
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = await _storage.read(key: _userKey);

      if (userData != null) {
        debugPrint('🔐 [AUTH] Dados do usuário DiCumê: $userData');
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  // Salvar dados do usuário
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _storage.write(key: _userKey, value: jsonEncode(userData));
    } catch (e) {
      debugPrint('Erro ao salvar dados do usuário: $e');
    }
  }

  // Login com Google
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      debugPrint('🔐 [AUTH] Iniciando login com Google...');

      // Fazer logout primeiro para forçar seleção de conta
      debugPrint('🔐 [AUTH] Fazendo logout do Google Sign-In...');
      await GoogleSignIn.instance.signOut();
      debugPrint('🔐 [AUTH] Logout do Google Sign-In concluído');

      debugPrint('🔐 [AUTH] Chamando GoogleSignIn.instance.authenticate()...');
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      debugPrint('🔐 [AUTH] ✅ GoogleUser obtido: ${googleUser.email}');

      // 🔍 LOG COMPLETO DOS DADOS DO GOOGLE USER
      debugPrint('📋 [GOOGLE_USER] ========== DADOS COMPLETOS ==========');
      debugPrint('📋 [GOOGLE_USER] displayName: ${googleUser.displayName}');
      debugPrint('📋 [GOOGLE_USER] email: ${googleUser.email}');
      debugPrint('📋 [GOOGLE_USER] id: ${googleUser.id}');
      debugPrint('📋 [GOOGLE_USER] photoUrl: ${googleUser.photoUrl}');
      debugPrint('📋 [GOOGLE_USER] toString(): ${googleUser.toString()}');
      debugPrint('📋 [GOOGLE_USER] ========================================');

      debugPrint('🔐 [AUTH] Obtendo authentication do GoogleUser...');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // ✅ PATCH 1: NÃO salvar idToken em arquivo aqui (remoção de I/O)
      final idToken = googleAuth.idToken;
      if (idToken != null) {
        debugPrint(
          '🔍 [AUTH_SERVICE] idToken tamanho: ${idToken.length} caracteres',
        );
      }

      // ✅ PATCH 2: Exibir idToken em partes no console
      if (idToken != null) {
        debugPrint(
          '🔍 [AUTH_SERVICE] idToken (primeiros 571 chars): ${idToken.substring(0, 571)}',
        );
        debugPrint(
          '🔍 [AUTH_SERVICE] idToken (últimos 571 chars): ${idToken.substring(idToken.length - 571)}',
        );
        debugPrint(
          '🔍 [AUTH_SERVICE] idToken tamanho total: ${idToken.length} caracteres',
        );
      }

      // 🔍 LOG COMPLETO DOS DADOS DE AUTENTICAÇÃO
      debugPrint(
        '📋 [GOOGLE_AUTH] ========== DADOS DE AUTENTICAÇÃO ==========',
      );
      debugPrint('📋 [GOOGLE_AUTH] idToken: ${googleAuth.idToken}');
      debugPrint(
        '📋 [GOOGLE_AUTH] idToken length: ${googleAuth.idToken?.length ?? 0}',
      );
      debugPrint('📋 [GOOGLE_AUTH] toString(): ${googleAuth.toString()}');
      debugPrint(
        '📋 [GOOGLE_AUTH] =============================================',
      );

      debugPrint('🔐 [AUTH] GoogleAuth obtido');
      debugPrint('🔐 [AUTH] idToken exists: ${googleAuth.idToken != null}');

      if (googleAuth.idToken != null) {
        // Salva idToken completo no diretório de documentos do app para depuração
        try {
          // Apenas logar informação de debug (não gravar em arquivo)
          debugPrint(
            '� [AUTH_SERVICE] idToken tamanho: ${googleAuth.idToken!.length}',
          );
        } catch (e) {
          debugPrint(
            '❌ [AUTH_SERVICE] Erro ao processar idToken para debug: $e',
          );
        }

        // Decodificar token apenas para logs (mantendo a lógica anterior)
        try {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(
            googleAuth.idToken!,
          );
          debugPrint(
            '📋 [JWT_DECODED] ========== TOKEN DECODIFICADO ==========',
          );
          decodedToken.forEach((key, value) {
            debugPrint('📋 [JWT_DECODED] $key: $value');
          });
          debugPrint(
            '📋 [JWT_DECODED] ==========================================',
          );
        } catch (e) {
          debugPrint('❌ [JWT_DECODED] Erro ao decodificar token: $e');
        }
      }

      if (googleAuth.idToken == null) {
        debugPrint('❌ [TOKEN] Nenhum token disponível!');
        return GoogleSignInResult(
          success: false,
          message: 'Erro ao obter tokens do Google',
        );
      }

      debugPrint('🔐 [AUTH] ✅ Login com Google bem-sucedido!');

      Map<String, dynamic> completeUserInfo = {
        'id': googleUser.id,
        'name': googleUser.displayName ?? '',
        'email': googleUser.email,
        'photoUrl': googleUser.photoUrl,
      };

      debugPrint('📋 [API_DATA] ========== DADOS PARA API ==========');
      debugPrint('📋 [API_DATA] completeUserInfo: $completeUserInfo');
      debugPrint('📋 [API_DATA] tokenForApi length: ${googleAuth.idToken!.length}');
      debugPrint('📋 [API_DATA] =======================================');

      return GoogleSignInResult(
        success: true,
        googleToken: googleAuth.idToken!,
        userInfo: completeUserInfo,
      );
    } catch (e) {
      debugPrint('🔐 [AUTH] ❌ ERRO no Google Sign-In: $e');
      debugPrint('🔐 [AUTH] ❌ Stack trace: ${StackTrace.current}');
      return GoogleSignInResult(
        success: false,
        message: 'Erro no login com Google: $e',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Limpar storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);

      // Logout do Google
      await GoogleSignIn.instance.signOut();

      debugPrint('Logout realizado com sucesso');
    } catch (e) {
      debugPrint('Erro no logout: $e');
    }
  }

  // Limpar todos os dados (reset completo)
  Future<void> clearAllData() async {
    try {
      await _storage.deleteAll();
      await GoogleSignIn.instance.signOut();
      debugPrint('Todos os dados limpos');
    } catch (e) {
      debugPrint('Erro ao limpar dados: $e');
    }
  }

  // Método de debug para limpar marcação de primeiro acesso
  Future<void> clearFirstLaunchFlag() async {
    try {
      await _storage.delete(key: _isFirstLaunchKey);
      debugPrint('🔑 [AUTH] clearFirstLaunchFlag: flag removida');
    } catch (e) {
      debugPrint('🔑 [AUTH] Erro ao limpar first launch: $e');
    }
  }
}

// Classe para resultado do Google Sign-In
class GoogleSignInResult {
  final bool success;
  final String? googleToken;
  final Map<String, dynamic>? userInfo;
  final String? message;

  GoogleSignInResult({
    required this.success,
    this.googleToken,
    this.userInfo,
    this.message,
  });
}

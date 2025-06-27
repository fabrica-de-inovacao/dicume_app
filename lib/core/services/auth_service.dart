import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Secure Storage para tokens
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(synchronizable: false),
  );

  // Google Sign In
  late final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  // Keys para storage
  static const String _tokenKey = 'dicume_auth_token';
  static const String _userKey = 'dicume_user_data';
  static const String _isFirstLaunchKey = 'dicume_first_launch';

  void initialize() {
    if (_isInitialized) {
      debugPrint('🔑 [AUTH] AuthService já foi inicializado, pulando...');
      return;
    }

    _googleSignIn = GoogleSignIn(
      // Configurações do Google Sign-In
      scopes: ['email', 'profile'],
      // 🔑 SERVERCLIENTID é OBRIGATÓRIO para obter idToken
      // Este deve ser o WEB CLIENT ID (não o Android Client ID)
      // Usando o Web Client ID correto do Google Cloud Console:
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
      await _googleSignIn.signOut();
      debugPrint('🔐 [AUTH] Logout do Google Sign-In concluído');

      debugPrint('🔐 [AUTH] Chamando _googleSignIn.signIn()...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint(
        '🔐 [AUTH] Resultado do signIn: ${googleUser != null ? 'SUCCESS' : 'NULL'}',
      );

      if (googleUser == null) {
        debugPrint('🔐 [AUTH] ❌ Login cancelado pelo usuário');
        return GoogleSignInResult(
          success: false,
          message: 'Login cancelado pelo usuário',
        );
      }

      debugPrint('🔐 [AUTH] ✅ GoogleUser obtido: ${googleUser.email}');

      // 🔍 LOG COMPLETO DOS DADOS DO GOOGLE USER
      debugPrint('📋 [GOOGLE_USER] ========== DADOS COMPLETOS ==========');
      debugPrint('📋 [GOOGLE_USER] displayName: ${googleUser.displayName}');
      debugPrint('📋 [GOOGLE_USER] email: ${googleUser.email}');
      debugPrint('📋 [GOOGLE_USER] id: ${googleUser.id}');
      debugPrint('📋 [GOOGLE_USER] photoUrl: ${googleUser.photoUrl}');
      debugPrint(
        '📋 [GOOGLE_USER] serverAuthCode: ${googleUser.serverAuthCode}',
      );
      debugPrint('📋 [GOOGLE_USER] toString(): ${googleUser.toString()}');
      debugPrint('📋 [GOOGLE_USER] ========================================');

      debugPrint('🔐 [AUTH] Obtendo authentication do GoogleUser...');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 🔍 LOG COMPLETO DOS DADOS DE AUTENTICAÇÃO
      debugPrint(
        '📋 [GOOGLE_AUTH] ========== DADOS DE AUTENTICAÇÃO ==========',
      );
      debugPrint('� [GOOGLE_AUTH] accessToken: ${googleAuth.accessToken}');
      debugPrint('📋 [GOOGLE_AUTH] idToken: ${googleAuth.idToken}');
      debugPrint(
        '📋 [GOOGLE_AUTH] accessToken length: ${googleAuth.accessToken?.length ?? 0}',
      );
      debugPrint(
        '📋 [GOOGLE_AUTH] idToken length: ${googleAuth.idToken?.length ?? 0}',
      );
      debugPrint('📋 [GOOGLE_AUTH] toString(): ${googleAuth.toString()}');
      debugPrint(
        '📋 [GOOGLE_AUTH] =============================================',
      );

      debugPrint('�🔐 [AUTH] GoogleAuth obtido');
      debugPrint(
        '🔐 [AUTH] accessToken exists: ${googleAuth.accessToken != null}',
      );
      debugPrint('🔐 [AUTH] idToken exists: ${googleAuth.idToken != null}');

      if (googleAuth.idToken != null) {
        debugPrint(
          '🔐 [AUTH] idToken (primeiros 20 chars): ${googleAuth.idToken!.substring(0, 20)}...',
        );

        // 🔍 DECODIFICAR JWT PARA VER TODOS OS DADOS
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

      // 🔍 VERIFICAR QUAL TOKEN USAR PARA A API
      String? tokenForApi;
      String tokenType;

      if (googleAuth.idToken != null) {
        tokenForApi = googleAuth.idToken!;
        tokenType = 'ID_TOKEN';
        debugPrint(
          '🎯 [TOKEN] ✅ ID TOKEN disponível - IDEAL para API backend!',
        );
      } else if (googleAuth.accessToken != null) {
        tokenForApi = googleAuth.accessToken!;
        tokenType = 'ACCESS_TOKEN';
        debugPrint('⚠️ [TOKEN] Usando ACCESS TOKEN (idToken não disponível)');
      } else {
        debugPrint('❌ [TOKEN] Nenhum token disponível!');
        return GoogleSignInResult(
          success: false,
          message: 'Erro ao obter tokens do Google',
        );
      }

      debugPrint('🔐 [AUTH] ✅ Login com Google bem-sucedido!');

      // 🔍 PREPARAR DADOS COMPLETOS PARA API
      Map<String, dynamic> completeUserInfo = {
        'id': googleUser.id,
        'name': googleUser.displayName ?? '',
        'email': googleUser.email,
        'photoUrl': googleUser.photoUrl,
        'serverAuthCode': googleUser.serverAuthCode,
      };

      debugPrint('📋 [API_DATA] ========== DADOS PARA API ==========');
      debugPrint('📋 [API_DATA] completeUserInfo: $completeUserInfo');
      debugPrint('📋 [API_DATA] tokenType: $tokenType');
      debugPrint('📋 [API_DATA] tokenForApi length: ${tokenForApi.length}');
      debugPrint(
        '📋 [API_DATA] accessToken: ${googleAuth.accessToken != null ? "Disponível" : "NULL"}',
      );
      debugPrint(
        '📋 [API_DATA] idToken: ${googleAuth.idToken != null ? "Disponível" : "NULL"}',
      );
      debugPrint('📋 [API_DATA] =======================================');

      return GoogleSignInResult(
        success: true,
        googleToken: tokenForApi, // Token principal (preferencialmente idToken)
        accessToken: googleAuth.accessToken,
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
      await _googleSignIn.signOut();

      debugPrint('Logout realizado com sucesso');
    } catch (e) {
      debugPrint('Erro no logout: $e');
    }
  }

  // Limpar todos os dados (reset completo)
  Future<void> clearAllData() async {
    try {
      await _storage.deleteAll();
      await _googleSignIn.signOut();
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
  final String?
  googleToken; // Token principal (accessToken quando sem serverClientId)
  final String? accessToken; // Access Token específico
  final Map<String, dynamic>? userInfo;
  final String? message;

  GoogleSignInResult({
    required this.success,
    this.googleToken,
    this.accessToken,
    this.userInfo,
    this.message,
  });
}

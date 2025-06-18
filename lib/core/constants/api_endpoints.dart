class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.dicume.com/api/v1';
  static const String baseUrlDev = 'http://localhost:3000/api/v1';

  // Health Check
  static const String healthCheck = '/';
  static const String docs = '/docs';
  // Authentication
  static const String loginGoogle = '/auth/google';
  static const String requestSMSCode = '/auth/solicitar-codigo';
  static const String verifySMSCode = '/auth/validar-codigo';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // User Profile
  static const String users = '/users';
  static const String perfil = '/perfil';

  // Data
  static const String dadosAlimentos = '/dados/alimentos';

  // Diary
  static const String diarioRefeicoes = '/diario/refeicoes';
  static String diarioRefeicoesByData(String data) => '/diario/refeicoes/$data';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';

  // Values
  static const String jsonContentType = 'application/json';
  static const String jsonAccept = 'application/json';
  static String bearerToken(String token) => 'Bearer $token';
}

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/auth.dart';
import '../entities/failures.dart';

abstract class AuthRepository {
  /// Realiza login via Google
  /// Retorna [User] em caso de sucesso ou [AuthFailure] em caso de erro
  Future<Either<AuthFailure, User>> signInWithGoogle();

  // SMS flows removed (not supported)

  /// Realiza logout
  /// Retorna [AuthFailure] em caso de erro
  Future<Either<AuthFailure, void>> signOut();

  /// Obtém o usuário atual do cache/storage local
  /// Retorna [User] se houver usuário logado ou null se não houver
  Future<User?> getCurrentUser();

  /// Verifica se há um usuário autenticado
  Future<bool> isAuthenticated();

  /// Atualiza o token de acesso usando refresh token
  /// Retorna novo [AuthToken] em caso de sucesso ou [AuthFailure] em caso de erro
  Future<Either<AuthFailure, AuthToken>> refreshToken();

  /// Obtém o token de acesso atual
  /// Retorna [AuthToken] se disponível ou null se não houver
  Future<AuthToken?> getCurrentToken();

  /// Atualiza dados do usuário
  /// Retorna [User] atualizado em caso de sucesso ou [AuthFailure] em caso de erro
  Future<Either<AuthFailure, User>> updateUser(User user);

  /// Stream que emite mudanças no estado de autenticação
  /// Emite [User] quando usuário faz login e null quando faz logout
  Stream<User?> get authStateChanges;
}

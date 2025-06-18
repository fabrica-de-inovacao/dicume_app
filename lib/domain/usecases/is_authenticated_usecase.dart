import '../repositories/auth_repository.dart';

class IsAuthenticatedUseCase {
  final AuthRepository repository;

  IsAuthenticatedUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}

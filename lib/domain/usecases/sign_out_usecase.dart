import 'package:dartz/dartz.dart';
import '../entities/failures.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<AuthFailure, void>> call() async {
    return await repository.signOut();
  }
}

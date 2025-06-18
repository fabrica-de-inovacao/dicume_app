import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/failures.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<AuthFailure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}

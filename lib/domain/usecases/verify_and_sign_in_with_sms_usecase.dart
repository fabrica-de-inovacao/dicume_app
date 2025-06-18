import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/auth.dart';
import '../entities/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyAndSignInWithSMSUseCase {
  final AuthRepository repository;

  VerifyAndSignInWithSMSUseCase(this.repository);

  Future<Either<AuthFailure, User>> call(SMSVerificationRequest request) async {
    // Validações básicas
    if (request.phoneNumber.isEmpty) {
      return const Left(
        SMSVerificationFailure('Número de telefone não pode estar vazio'),
      );
    }

    if (request.verificationCode.isEmpty) {
      return const Left(InvalidSMSCodeFailure());
    }

    if (request.sessionId.isEmpty) {
      return const Left(SMSVerificationFailure('ID da sessão inválido'));
    }

    // Verifica se o código tem o formato correto (6 dígitos)
    if (!_isValidVerificationCode(request.verificationCode)) {
      return const Left(InvalidSMSCodeFailure());
    }

    return await repository.verifyAndSignInWithSMS(request);
  }

  bool _isValidVerificationCode(String code) {
    // Remove espaços e caracteres especiais
    final cleanCode = code.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se tem exatamente 6 dígitos
    return cleanCode.length == 6 && RegExp(r'^\d{6}$').hasMatch(cleanCode);
  }
}

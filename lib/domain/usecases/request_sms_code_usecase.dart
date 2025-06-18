import 'package:dartz/dartz.dart';
import '../entities/failures.dart';
import '../repositories/auth_repository.dart';

class RequestSMSCodeUseCase {
  final AuthRepository repository;

  RequestSMSCodeUseCase(this.repository);

  Future<Either<AuthFailure, String>> call(String phoneNumber) async {
    // Validação básica do número de telefone
    if (phoneNumber.isEmpty) {
      return const Left(
        SMSVerificationFailure('Número de telefone não pode estar vazio'),
      );
    }

    // Remove caracteres especiais e espaços
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Verifica se é um número válido brasileiro
    if (!_isValidBrazilianPhone(cleanPhone)) {
      return const Left(SMSVerificationFailure('Número de telefone inválido'));
    }

    return await repository.requestSMSCode(cleanPhone);
  }

  bool _isValidBrazilianPhone(String phone) {
    // Remove o código do país se presente
    String cleanPhone = phone;
    if (phone.startsWith('+55')) {
      cleanPhone = phone.substring(3);
    } else if (phone.startsWith('55')) {
      cleanPhone = phone.substring(2);
    }

    // Verifica se tem 10 ou 11 dígitos (formato brasileiro)
    if (cleanPhone.length != 10 && cleanPhone.length != 11) {
      return false;
    }

    // Verifica se o DDD é válido (código de área)
    if (cleanPhone.length >= 2) {
      final ddd = int.tryParse(cleanPhone.substring(0, 2));
      if (ddd == null || ddd < 11 || ddd > 99) {
        return false;
      }
    }

    return true;
  }
}

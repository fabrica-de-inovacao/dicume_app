import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/feedback_service.dart';

/// Provider para o serviço de feedback tátil e sonoro
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  final service = FeedbackService();

  // Configura as preferências padrão para usuários 60+
  // Mais feedback por padrão para melhor acessibilidade
  service.configure(haptics: true, sound: true);

  // Limpa recursos quando o provider for descartado
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

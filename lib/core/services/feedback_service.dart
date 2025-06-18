import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

/// Serviço centralizado para feedbacks táteis (vibração) e sonoros
/// Pensado especialmente para acessibilidade de usuários 60+ anos
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hapticsEnabled = true;
  bool _soundEnabled = true;

  /// Configura as preferências de feedback
  void configure({bool? haptics, bool? sound}) {
    _hapticsEnabled = haptics ?? _hapticsEnabled;
    _soundEnabled = sound ?? _soundEnabled;
  }

  // ============================================================================
  // FEEDBACKS TÁTEIS (VIBRAÇÃO)
  // ============================================================================

  /// Feedback tátil leve - para toques normais em botões
  Future<void> lightTap() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Vibração muito leve para confirmação de toque
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(duration: 10, amplitude: 50);
        }
      }
      // Fallback para feedback do sistema
      HapticFeedback.lightImpact();
    } catch (e) {
      // Se vibração falhar, usa feedback nativo
      HapticFeedback.lightImpact();
    }
  }

  /// Feedback tátil médio - para seleções importantes
  Future<void> mediumTap() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(duration: 25, amplitude: 100);
        }
      }
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Feedback tátil forte - para ações importantes como "Salvar"
  Future<void> strongTap() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(duration: 50, amplitude: 150);
        }
      }
      HapticFeedback.heavyImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Feedback de sucesso - padrão duplo
  Future<void> successFeedback() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Vibration.hasVibrator() == true) {
          // Padrão: curto-pausa-curto
          await Vibration.vibrate(duration: 30, amplitude: 120);
          await Future.delayed(const Duration(milliseconds: 100));
          await Vibration.vibrate(duration: 30, amplitude: 120);
        }
      } else {
        HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Feedback de erro - padrão longo
  Future<void> errorFeedback() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Vibration.hasVibrator() == true) {
          // Vibração mais longa para indicar erro
          await Vibration.vibrate(duration: 100, amplitude: 180);
        }
      }
      HapticFeedback.heavyImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Feedback de navegação - para mudanças de tela
  Future<void> navigationFeedback() async {
    if (!_hapticsEnabled) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(duration: 15, amplitude: 80);
        }
      }
      HapticFeedback.selectionClick();
    } catch (e) {
      HapticFeedback.selectionClick();
    }
  }

  // ============================================================================
  // FEEDBACKS SONOROS
  // ============================================================================

  /// Som de toque/clique suave
  Future<void> playTapSound() async {
    if (!_soundEnabled) return;

    try {
      // Usa sons do sistema do próprio Flutter/Material
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Silencioso se falhar
    }
  }

  /// Som de sucesso
  Future<void> playSuccessSound() async {
    if (!_soundEnabled) return;

    try {
      // Podemos usar sons personalizados ou do sistema
      SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      // Silencioso se falhar
    }
  }

  /// Som de erro
  Future<void> playErrorSound() async {
    if (!_soundEnabled) return;

    try {
      // Som de erro mais distintivo
      SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      // Silencioso se falhar
    }
  }

  /// Som de navegação
  Future<void> playNavigationSound() async {
    if (!_soundEnabled) return;

    try {
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Silencioso se falhar
    }
  }

  // ============================================================================
  // COMBINAÇÕES ESPECÍFICAS PARA O DICUMÊ
  // ============================================================================

  /// Feedback completo para busca de alimentos
  Future<void> searchFeedback() async {
    await lightTap();
    await playTapSound();
  }

  /// Feedback para adicionar alimento ao prato
  Future<void> addAlimentoFeedback() async {
    await mediumTap();
    await playSuccessSound();
  }

  /// Feedback para salvar refeição
  Future<void> saveRefeicaoFeedback() async {
    await successFeedback();
    await playSuccessSound();
  }

  /// Feedback para semáforo nutricional
  Future<void> semaforoFeedback(String classificacao) async {
    switch (classificacao) {
      case 'verde':
        await lightTap();
        await playSuccessSound();
        break;
      case 'amarelo':
        await mediumTap();
        await playTapSound();
        break;
      case 'vermelho':
        await strongTap();
        await playErrorSound();
        break;
      default:
        await lightTap();
        await playTapSound();
    }
  }

  /// Feedback para navegação entre tabs
  Future<void> tabNavigationFeedback() async {
    await navigationFeedback();
    await playNavigationSound();
  }

  /// Feedback para voltar/cancelar
  Future<void> backFeedback() async {
    await lightTap();
    await playTapSound();
  }

  // ============================================================================
  // GERENCIAMENTO
  // ============================================================================

  /// Libera recursos quando não precisar mais
  void dispose() {
    _audioPlayer.dispose();
  }
}

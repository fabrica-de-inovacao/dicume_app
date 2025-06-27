import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // PALETA REFINADA E ELEGANTE - DICUMÊ
  // Baseada em princípios de design moderno e minimalista
  // ============================================================================

  // Cores Primárias - Marrom Terroso Suavizado
  static const Color primary = Color(0xFF6D4C41); // Marrom mais suave
  static const Color primaryLight = Color(0xFF8D6E63); // Tom mais claro
  static const Color primaryDark = Color(
    0xFF5D4037,
  ); // Tom original para contraste
  static const Color onPrimary = Color(0xFFFFFFFF); // Branco puro

  // Cores Secundárias - Azul Refinado
  static const Color secondary = Color(0xFF2196F3); // Azul mais suave
  static const Color secondaryLight = Color(0xFF64B5F6); // Tom claro
  static const Color secondaryDark = Color(0xFF1976D2); // Tom escuro
  static const Color onSecondary = Color(0xFFFFFFFF); // Branco puro

  // Neutros Refinados
  static const Color background = Color(0xFFFAFAFA); // Off-white elegante
  static const Color surface = Color(0xFFFFFFFF); // Branco puro
  static const Color surfaceVariant = Color(
    0xFFF8F9FA,
  ); // Cinza quase imperceptível
  static const Color outline = Color(0xFFE0E0E0); // Bordas suaves
  static const Color shadow = Color(0x0A000000); // Sombra muito sutil

  // Textos Hierárquicos
  static const Color textPrimary = Color(0xFF212121); // Preto suave
  static const Color textSecondary = Color(0xFF757575); // Cinza médio
  static const Color textTertiary = Color(0xFFBDBDBD); // Cinza claro
  static const Color textHint = Color(0xFFE0E0E0); // Placeholder

  // Semáforo Nutricional Refinado
  static const Color success = Color(0xFF4CAF50); // Verde limpo
  static const Color successLight = Color(0xFFE8F5E9); // Fundo verde claro
  static const Color warning = Color(0xFFFF9800); // Laranja ao invés de amarelo
  static const Color warningLight = Color(0xFFFFF3E0); // Fundo laranja claro
  static const Color danger = Color(0xFFF44336); // Vermelho limpo
  static const Color dangerLight = Color(0xFFFFEBEE); // Fundo vermelho claro

  // Estados Interativos
  static const Color hover = Color(0x08000000); // Hover muito sutil
  static const Color pressed = Color(0x12000000); // Press sutil
  static const Color focus = Color(0x1F2196F3); // Focus azul translúcido
  static const Color disabled = Color(0x61000000); // Disabled padrão Material

  // Cores de Acento Suaves
  static const Color accent1 = Color(0xFF9C27B0); // Roxo para destaque
  static const Color accent2 = Color(
    0xFF009688,
  ); // Teal para variedade  static const Color accent3 = Color(0xFFFF5722); // Deep Orange para energia

  // Cores legadas (mantidas para compatibilidade temporária)
  static const Color error = danger;
  static const Color onError = onPrimary;
  static const Color onSurface = textPrimary;
  static const Color onBackground = textPrimary;

  // Cores antigas removidas gradualmente
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFE0E0E0);
  static const Color grey300 = Color(0xFFBDBDBD);
  static const Color grey400 = Color(0xFF9E9E9E);
  static const Color grey500 = Color(0xFF757575);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);

  static const Color brown50 = Color(0xFFEFEBE9);
  static const Color brown100 = Color(0xFFD7CCC8);
  static const Color brown200 = Color(0xFFBCAAA4);
  static const Color brown300 = Color(0xFFA1887F);
  static const Color brown400 = Color(0xFF8D6E63);
  static const Color brown700 = Color(0xFF5D4037);
  static const Color brown800 = Color(0xFF4E342E);

  static const Color blue50 = Color(0xFFE3F2FD);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue800 = Color(0xFF1565C0);

  static const Color green50 = successLight;
  static const Color green600 = success;

  // Cores do semáforo (legado)
  static const Color semaforoVerde = success;
  static const Color semaforoAmarelo = warning;
  static const Color semaforoVermelho = danger;

  // ============================================================================
  // SOMBRAS ELEGANTES
  // ============================================================================

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: const Color(0x14000000),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: const Color(0x1F000000),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // ============================================================================
  // GRADIENTES SUTIS (apenas quando necessário)
  // ============================================================================

  // Gradiente muito sutil para headers importantes
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
  );

  // Gradiente para o semáforo nutricional (mais sutil)
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF5350), Color(0xFFF44336)],
  );

  // Gradientes legados (mantidos para compatibilidade)
  static const LinearGradient backgroundGradient = subtleGradient;
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary],
  );
  static const LinearGradient cardGradient = subtleGradient;
  static const LinearGradient greenGradient = successGradient;
  static const LinearGradient yellowGradient = warningGradient;
  static const LinearGradient redGradient = dangerGradient;

  // ============================================================================
  // MÉTODOS UTILITÁRIOS
  // ============================================================================

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Cores com estados
  static Color primaryWithState(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) return primaryDark;
    if (states.contains(WidgetState.hovered)) return primaryLight;
    return primary;
  }

  static Color surfaceWithElevation(double elevation) {
    if (elevation <= 1) return surface;
    if (elevation <= 2) return surfaceVariant;
    return const Color(0xFFF5F5F5);
  }
}

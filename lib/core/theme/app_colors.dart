import 'package:flutter/material.dart';

class AppColors {
  // Paleta Maranhense Principal
  static const Color primary = Color(0xFF5D4037); // Marrom Terroso
  static const Color onPrimary = Color(0xFFFFFFFF); // Branco
  static const Color secondary = Color(0xFF1E88E5); // Azul Vibrante
  static const Color onSecondary = Color(0xFFFFFFFF); // Branco

  // Background e Surface
  static const Color background = Color(0xFFF5F5F5); // Cinza Muito Claro
  static const Color onBackground = Color(0xFF212121); // Preto Suave
  static const Color surface = Color(0xFFFFFFFF); // Branco
  static const Color onSurface = Color(0xFF212121); // Preto Suave

  // Error
  static const Color error = Color(0xFFD32F2F); // Vermelho
  static const Color onError = Color(0xFFFFFFFF); // Branco

  // Semáforo Nutricional
  static const Color semaforoVerde = Color(0xFF4CAF50); // Bom
  static const Color semaforoAmarelo = Color(0xFFFFC107); // Moderação
  static const Color semaforoVermelho = Color(0xFFF44336); // Evitar

  // Tons da Paleta Maranhense (para variações)
  static const Color brown50 = Color(0xFFEFEBE9);
  static const Color brown100 = Color(0xFFD7CCC8);
  static const Color brown200 = Color(0xFFBCAAA4);
  static const Color brown300 = Color(0xFFA1887F);
  static const Color brown400 = Color(0xFF8D6E63);
  static const Color brown500 = primary; // 0xFF5D4037
  static const Color brown600 = Color(0xFF5D4037);
  static const Color brown700 = Color(0xFF4E342E);
  static const Color brown800 = Color(0xFF3E2723);
  static const Color brown900 = Color(0xFF2E1D1C);

  // Azul Vibrante (variações)
  static const Color blue50 = Color(0xFFE3F2FD);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue300 = Color(0xFF64B5F6);
  static const Color blue400 = Color(0xFF42A5F5);
  static const Color blue500 = secondary; // 0xFF1E88E5
  static const Color blue600 = Color(0xFF1976D2);
  static const Color blue700 = Color(0xFF1565C0);
  static const Color blue800 = Color(0xFF0D47A1);
  static const Color blue900 = Color(0xFF0A3D91);
  // Verde (para elementos de sucesso/nutrição)
  static const Color green50 = Color(0xFFE8F5E8);
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green300 = Color(0xFF81C784);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color green500 = semaforoVerde; // 0xFF4CAF50
  static const Color green600 = Color(0xFF43A047);
  static const Color green700 = Color(0xFF388E3C);
  static const Color green800 = Color(0xFF2E7D32);
  static const Color green900 = Color(0xFF1B5E20);

  // Greys (para textos e elementos neutros)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Status Colors (além do semáforo)
  static const Color success = semaforoVerde;
  static const Color warning = semaforoAmarelo;
  static const Color danger = semaforoVermelho;
  static const Color info = secondary;

  // Transparências úteis
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);
  static Color backgroundWithOpacity(double opacity) =>
      background.withValues(alpha: opacity);

  // Dark Theme (para futuro)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
}

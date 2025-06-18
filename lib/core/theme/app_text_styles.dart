import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Base Montserrat Text Theme
  static TextTheme get textTheme => GoogleFonts.montserratTextTheme().copyWith(
    // Display Styles - Títulos grandes e de destaque
    displayLarge: GoogleFonts.montserrat(
      fontSize: 48.0,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
    ),

    // Headline Styles - Títulos de tela
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      letterSpacing: -0.25,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),

    // Title Styles - Títulos de seções e cards
    titleLarge: GoogleFonts.montserrat(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      letterSpacing: 0.1,
    ),

    // Body Styles - Corpo de texto principal
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: AppColors.onSurface,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: AppColors.onSurface,
      letterSpacing: 0.25,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.grey600,
      letterSpacing: 0.4,
      height: 1.3,
    ),

    // Label Styles - Rótulos de botões e textos menores
    labelLarge: GoogleFonts.montserrat(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      letterSpacing: 1.25,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurface,
      letterSpacing: 1.25,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: AppColors.grey600,
      letterSpacing: 1.5,
    ),
  );

  // Estilos customizados específicos do DICUMÊ

  // Título principal da splash screen
  static TextStyle get splashTitle => GoogleFonts.montserrat(
    fontSize: 56.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: -1.0,
  );

  // Título das telas principais ("Bora Montar o Prato!")
  static TextStyle get screenTitle => GoogleFonts.montserrat(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -0.25,
  );

  // Nome dos alimentos
  static TextStyle get alimentoNome => GoogleFonts.montserrat(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: 0.15,
  );

  // Quantidade/medida caseira
  static TextStyle get medidaCaseira => GoogleFonts.montserrat(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.grey600,
    letterSpacing: 0.25,
  );

  // Feedback do semáforo
  static TextStyle get semaforoFeedback => GoogleFonts.montserrat(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Botão principal
  static TextStyle get botaoPrincipal => GoogleFonts.montserrat(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 1.25,
  );

  // Botão secundário
  static TextStyle get botaoSecundario => GoogleFonts.montserrat(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 1.25,
  );

  // Texto de campo de formulário
  static TextStyle get campoTexto => GoogleFonts.montserrat(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    letterSpacing: 0.15,
  );

  // Label de campo
  static TextStyle get labelCampo => GoogleFonts.montserrat(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.grey600,
    letterSpacing: 0.4,
  );

  // Texto de erro
  static TextStyle get textoErro => GoogleFonts.montserrat(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    letterSpacing: 0.25,
  );

  // Navegação bottom bar
  static TextStyle get navegacaoLabel => GoogleFonts.montserrat(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
  );

  // Utilitários para variações de cor
  static TextStyle semaforoFeedbackColorido(Color cor) =>
      semaforoFeedback.copyWith(color: cor);
  static TextStyle navegacaoLabelColorido(Color cor) =>
      navegacaoLabel.copyWith(color: cor);
}

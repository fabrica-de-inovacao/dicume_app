import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart'; // Importar AppConstants

class AlimentoDisplayHelper {
  // Mapeia guia_alimentar_class para textos amigáveis
  static String getGuiaAlimentarFriendly(String guiaAlimentarClass) {
    switch (guiaAlimentarClass.toLowerCase()) {
      case 'in_natura':
        return 'Alimento Natural';
      case 'minimamente_processado':
        return 'Minimamente Processado';
      case 'processado':
        return 'Processado';
      case 'ultraprocessado':
        return 'Ultraprocessado';
      default:
        return guiaAlimentarClass;
    }
  }

  // Mapeia recomendacao_consumo para textos amigáveis
  static String getRecomendacaoConsumoFriendly(String recomendacao) {
    if (recomendacao.isEmpty) return '';
    final raw = recomendacao.toLowerCase();
    // Casos explícitos
    if (raw == 'a_vontade' || raw == 'a vontade' || raw == 'avontade') {
      return 'À Vontade';
    }
    if (raw.contains('moder')) return 'Com Moderação';
    if (raw.contains('restrit')) return 'Consumo Restrito';
    if (raw.contains('evit')) return 'Evitar';

    // Formata quantidades no estilo '3_colheres_de_sopa' -> '3 colheres de sopa'
    final formatted = recomendacao.replaceAll('_', ' ').replaceAll(';', ', ');
    // Ajuste de números com ponto decimal para vírgula
    final numberFixed = formatted.replaceAllMapped(
      RegExp(r"(\d+)\.(\d+)"),
      (m) => '${m[1]},${m[2]}',
    );
    // Capitaliza a primeira letra
    return numberFixed.isNotEmpty
        ? numberFixed[0].toUpperCase() + numberFixed.substring(1)
        : recomendacao;
  }

  // Mapeia ig_classificacao para textos amigáveis
  static String getIGClassificacaoFriendly(String igClassificacao) {
    switch (igClassificacao.toLowerCase()) {
      case 'baixo':
        return 'Baixo IG';
      case 'medio':
      case 'médio':
        return 'Médio IG';
      case 'alto':
        return 'Alto IG';
      default:
        return igClassificacao;
    }
  }

  // Constrói URL completa da imagem
  static String getImageUrl(String fotoPorcaoUrl, [String? baseUrl]) {
    // baseUrl agora é opcional
    if (fotoPorcaoUrl.isEmpty) return '';

    // Se já é uma URL completa, retorna como está
    if (fotoPorcaoUrl.startsWith('http://') ||
        fotoPorcaoUrl.startsWith('https://')) {
      return fotoPorcaoUrl;
    }

    // Se é um caminho relativo da API, constrói a URL completa
    if (fotoPorcaoUrl.startsWith('./imgs/')) {
      final effectiveBaseUrl = baseUrl ?? AppConstants.apiBaseUrl;
      return '$effectiveBaseUrl/imgs/${fotoPorcaoUrl.substring(7)}'; // Remove './imgs/'
    }

    return fotoPorcaoUrl;
  }

  // Cor do semáforo nutricional
  static Color getSemaforoColor(String classificacaoCor) {
    switch (classificacaoCor.toLowerCase()) {
      case 'verde':
        return AppColors.semaforoVerde;
      case 'amarelo':
        return AppColors.semaforoAmarelo;
      case 'vermelho':
        return AppColors.semaforoVermelho;
      default:
        return AppColors.grey500;
    }
  }

  // Ícone baseado na classificação
  static IconData getIconForClassification(String classificacaoCor) {
    switch (classificacaoCor.toLowerCase()) {
      case 'verde':
        return Icons.eco_rounded;
      case 'amarelo':
        return Icons.warning_amber_rounded;
      case 'vermelho':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }
}

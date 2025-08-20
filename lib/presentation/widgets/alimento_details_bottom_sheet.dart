import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../../domain/entities/alimento.dart'; // Importar a entidade Alimento
import '../../../core/utils/alimento_display_helper.dart'; // Importar o helper
// imports ajustados: removidos arquivos não usados para evitar warnings/erros

class AlimentoDetailsBottomSheet extends StatelessWidget {
  final Alimento alimento;

  const AlimentoDetailsBottomSheet({super.key, required this.alimento});

  @override
  Widget build(BuildContext context) {
    final semaforoColor = AlimentoDisplayHelper.getSemaforoColor(
      alimento.classificacaoCor,
    );
    final textTheme = Theme.of(context).textTheme;
    final heroTag = 'alimento_image_${alimento.id}';
    final imageUrl = AlimentoDisplayHelper.getImageUrl(
      alimento.fotoPorcaoUrl,
      AppConstants.apiBaseUrl,
    );

    // Use a content-sized bottom sheet so it opens with the minimal height
    // necessary to display the content. Wrapping with SafeArea and
    // SingleChildScrollView allows the sheet to size to its children while
    // remaining scrollable on small screens.
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Header: imagem + título + chip + close button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // imagem clicável com Hero e overlay de lupa
                    GestureDetector(
                      onTap:
                          imageUrl.isNotEmpty
                              ? () => _openImagePreview(
                                context,
                                imageUrl,
                                heroTag,
                                semaforoColor,
                              )
                              : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: semaforoColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: semaforoColor.withValues(alpha: 0.22),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Hero(
                                tag: heroTag,
                                child: _buildAlimentoImageForModal(
                                  alimento,
                                  semaforoColor,
                                ),
                              ),
                            ),
                          ),

                          // overlay lupa quando existe imagem
                          if (imageUrl.isNotEmpty)
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.zoom_in_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alimento.nomePopular,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Grupo DICUMÊ como chip para visual
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Chip(
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                label: Text(
                                  alimento.grupoDicume,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              Chip(
                                avatar: Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: semaforoColor,
                                ),
                                backgroundColor: semaforoColor.withValues(
                                  alpha: 0.08,
                                ),
                                label: Text(
                                  alimento.classificacaoCor.toUpperCase(),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: semaforoColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botão de fechar pequeno no canto do sheet
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const SizedBox(height: 12),

                // informações detalhadas em seções com espaçamento maior e separadores
                _buildDetailRow(
                  'Grupo DICUMÊ',
                  alimento.grupoDicume,
                  textTheme,
                ),
                const SizedBox(height: 6),
                _buildDetailRow(
                  'Índice Glicêmico',
                  AlimentoDisplayHelper.getIGClassificacaoFriendly(
                    alimento.igClassificacao,
                  ),
                  textTheme,
                ),
                const SizedBox(height: 6),
                _buildDetailRow(
                  'Grupo Nutricional',
                  alimento.grupoNutricional,
                  textTheme,
                ),
                const SizedBox(height: 6),
                _buildDetailRow(
                  'Tipo de Alimento',
                  AlimentoDisplayHelper.getGuiaAlimentarFriendly(
                    alimento.guiaAlimentarClass,
                  ),
                  textTheme,
                ),
                const SizedBox(height: 6),
                // Recomendação com chip colorido e texto explicativo quando aplicável
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Recomendação',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            backgroundColor: semaforoColor.withValues(
                              alpha: 0.12,
                            ),
                            label: Text(
                              AlimentoDisplayHelper.getRecomendacaoConsumoFriendly(
                                alimento.recomendacaoConsumo,
                              ),
                              style: textTheme.bodyMedium?.copyWith(
                                color: semaforoColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Observação: quando a recomendação for 'a_vontade' não mostramos quantidade
                      if (alimento.recomendacaoConsumo.toLowerCase() !=
                          'a_vontade')
                        Text(
                          _formatQuantidadeRecomendacao(
                            alimento.recomendacaoConsumo,
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Botão: adicionar ao prato
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.of(context).pop(alimento); // retorna alimento
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Adicionar ao Prato'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, TextTheme textTheme) {
    IconData? icon;
    Color? iconColor;

    // Adicionar ícones baseados no label
    switch (label) {
      case 'Grupo DICUMÊ':
        icon = Icons.category_rounded;
        break;
      case 'Índice Glicêmico':
        icon = Icons.bloodtype_rounded;
        break;
      case 'Grupo Nutricional':
        icon = Icons.restaurant_rounded;
        break;
      case 'Tipo de Alimento':
        icon = Icons.restaurant_rounded;
        break;
      case 'Recomendação':
        icon = Icons.info_rounded;
        break;
    }

    // Cores específicas para recomendação
    if (label == 'Recomendação') {
      switch (value) {
        case 'À Vontade':
          iconColor = AppColors.semaforoVerde;
          break;
        case 'Com Moderação':
          iconColor = AppColors.semaforoAmarelo;
          break;
        case 'Consumo Restrito':
        case 'Evitar':
          iconColor = AppColors.semaforoVermelho;
          break;
      }
    }

    // Layout mais moderno: label em cima (negrito) e valor abaixo
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? AppColors.secondary, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Formata quantidades vindas da API para exibição curta
  String _formatQuantidadeRecomendacao(String raw) {
    if (raw.isEmpty) return '';
    // Normaliza underline para espaço e troca termos simples
    final s = raw.replaceAll('_', ' ').replaceAll(RegExp(r";"), ', ');
    // Alguns valores compostos (ex: '0.5_unidade') podem conter números — só capitaliza
    return s.replaceFirstMapped(
      RegExp(r'^.'),
      (m) => m.group(0)!.toUpperCase(),
    );
  }

  Widget _buildAlimentoImageForModal(Alimento alimento, Color semaforoColor) {
    final imageUrl = AlimentoDisplayHelper.getImageUrl(
      alimento.fotoPorcaoUrl,
      AppConstants.apiBaseUrl,
    );

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: semaforoColor.withValues(alpha: 0.08),
            child: Icon(
              AlimentoDisplayHelper.getIconForClassification(
                alimento.classificacaoCor,
              ),
              color: semaforoColor,
              size: 44,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: semaforoColor.withValues(alpha: 0.08),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  color: semaforoColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        color: semaforoColor.withValues(alpha: 0.08),
        child: Icon(
          AlimentoDisplayHelper.getIconForClassification(
            alimento.classificacaoCor,
          ),
          color: semaforoColor,
          size: 44,
        ),
      );
    }
  }

  // Preview fullscreen com InteractiveViewer + Hero
  void _openImagePreview(
    BuildContext context,
    String imageUrl,
    String heroTag,
    Color semaforoColor,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.85),
        pageBuilder: (context, animation, secondaryAnimation) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: heroTag,
                        child: SizedBox(
                          width: 360,
                          height: 360,
                          child: InteractiveViewer(
                            maxScale: 5.0,
                            minScale: 1.0,
                            child:
                                imageUrl.isNotEmpty
                                    ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                            color: semaforoColor,
                                          ),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: double.infinity,
                                          color: semaforoColor.withValues(
                                            alpha: 0.08,
                                          ),
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            color: semaforoColor,
                                            size: 80,
                                          ),
                                        );
                                      },
                                    )
                                    : Container(
                                      width: double.infinity,
                                      color: semaforoColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      child: Icon(
                                        Icons.restaurant_menu_rounded,
                                        color: semaforoColor,
                                        size: 80,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),

                    // Botão fechar visível
                    Positioned(
                      top: 20,
                      right: 16,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

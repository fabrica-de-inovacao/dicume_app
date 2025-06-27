import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/feedback_service.dart';

class PerfilScreenV3 extends StatefulWidget {
  const PerfilScreenV3({super.key});

  @override
  State<PerfilScreenV3> createState() => _PerfilScreenV3State();
}

class _PerfilScreenV3State extends State<PerfilScreenV3> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          FeedbackService().lightTap();
          if (context.mounted) {
            context.go('/home');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DicumeElegantAppBar(title: 'Seu Perfil'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPerfilCard(),
              const SizedBox(height: 24),
              _buildPreferenciasSection(),
              const SizedBox(height: 24),
              _buildEstatisticasSection(),
              const SizedBox(height: 24),
              _buildConfiguracoesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfilCard() {
    return DicumeElegantCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Maria Silva',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Usuária há 2 meses',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pratos Montados',
                  '47',
                  Icons.restaurant,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Dias Ativos',
                  '35',
                  Icons.calendar_today,
                  AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenciasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suas Preferências',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        DicumeElegantCard(
          child: Column(
            children: [
              _buildPreferenceItem(
                'Objetivo Principal',
                'Alimentação Saudável',
                Icons.favorite,
                AppColors.danger,
              ),
              const Divider(),
              _buildPreferenceItem(
                'Restrições Alimentares',
                'Nenhuma',
                Icons.no_food,
                AppColors.textSecondary,
              ),
              const Divider(),
              _buildPreferenceItem(
                'Nível de Atividade',
                'Moderado',
                Icons.directions_walk,
                AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suas Conquistas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        DicumeElegantCard(
          child: Column(
            children: [
              _buildConquistaItem(
                'Primeira Refeição',
                'Completou sua primeira refeição no DICUMÊ',
                Icons.celebration,
                AppColors.success,
                true,
              ),
              const Divider(),
              _buildConquistaItem(
                'Semana Completa',
                'Registrou refeições por 7 dias seguidos',
                Icons.calendar_view_week,
                AppColors.primary,
                true,
              ),
              const Divider(),
              _buildConquistaItem(
                'Exploradora',
                'Experimentou alimentos de todos os grupos',
                Icons.explore,
                AppColors.warning,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConquistaItem(
    String titulo,
    String descricao,
    IconData icon,
    Color color,
    bool conquistada,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  conquistada
                      ? color.withValues(alpha: 0.15)
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 24,
              color: conquistada ? color : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            conquistada
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                      ),
                    ),
                    if (conquistada) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfiguracoesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        DicumeElegantCard(
          child: Column(
            children: [
              _buildConfigItem(
                'Notificações',
                'Lembretes de refeições',
                Icons.notifications_outlined,
                onTap: () => _showNotificationsConfig(),
              ),
              const Divider(),
              _buildConfigItem(
                'Privacidade',
                'Controle seus dados',
                Icons.privacy_tip_outlined,
                onTap: () => _showPrivacyConfig(),
              ),
              const Divider(),
              _buildConfigItem(
                'Ajuda',
                'Dúvidas e suporte',
                Icons.help_outline,
                onTap: () => _showHelp(),
              ),
              const Divider(),
              _buildConfigItem(
                'Sobre o App',
                'Versão e informações',
                Icons.info_outline,
                onTap: () => _showAbout(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        DicumeElegantButton(
          text: 'Editar Perfil',
          icon: Icons.edit,
          width: double.infinity,
          isOutlined: true,
          onPressed: () {
            _editarPerfil();
          },
        ),
      ],
    );
  }

  Widget _buildConfigItem(
    String titulo,
    String subtitulo,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsConfig() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações de notificações'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showPrivacyConfig() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações de privacidade'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Central de ajuda'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Sobre o DICUMÊ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Versão 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'O DICUMÊ é um aplicativo desenvolvido para ajudar você a montar pratos equilibrados e saudáveis de forma simples e intuitiva.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            actions: [
              DicumeElegantButton(
                text: 'Fechar',
                isSmall: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _editarPerfil() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Editar perfil - Em desenvolvimento'),
        backgroundColor: AppColors.warning,
      ),
    );
  }
}

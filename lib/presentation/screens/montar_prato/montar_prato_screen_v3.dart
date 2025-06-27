import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/feedback_service.dart';

class MontarPratoScreenV3 extends StatefulWidget {
  const MontarPratoScreenV3({super.key});

  @override
  State<MontarPratoScreenV3> createState() => _MontarPratoScreenV3State();
}

class _MontarPratoScreenV3State extends State<MontarPratoScreenV3> {
  List<Map<String, dynamic>> get _gruposAlimentares => [
    {
      'nome': 'Verduras e Legumes',
      'descricao': 'Frescos e nutritivos',
      'icone': Icons.eco,
      'cor': AppColors.success,
      'alimentos': ['Alface', 'Tomate', 'Cenoura', 'Brócolis'],
    },
    {
      'nome': 'Proteínas',
      'descricao': 'Carnes, ovos e leguminosas',
      'icone': Icons.fitness_center,
      'cor': AppColors.danger,
      'alimentos': ['Frango', 'Peixe', 'Ovos', 'Feijão'],
    },
    {
      'nome': 'Carboidratos',
      'descricao': 'Energia para o dia',
      'icone': Icons.grain,
      'cor': AppColors.warning,
      'alimentos': ['Arroz', 'Batata', 'Macarrão', 'Pão'],
    },
    {
      'nome': 'Frutas',
      'descricao': 'Doces e saudáveis',
      'icone': Icons.apple,
      'cor': AppColors.accent1,
      'alimentos': ['Banana', 'Maçã', 'Laranja', 'Uva'],
    },
  ];
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
        appBar: DicumeElegantAppBar(title: 'Montar seu Prato'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildGroupsSection(),
              const SizedBox(height: 24),
              _buildQuickActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return DicumeElegantCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Vamos montar seu prato!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Escolha os grupos de alimentos e monte uma refeição equilibrada e saborosa.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsSection() {
    final grupos = _gruposAlimentares;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grupos de Alimentos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Toque em um grupo para ver os alimentos disponíveis',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ...grupos.map(
          (grupo) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DicumeElegantCard(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/selecionar-grupo',
                  arguments: grupo,
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: (grupo['cor'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      grupo['icone'] as IconData,
                      size: 28,
                      color: grupo['cor'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          grupo['nome'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          grupo['descricao'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${grupo['alimentos']?.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard() {
    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flash_on, color: AppColors.warning, size: 24),
              SizedBox(width: 12),
              Text(
                'Ações Rápidas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DicumeElegantButton(
                  text: 'Prato Balanceado',
                  icon: Icons.balance,
                  isSmall: true,
                  onPressed: () {
                    _criarPratoBalanceado();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DicumeElegantButton(
                  text: 'Só Verduras',
                  icon: Icons.eco,
                  isSmall: true,
                  isSecondary: true,
                  onPressed: () {
                    _criarPratoVegetariano();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DicumeElegantButton(
            text: 'Começar do Zero',
            icon: Icons.add_circle_outline,
            width: double.infinity,
            isOutlined: true,
            onPressed: () {
              _iniciarMontagem();
            },
          ),
        ],
      ),
    );
  }

  void _criarPratoBalanceado() {
    // Implementar navegação para prato balanceado automático
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Criando um prato balanceado para você...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _criarPratoVegetariano() {
    // Implementar navegação para prato vegetariano
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Montando um prato só com verduras...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _iniciarMontagem() {
    // Implementar fluxo de montagem guiada
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Iniciando montagem personalizada...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

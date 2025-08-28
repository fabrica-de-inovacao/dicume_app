import 'package:flutter/material.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/theme/app_colors.dart';

class HistoricoScreenV3 extends StatefulWidget {
  const HistoricoScreenV3({super.key});

  @override
  State<HistoricoScreenV3> createState() => _HistoricoScreenV3State();
}

class _HistoricoScreenV3State extends State<HistoricoScreenV3> {
  final List<Map<String, dynamic>> _historicoMockado = [
    {
      'data': 'Hoje, 12:30',
      'titulo': 'Almoço Balanceado',
      'itens': ['Arroz integral', 'Peito de frango', 'Salada verde', 'Feijão'],
      'calorias': 450,
      'satisfacao': 5,
      'cor': AppColors.success,
    },
    {
      'data': 'Ontem, 19:15',
      'titulo': 'Jantar Leve',
      'itens': ['Sopa de legumes', 'Pão integral', 'Suco natural'],
      'calorias': 320,
      'satisfacao': 4,
      'cor': AppColors.primary,
    },
    {
      'data': 'Anteontem, 13:00',
      'titulo': 'Prato Vegetariano',
      'itens': ['Quinoa', 'Brócolis', 'Cenoura', 'Grão-de-bico'],
      'calorias': 380,
      'satisfacao': 5,
      'cor': AppColors.success,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DicumeElegantAppBar(title: 'Seu Histórico'),
      body:
          _historicoMockado.isEmpty
              ? _buildEmptyState()
              : _buildHistoricoList(),
    );
  }

  Widget _buildEmptyState() {
    return const DicumeEmptyState(
      title: 'Nenhuma refeição registrada',
      message:
          'Quando você montar seus primeiros pratos, eles aparecerão aqui para você acompanhar seu progresso.',
      icon: Icons.restaurant_outlined,
      actionText: 'Montar Primeiro Prato',
    );
  }

  Widget _buildHistoricoList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const Text(
            'Refeições Recentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._historicoMockado.map(
            (refeicao) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRefeicaoCard(refeicao),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Resumo da Semana',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Pratos Montados',
                  '${_historicoMockado.length}',
                  Icons.restaurant,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Calorias Médias',
                  '${(_historicoMockado.fold<int>(0, (sum, item) => sum + (item['calorias'] as int)) / _historicoMockado.length).round()}',
                  Icons.local_fire_department,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Satisfação Média',
                  '${(_historicoMockado.fold<int>(0, (sum, item) => sum + (item['satisfacao'] as int)) / _historicoMockado.length).toStringAsFixed(1)}⭐',
                  Icons.sentiment_satisfied,
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Sequência',
                  '3 dias',
                  Icons.local_fire_department,
                  AppColors.accent1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
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

  Widget _buildRefeicaoCard(Map<String, dynamic> refeicao) {
    return DicumeElegantCard(
      onTap: () {
        _showRefeicaoDetails(refeicao);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: refeicao['cor'] as Color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      refeicao['titulo'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      refeicao['data'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${refeicao['calorias']} kcal',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < refeicao['satisfacao']
                            ? Icons.star
                            : Icons.star_border,
                        size: 12,
                        color: AppColors.warning,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                (refeicao['itens'] as List<String>).map((item) {
                  return DicumeElegantChip(
                    label: item,
                    color: AppColors.textSecondary,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _showRefeicaoDetails(Map<String, dynamic> refeicao) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: refeicao['cor'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          refeicao['titulo'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    refeicao['data'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Alimentos consumidos:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(refeicao['itens'] as List<String>).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: DicumeElegantButton(
                          text: 'Repetir Prato',
                          icon: Icons.refresh,
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pop(context);
                            // Implementar repetir prato
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DicumeElegantButton(
                          text: 'Fechar',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

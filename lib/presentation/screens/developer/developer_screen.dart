import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
import '../../../core/services/database_service.dart';

class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  bool _isLoading = false;
  String _lastAction = '';

  @override
  Widget build(BuildContext context) {
    // Só mostra no modo debug
    if (!kDebugMode) {
      return Scaffold(
        appBar: AppBar(title: const Text('Não disponível')),
        body: const Center(
          child: Text(
            'Esta área só está disponível em modo de desenvolvimento.',
          ),
        ),
      );
    }
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
        appBar: AppBar(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          title: const Text('🧑‍💻 Área do Desenvolvedor'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FeedbackService().lightTap();
              context.go('/home');
            },
          ),
        ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aviso de debug
            _buildWarningCard(textTheme),
            const SizedBox(height: 24),

            // Status da última ação
            if (_lastAction.isNotEmpty) ...[
              _buildStatusCard(textTheme),
              const SizedBox(height: 24),
            ],

            // Seção Database
            _buildSectionCard(
              title: '🗄️ Banco de Dados',
              children: [
                _buildActionTile(
                  icon: Icons.delete_forever,
                  title: 'Limpar DB Local',
                  subtitle: 'Remove todos os dados locais',
                  color: AppColors.error,
                  onTap: _clearLocalDatabase,
                ),
                _buildActionTile(
                  icon: Icons.sync,
                  title: 'Forçar Sync',
                  subtitle: 'Sincroniza dados com a nuvem',
                  color: AppColors.primary,
                  onTap: _forceSyncData,
                ),
                _buildActionTile(
                  icon: Icons.info,
                  title: 'Info do DB',
                  subtitle: 'Mostra estatísticas do banco',
                  color: AppColors.secondary,
                  onTap: _showDatabaseInfo,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seção Alimentos
            _buildSectionCard(
              title: '🥗 Alimentos',
              children: [
                _buildActionTile(
                  icon: Icons.add,
                  title: 'Novo Alimento',
                  subtitle: 'Adiciona um alimento no DB',
                  color: AppColors.success,
                  onTap: _showAddAlimentoDialog,
                ),
                _buildActionTile(
                  icon: Icons.edit,
                  title: 'Editar Alimento',
                  subtitle: 'Modifica um alimento existente',
                  color: AppColors.warning,
                  onTap: _showEditAlimentoDialog,
                ),
                _buildActionTile(
                  icon: Icons.upload,
                  title: 'Importar Mock',
                  subtitle: 'Carrega dados de exemplo',
                  color: AppColors.primary,
                  onTap: _importMockData,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seção Usuário
            _buildSectionCard(
              title: '👤 Usuário',
              children: [
                _buildActionTile(
                  icon: Icons.person_add,
                  title: 'Criar Usuario',
                  subtitle: 'Cria um usuário de teste',
                  color: AppColors.success,
                  onTap: _createTestUser,
                ),
                _buildActionTile(
                  icon: Icons.person_remove,
                  title: 'Limpar Usuario',
                  subtitle: 'Remove dados do usuário',
                  color: AppColors.error,
                  onTap: _clearUserData,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seção Debug
            _buildSectionCard(
              title: '🐛 Debug & Logs',
              children: [
                _buildActionTile(
                  icon: Icons.bug_report,
                  title: 'Logs de Debug',
                  subtitle: 'Mostra logs da aplicação',
                  color: AppColors.secondary,
                  onTap: _showDebugLogs,
                ),
                _buildActionTile(
                  icon: Icons.restore,
                  title: 'Reset App',
                  subtitle: 'Volta ao estado inicial',
                  color: AppColors.error,
                  onTap: _resetApp,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Loading            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildWarningCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo Desenvolvedor',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Use com cuidado! Estas ações podem afetar seus dados.',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(TextTheme textTheme) {
    return DicumeElegantCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _lastAction,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Ações do desenvolvedor
  Future<void> _clearLocalDatabase() async {
    final confirm = await _showConfirmDialog(
      'Limpar Banco de Dados',
      'Tem certeza? Todos os dados locais serão perdidos.',
    );

    if (!confirm) return;

    setState(() => _isLoading = true);

    try {
      final dbService = ref.read(databaseServiceProvider);
      await dbService.clearAlimentos();
      await dbService.clearAllRefeicoesPendentes();

      _setLastAction('✅ Banco de dados limpo com sucesso');
    } catch (e) {
      _setLastAction('❌ Erro ao limpar banco: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _forceSyncData() async {
    setState(() => _isLoading = true);

    try {
      // Por enquanto só simula, já que os métodos específicos não existem ainda
      await Future.delayed(const Duration(seconds: 1));

      _setLastAction('✅ Sincronização simulada concluída');
    } catch (e) {
      _setLastAction('❌ Erro na sincronização: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showDatabaseInfo() async {
    setState(() => _isLoading = true);

    try {
      final dbService = ref.read(databaseServiceProvider);
      final alimentos = await dbService.getAllAlimentos();
      final refeicoes = await dbService.getAllRefeicoes();

      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Informações do Banco'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alimentos: ${alimentos.length}'),
                    Text('Refeições: ${refeicoes.length}'),
                    const SizedBox(height: 8),
                    Text('Versão: ${DateTime.now().toString()}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
        );
      }

      _setLastAction('ℹ️ Informações do banco exibidas');
    } catch (e) {
      _setLastAction('❌ Erro ao buscar informações: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddAlimentoDialog() async {
    // TODO: Implementar dialog para adicionar alimento
    _setLastAction('🚧 Funcionalidade em desenvolvimento');
  }

  Future<void> _showEditAlimentoDialog() async {
    // TODO: Implementar dialog para editar alimento
    _setLastAction('🚧 Funcionalidade em desenvolvimento');
  }

  Future<void> _importMockData() async {
    setState(() => _isLoading = true);

    try {
      // Por enquanto só simula, já que o método específico não existe ainda
      await Future.delayed(const Duration(seconds: 2));

      _setLastAction('✅ Dados mock simulados importados');
    } catch (e) {
      _setLastAction('❌ Erro ao importar dados: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createTestUser() async {
    _setLastAction('🚧 Funcionalidade de usuário em desenvolvimento');
  }

  Future<void> _clearUserData() async {
    _setLastAction('🚧 Funcionalidade de usuário em desenvolvimento');
  }

  Future<void> _showDebugLogs() async {
    _setLastAction('🚧 Sistema de logs em desenvolvimento');
  }

  Future<void> _resetApp() async {
    final confirm = await _showConfirmDialog(
      'Reset Completo',
      'Isso vai limpar TODOS os dados. Tem certeza?',
    );

    if (!confirm) return;

    await _clearLocalDatabase();
    _setLastAction('🔄 App resetado para estado inicial');
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _setLastAction(String action) {
    setState(() {
      _lastAction = action;
    });
    FeedbackService().mediumTap();
  }
}

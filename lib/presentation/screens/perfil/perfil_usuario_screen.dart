import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';
import '../../../core/services/feedback_service.dart';
// ...existing code...
import '../../../core/services/database_service.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/auth_utils.dart';
import '../../controllers/auth_controller.dart';
import 'edit_profile_bottom_sheet.dart';

class PerfilUsuarioScreen extends ConsumerStatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  ConsumerState<PerfilUsuarioScreen> createState() =>
      _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends ConsumerState<PerfilUsuarioScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final textTheme = theme.textTheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          FeedbackService().lightTap();
          // Em vez de só navegar, vamos usar o roteador corretamente
          if (context.mounted) {
            context.go('/home');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text(
            'Perfil',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {
              FeedbackService().lightTap();
              context.go('/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (authState.isAuthenticated) ...[
                _buildPerfilLogado(textTheme, authState),
                const SizedBox(height: 24),
                _buildEstatisticasUsuario(textTheme),
                const SizedBox(height: 24),
                _buildOpcoesConfiguracoes(textTheme, authState),
              ] else ...[
                _buildPerfilDeslogado(textTheme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfilLogado(TextTheme textTheme, AuthState authState) {
    final nomeUsuario = authState.user?.nome ?? 'Usuário DICUMÊ';
    final emailUsuario = authState.user?.email ?? 'Bem-vindo ao app!';

    final avatarUrl = authState.user?.avatarUrl;

    return DicumeElegantCard(
      child: Column(
        children: [
          // Foto e informações básicas
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryLight,
                backgroundImage:
                    (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : null,
                child:
                    (avatarUrl == null || avatarUrl.isEmpty)
                        ? Text(
                          _getIniciais(nomeUsuario),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomeUsuario,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emailUsuario,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Usando o DICUMÊ',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botão editar perfil
          SizedBox(
            width: double.infinity,
            child: DicumeElegantButton(
              text: 'Editar Perfil',
              onPressed: () {
                FeedbackService().lightTap();
                _editarPerfil();
              },
              isOutlined: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticasUsuario(TextTheme textTheme) {
    return DicumeElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Suas Conquistas',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Carregar estatísticas a partir do banco local (Refeições)
          FutureBuilder<List<Refeicoe>>(
            future: ref.read(databaseServiceProvider).getAllRefeicoes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final refeicoes = snapshot.data ?? <Refeicoe>[];

              // Total de refeições registradas
              final totalRefeicoes = refeicoes.length;

              // Calcular dias distintos com refeições e streak atual (dias consecutivos até hoje)
              final dateSet = <DateTime>{};
              for (final r in refeicoes) {
                final d = DateTime(
                  r.dataHora.year,
                  r.dataHora.month,
                  r.dataHora.day,
                );
                dateSet.add(d);
              }

              int streak = 0;
              DateTime day = DateTime.now();
              day = DateTime(day.year, day.month, day.day);
              while (dateSet.contains(day)) {
                streak++;
                day = day.subtract(const Duration(days: 1));
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildEstatisticaCard(
                          icone: Icons.restaurant_menu,
                          valor: totalRefeicoes.toString(),
                          label: 'Refeições\nRegistradas',
                          cor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildEstatisticaCard(
                          icone: Icons.local_fire_department,
                          valor: streak.toString(),
                          label: 'Dias\nConsecutivos',
                          cor: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Meta atual (texto estático por enquanto)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Meta Atual',
                                style: textTheme.titleSmall?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Editar meta',
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.success,
                                size: 20,
                              ),
                              onPressed: () async {
                                // Carregar meta atual
                                final current = await ref
                                    .read(databaseServiceProvider)
                                    .getCacheValue('meta_atual');

                                final controller = TextEditingController(
                                  text: current ?? '',
                                );

                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Editar Meta'),
                                      content: TextField(
                                        controller: controller,
                                        maxLength: 80,
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Ex: Controlar carboidratos em cada refeição',
                                        ),
                                        autofocus: true,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final meta = controller.text.trim();
                                            try {
                                              await ref
                                                  .read(databaseServiceProvider)
                                                  .setCacheValue(
                                                    'meta_atual',
                                                    meta,
                                                  );
                                              await FeedbackService()
                                                  .successFeedback();
                                              Navigator.of(context).pop(true);
                                            } catch (e) {
                                              await FeedbackService()
                                                  .errorFeedback();
                                            }
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<String?>(
                          future: ref
                              .read(databaseServiceProvider)
                              .getCacheValue('meta_atual'),
                          builder: (context, snapMeta) {
                            if (snapMeta.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox(
                                height: 24,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final meta = snapMeta.data;
                            return Text(
                              meta == null || meta.isEmpty
                                  ? 'Defina sua meta para personalizar seu progresso.'
                                  : meta,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticaCard({
    required IconData icone,
    required String valor,
    required String label,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              color: cor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesConfiguracoes(TextTheme textTheme, AuthState authState) {
    return Column(
      children: [
        // Opções do app
        DicumeElegantCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              _buildOpcaoMenu(
                icone: Icons.notifications_outlined,
                titulo: 'Notificações',
                subtitulo: 'Lembretes de refeições',
                onTap: () => _abrirNotificacoes(),
              ),
              _buildDivisor(),

              _buildOpcaoMenu(
                icone: Icons.palette_outlined,
                titulo: 'Tema',
                subtitulo: 'Personalizar aparência',
                onTap: () => _abrirTema(),
              ),
              _buildDivisor(),

              _buildOpcaoMenu(
                icone: Icons.language_outlined,
                titulo: 'Idioma',
                subtitulo: 'Português (Brasil)',
                onTap: () => _abrirIdioma(),
              ),
              _buildDivisor(),

              _buildOpcaoMenu(
                icone: Icons.help_outline,
                titulo: 'Ajuda e Suporte',
                subtitulo: 'Tire suas dúvidas',
                onTap: () => _abrirAjuda(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Opções de conta
        DicumeElegantCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conta',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              _buildOpcaoMenu(
                icone: Icons.privacy_tip_outlined,
                titulo: 'Privacidade',
                subtitulo: 'Política de privacidade',
                onTap: () => _abrirPrivacidade(),
              ),
              _buildDivisor(),

              _buildOpcaoMenu(
                icone: Icons.info_outline,
                titulo: 'Sobre o DICUMÊ',
                subtitulo: 'Versão 1.0.0',
                onTap: () => _abrirSobre(),
              ),
              _buildDivisor(),

              _buildOpcaoMenu(
                icone: Icons.logout,
                titulo: 'Sair da Conta',
                subtitulo: 'Fazer logout',
                onTap: () => _sairConta(),
                corTexto: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerfilDeslogado(TextTheme textTheme) {
    return Column(
      children: [
        DicumeElegantCard(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Bem-vindo ao DICUMÊ!',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Entre ou crie uma conta para sincronizar seus dados e acessar recursos exclusivos.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Botões de login
              SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  text: 'Entrar',
                  onPressed: () {
                    FeedbackService().mediumTap();
                    _fazerLogin();
                  },
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: DicumeElegantButton(
                  text: 'Criar Conta',
                  onPressed: () async {
                    FeedbackService().lightTap();
                    await AuthUtils.requireAuthentication(
                      context,
                      ref,
                      message:
                          'Faça login para criar sua conta e personalizar sua experiência.',
                    );
                  },
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Opções básicas mesmo sem login
        DicumeElegantCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações Básicas',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              _buildOpcaoMenu(
                icone: Icons.help_outline,
                titulo: 'Ajuda e Suporte',
                subtitulo: 'Tire suas dúvidas',
                onTap: () => _abrirAjuda(),
              ),
              _buildDivisor(),
              _buildOpcaoMenu(
                icone: Icons.info_outline,
                titulo: 'Sobre o DICUMÊ',
                subtitulo: 'Versão 1.0.0',
                onTap: () => _abrirSobre(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOpcaoMenu({
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
    Color? corTexto,
  }) {
    return InkWell(
      onTap: () {
        FeedbackService().lightTap();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icone, color: corTexto ?? AppColors.textSecondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: corTexto ?? AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivisor() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: AppColors.outline),
    );
  }

  String _getIniciais(String nome) {
    List<String> nomes = nome.split(' ');
    if (nomes.length >= 2) {
      return '${nomes[0][0]}${nomes[1][0]}'.toUpperCase();
    }
    return nome[0].toUpperCase();
  }

  // Métodos de ação (seriam implementados com navegação real)
  void _editarPerfil() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditProfileBottomSheet(),
    ).then((saved) async {
      // Sempre recarregar o estado de autenticação ao fechar o modal
      try {
        await ref.read(authControllerProvider.notifier).initialize();
      } catch (e) {
        // ignore: avoid_print
        debugPrint('[PERFIL] erro ao reinicializar auth controller: $e');
      }
    });
  }

  void _abrirNotificacoes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir configurações de notificações...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _abrirTema() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir configurações de tema...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _abrirIdioma() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir configurações de idioma...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _abrirAjuda() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir ajuda e suporte...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _abrirPrivacidade() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir política de privacidade...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _abrirSobre() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sobre o DICUMÊ'),
            content: const Text(
              'DICUMÊ é um aplicativo para ajudar no controle do índice glicêmico dos alimentos.\n\nVersão: 1.0.0\nDesenvolvido com ❤️ para sua saúde.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FeedbackService().lightTap();
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }

  void _sairConta() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sair da Conta'),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed: () {
                  FeedbackService().lightTap();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  FeedbackService().mediumTap();
                  Navigator.of(context).pop();

                  // Usar AuthController para realizar signOut e propagar estado
                  try {
                    await ref.read(authControllerProvider.notifier).signOut();
                    // Não navegar: permanecer na tela de perfil. O widget
                    // já faz `ref.watch(authControllerProvider)` e irá
                    // mostrar o estado deslogado automaticamente.
                  } catch (e) {
                    debugPrint(
                      '[PERFIL] Erro ao fazer signOut via controller: $e',
                    );
                    await FeedbackService().errorFeedback();
                  }
                },
                child: const Text(
                  'Sair',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }

  void _fazerLogin() async {
    // Usar o método unificado de login que funciona (apenas Google)
    await AuthUtils.requireAuthentication(
      context,
      ref,
      message: 'Faça login para acessar suas informações de perfil.',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../core/services/api_service.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dicume_elegant_components.dart';

// Formata CEP para 00000-000
class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted;
    if (digits.length <= 5) {
      formatted = digits;
    } else {
      formatted =
          '${digits.substring(0, 5)}-${digits.substring(5, digits.length.clamp(5, 8))}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formata telefone brasileiro (entrada numérica -> (99) 99999-9999 ou (99) 9999-9999)
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = digits;
    if (digits.length <= 2) {
      formatted = digits;
    } else if (digits.length <= 6) {
      formatted = '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      final part1 = digits.substring(0, 2);
      final part2 = digits.substring(2, 6);
      final part3 = digits.substring(6);
      formatted = '($part1) $part2-$part3';
    } else {
      final part1 = digits.substring(0, 2);
      final part2 = digits.substring(2, 7);
      final part3 = digits.substring(7, 11);
      formatted = '($part1) $part2-$part3';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class EditProfileBottomSheet extends ConsumerStatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  ConsumerState<EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState
    extends ConsumerState<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _escolaridadeController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _tempoDiagController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  // Flags / state
  bool _loading = true;
  bool _saving = false;
  bool _cepLoading = false;
  bool _cepNotFound = false;
  bool _cepSearchSuccess = false;
  bool _saveSuccess = false;
  String? _cepSearchError;
  String? _saveError;
  bool _fazAcompanhamento = false;

  @override
  void initState() {
    super.initState();
    _cepController.addListener(_onCepChanged);
    _loadProfile();
  }

  void _onCepChanged() {
    final digits = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 8) {
      // quando completar 8 dígitos, dispara busca
      _buscarCep();
    } else {
      // limpar estado de busca enquanto usuário digita
      if (_cepSearchSuccess || _cepSearchError != null) {
        setState(() {
          _cepSearchSuccess = false;
          _cepSearchError = null;
        });
      }
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final api = ApiService();
      final resp = await api.getUserProfile();
      if (resp.success && resp.data != null) {
        final profile = resp.data!;
        _nomeController.text = profile.nomeExibicao ?? '';
        _dataNascimentoController.text = profile.dataNascimento ?? '';
        _generoController.text = profile.genero ?? '';
        _escolaridadeController.text = profile.escolaridade ?? '';
        _cidadeController.text = profile.cidade ?? '';
        _bairroController.text = profile.bairro ?? '';
        _telefoneController.text = profile.telefone ?? '';
        _tempoDiagController.text = profile.tempoDiagnosticoDm2 ?? '';
        _fazAcompanhamento = profile.fazAcompanhamentoMedico ?? false;
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[EDIT_PROFILE] erro ao carregar perfil: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveError = null;
      _saveSuccess = false;
    });
    try {
      final api = ApiService();
      // Garantir que a data seja enviada no formato ISO (YYYY-MM-DD).
      // O DatePicker local exibe DD/MM/YYYY, mas o backend provavelmente
      // espera YYYY-MM-DD ou um tipo date compatível com o banco.
      String dataNascimentoForApi = _dataNascimentoController.text.trim();
      if (dataNascimentoForApi.isNotEmpty &&
          dataNascimentoForApi.contains('/')) {
        final parts = dataNascimentoForApi.split('/');
        if (parts.length == 3) {
          final day = parts[0].padLeft(2, '0');
          final month = parts[1].padLeft(2, '0');
          final year = parts[2];
          dataNascimentoForApi = '$year-$month-$day';
        }
      }

      final payload = {
        'nome_exibicao': _nomeController.text.trim(),
        'data_nascimento': dataNascimentoForApi,
        'genero': _generoController.text.trim(),
        'escolaridade': _escolaridadeController.text.trim(),
        'tempo_diagnostico_dm2': _tempoDiagController.text.trim(),
        'faz_acompanhamento_medico': _fazAcompanhamento,
        'telefone': _telefoneController.text.trim(),
        'cidade': _cidadeController.text.trim(),
        'bairro': _bairroController.text.trim(),
      }..removeWhere((k, v) => (v is String && v.isEmpty));

      final result = await api.updateUserProfile(payload);
      if (result.success) {
        // Recarregar estado de auth para refletir possíveis mudanças no usuário
        try {
          // usar ref se disponível; este Widget é ConsumerStatefulWidget
          await ref.read(authControllerProvider.notifier).initialize();
        } catch (_) {}
        setState(() {
          _saveSuccess = true;
          _saveError = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso')),
          );
        }
        Navigator.of(context).pop(true);
        return;
      } else {
        setState(() {
          _saveError = result.error ?? 'Erro ao salvar perfil';
          _saveSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        _saveError = 'Erro ao salvar perfil: $e';
        _saveSuccess = false;
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate() async {
    DateTime? initial;
    try {
      if (_dataNascimentoController.text.isNotEmpty) {
        initial = DateTime.parse(_dataNascimentoController.text);
      }
    } catch (_) {
      initial = DateTime.now().subtract(const Duration(days: 365 * 30));
    }
    final picked = await showDatePicker(
      context: context,
      initialDate:
          initial ?? DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      String two(int n) => n < 10 ? '0$n' : '$n';
      final day = two(picked.day);
      final month = two(picked.month);
      final year = picked.year.toString();
      _dataNascimentoController.text = '$day/$month/$year';
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _generoController.dispose();
    _escolaridadeController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _tempoDiagController.dispose();
    _cepController.removeListener(_onCepChanged);
    _cepController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usar SafeArea + SingleChildScrollView e remover margens laterais aplicando
    // background transparente no showModalBottomSheet (já feito no caller).
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Material(
          color: AppColors.surface,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child:
              _loading
                  ? SizedBox(
                    height: 220,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Carregando perfil...',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : ConstrainedBox(
                    // permitir que o bottomsheet tenha altura conforme conteúdo, mas limitar ao máximo da tela
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.95,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header (estilo similar ao AuthModal)
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey300,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  icon: const Icon(Icons.close),
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 56,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Editar perfil',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildTextField(
                                    controller: _nomeController,
                                    label: 'Nome de exibição',
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Nome obrigatório';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTextField(
                                    controller: _telefoneController,
                                    label: 'Telefone',
                                    hint: '(99) 99999-9999',
                                    keyboardType: TextInputType.phone,
                                    validator: (v) {
                                      // telefone opcional: validar apenas se preenchido
                                      if (v != null && v.trim().isNotEmpty) {
                                        final digits = v.replaceAll(
                                          RegExp(r'[^0-9]'),
                                          '',
                                        );
                                        if (digits.length < 10) {
                                          return 'Telefone inválido';
                                        }
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      PhoneInputFormatter(),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Data de nascimento: abrir DatePicker ao tocar
                                  TextFormField(
                                    controller: _dataNascimentoController,
                                    readOnly: true,
                                    onTap: _pickDate,
                                    decoration: InputDecoration(
                                      labelText: 'Data de nascimento',
                                      hintText: 'DD/MM/YYYY',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                    ),
                                    validator: (v) {
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  // Dropdown Gênero
                                  _buildDropdown<String>(
                                    value:
                                        _generoController.text.isEmpty
                                            ? null
                                            : _generoController.text,
                                    label: 'Gênero',
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'masculino',
                                        child: Text('Masculino'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'feminino',
                                        child: Text('Feminino'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'outro',
                                        child: Text('Outro'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'prefiro_nao_dizer',
                                        child: Text('Prefiro não dizer'),
                                      ),
                                    ],
                                    onChanged:
                                        (v) => setState(
                                          () =>
                                              _generoController.text = v ?? '',
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Dropdown Escolaridade
                                  _buildDropdown<String>(
                                    value:
                                        _escolaridadeController.text.isEmpty
                                            ? null
                                            : _escolaridadeController.text,
                                    label: 'Escolaridade',
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'fundamental',
                                        child: Text('Ensino Fundamental'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'medio',
                                        child: Text('Ensino Médio'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'superior',
                                        child: Text('Ensino Superior'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'pos',
                                        child: Text('Pós-graduação'),
                                      ),
                                    ],
                                    onChanged:
                                        (v) => setState(
                                          () =>
                                              _escolaridadeController.text =
                                                  v ?? '',
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _cepController,
                                          label: 'CEP',
                                          hint: '00000-000',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            CepInputFormatter(),
                                          ],
                                          validator: (v) {
                                            if (_cepController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _cepNotFound) {
                                              return null;
                                            }
                                            final digits =
                                                v?.replaceAll(
                                                  RegExp(r'[^0-9]'),
                                                  '',
                                                ) ??
                                                '';
                                            if (digits.length != 8) {
                                              return 'CEP inválido';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 200,
                                        child:
                                            _cepLoading
                                                ? Center(
                                                  child: SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                )
                                                : (_cepSearchSuccess
                                                    ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'CEP encontrado',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          value: _cepNotFound,
                                                          onChanged:
                                                              (v) => setState(
                                                                () =>
                                                                    _cepNotFound =
                                                                        v ??
                                                                        false,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        const Expanded(
                                                          child: Text(
                                                            'Não encontrei meu CEP',
                                                          ),
                                                        ),
                                                        if (_cepSearchError !=
                                                            null) ...[
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              _cepSearchError ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: _cidadeController,
                                    label: 'Cidade',
                                    validator: (v) {
                                      if (_cepNotFound &&
                                          (v == null || v.trim().isEmpty)) {
                                        return 'Informe a cidade';
                                      }
                                      return null;
                                    },
                                    enabled: _cepNotFound,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTextField(
                                    controller: _bairroController,
                                    label: 'Bairro',
                                    validator: (v) {
                                      if (_cepNotFound &&
                                          (v == null || v.trim().isEmpty)) {
                                        return 'Informe o bairro';
                                      }
                                      return null;
                                    },
                                    enabled: _cepNotFound,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Faz acompanhamento médico?'),
                                      Switch(
                                        value: _fazAcompanhamento,
                                        onChanged:
                                            (v) => setState(
                                              () => _fazAcompanhamento = v,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: DicumeElegantButton(
                                      text:
                                          _saving
                                              ? 'Salvando...'
                                              : 'Salvar alterações',
                                      onPressed: _saving ? null : _save,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // feedback inline do salvamento
                                  if (_saveSuccess)
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Dados salvos com sucesso',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    )
                                  else if (_saveError != null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            _saveError ?? '',
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String label,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _buscarCep() async {
    final raw = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.length != 8) {
      setState(() {
        _cepSearchSuccess = false;
        _cepSearchError = 'Informe um CEP válido de 8 dígitos';
      });
      return;
    }
    setState(() {
      _cepLoading = true;
      _cepNotFound = false;
      _cepSearchError = null;
      _cepSearchSuccess = false;
    });
    try {
      final api = ApiService();
      final resp = await api.buscarCep(raw);
      if (!resp.success || resp.data == null) {
        setState(() {
          _cepNotFound = true;
          _cepSearchSuccess = false;
          _cepSearchError = 'CEP não encontrado';
        });
      } else {
        final data = resp.data!;
        setState(() {
          _cidadeController.text = data['localidade'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _cepSearchSuccess = true;
          _cepSearchError = null;
        });
      }
    } catch (e) {
      setState(() {
        _cepNotFound = true;
        _cepSearchSuccess = false;
        _cepSearchError = 'Erro ao buscar CEP';
      });
    } finally {
      setState(() => _cepLoading = false);
    }
  }
}

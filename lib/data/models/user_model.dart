import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_first_login', defaultValue: true)
  final bool isFirstLogin;
  final UserPreferencesModel preferences;

  const UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isFirstLogin = true,
    required this.preferences, // Removido o valor padrão aqui
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userMetadata = json['user_metadata'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'] as String,
      nome: userMetadata?['full_name'] as String? ?? '',
      email: json['email'] as String,
      telefone: json['phone'] as String?,
      avatarUrl: userMetadata?['avatar_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isFirstLogin: json['is_first_login'] as bool? ?? true,
      preferences: json['preferences'] == null
          ? UserPreferencesModel.defaultPreferences
          : UserPreferencesModel.fromJson(json['preferences'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      nome: nome,
      email: email,
      telefone: telefone,
      avatarUrl: avatarUrl,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      isFirstLogin: isFirstLogin,
      preferences: preferences.toEntity(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nome: user.nome,
      email: user.email,
      telefone: user.telefone,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt.toIso8601String(),
      updatedAt: user.updatedAt.toIso8601String(),
      isFirstLogin: user.isFirstLogin,
      preferences: UserPreferencesModel.fromEntity(user.preferences),
    );
  }
}

@JsonSerializable()
class UserPreferencesModel {
  @JsonKey(name: 'notificacoes_ativas', defaultValue: true)
  final bool notificacoesAtivas;
  @JsonKey(name: 'hora_lembrete_almoco', defaultValue: 12)
  final int horaLembreteAlmoco;
  @JsonKey(name: 'hora_lembrete_jantar', defaultValue: 19)
  final int horaLembreteJantar;
  @JsonKey(name: 'lembrar_agua', defaultValue: true)
  final bool lembrarAgua;
  @JsonKey(name: 'usar_semaforo', defaultValue: true)
  final bool usarSemaforo;
  @JsonKey(name: 'tamanho_fonte', defaultValue: 1.0)
  final double tamanhoFonte;
  @JsonKey(name: 'contraste_alto', defaultValue: false)
  final bool contrasteAlto;

  const UserPreferencesModel({
    this.notificacoesAtivas = true,
    this.horaLembreteAlmoco = 12,
    this.horaLembreteJantar = 19,
    this.lembrarAgua = true,
    this.usarSemaforo = true,
    this.tamanhoFonte = 1.0,
    this.contrasteAlto = false,
  });

  static const UserPreferencesModel defaultPreferences = UserPreferencesModel();

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);

  UserPreferences toEntity() {
    return UserPreferences(
      notificacoesAtivas: notificacoesAtivas,
      horaLembreteAlmoco: horaLembreteAlmoco,
      horaLembreteJantar: horaLembreteJantar,
      lembrarAgua: lembrarAgua,
      usarSemaforo: usarSemaforo,
      tamanhoFonte: tamanhoFonte,
      contrasteAlto: contrasteAlto,
    );
  }

  factory UserPreferencesModel.fromEntity(UserPreferences preferences) {
    return UserPreferencesModel(
      notificacoesAtivas: preferences.notificacoesAtivas,
      horaLembreteAlmoco: preferences.horaLembreteAlmoco,
      horaLembreteJantar: preferences.horaLembreteJantar,
      lembrarAgua: preferences.lembrarAgua,
      usarSemaforo: preferences.usarSemaforo,
      tamanhoFonte: preferences.tamanhoFonte,
      contrasteAlto: preferences.contrasteAlto,
    );
  }
}

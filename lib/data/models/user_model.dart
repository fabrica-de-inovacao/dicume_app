import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_first_login')
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
    required this.isFirstLogin,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

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
  @JsonKey(name: 'notificacoes_ativas')
  final bool notificacoesAtivas;
  @JsonKey(name: 'hora_lembrete_almoco')
  final int horaLembreteAlmoco;
  @JsonKey(name: 'hora_lembrete_jantar')
  final int horaLembreteJantar;
  @JsonKey(name: 'lembrar_agua')
  final bool lembrarAgua;
  @JsonKey(name: 'usar_semaforo')
  final bool usarSemaforo;
  @JsonKey(name: 'tamanho_fonte')
  final double tamanhoFonte;
  @JsonKey(name: 'contraste_alto')
  final bool contrasteAlto;

  const UserPreferencesModel({
    required this.notificacoesAtivas,
    required this.horaLembreteAlmoco,
    required this.horaLembreteJantar,
    required this.lembrarAgua,
    required this.usarSemaforo,
    required this.tamanhoFonte,
    required this.contrasteAlto,
  });

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

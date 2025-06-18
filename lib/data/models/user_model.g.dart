// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isFirstLogin: json['is_first_login'] as bool,
      preferences: UserPreferencesModel.fromJson(
          json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      'telefone': instance.telefone,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_first_login': instance.isFirstLogin,
      'preferences': instance.preferences,
    };

UserPreferencesModel _$UserPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    UserPreferencesModel(
      notificacoesAtivas: json['notificacoes_ativas'] as bool,
      horaLembreteAlmoco: (json['hora_lembrete_almoco'] as num).toInt(),
      horaLembreteJantar: (json['hora_lembrete_jantar'] as num).toInt(),
      lembrarAgua: json['lembrar_agua'] as bool,
      usarSemaforo: json['usar_semaforo'] as bool,
      tamanhoFonte: (json['tamanho_fonte'] as num).toDouble(),
      contrasteAlto: json['contraste_alto'] as bool,
    );

Map<String, dynamic> _$UserPreferencesModelToJson(
        UserPreferencesModel instance) =>
    <String, dynamic>{
      'notificacoes_ativas': instance.notificacoesAtivas,
      'hora_lembrete_almoco': instance.horaLembreteAlmoco,
      'hora_lembrete_jantar': instance.horaLembreteJantar,
      'lembrar_agua': instance.lembrarAgua,
      'usar_semaforo': instance.usarSemaforo,
      'tamanho_fonte': instance.tamanhoFonte,
      'contraste_alto': instance.contrasteAlto,
    };

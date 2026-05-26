// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'nome': instance.nome,
  'email': instance.email,
  'telefone': instance.telefone,
  'avatarUrl': instance.avatarUrl,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'is_first_login': instance.isFirstLogin,
  'preferences': instance.preferences,
};

UserPreferencesModel _$UserPreferencesModelFromJson(
  Map<String, dynamic> json,
) => UserPreferencesModel(
  notificacoesAtivas: json['notificacoes_ativas'] as bool? ?? true,
  horaLembreteAlmoco: (json['hora_lembrete_almoco'] as num?)?.toInt() ?? 12,
  horaLembreteJantar: (json['hora_lembrete_jantar'] as num?)?.toInt() ?? 19,
  lembrarAgua: json['lembrar_agua'] as bool? ?? true,
  usarSemaforo: json['usar_semaforo'] as bool? ?? true,
  tamanhoFonte: (json['tamanho_fonte'] as num?)?.toDouble() ?? 1.0,
  contrasteAlto: json['contraste_alto'] as bool? ?? false,
);

Map<String, dynamic> _$UserPreferencesModelToJson(
  UserPreferencesModel instance,
) => <String, dynamic>{
  'notificacoes_ativas': instance.notificacoesAtivas,
  'hora_lembrete_almoco': instance.horaLembreteAlmoco,
  'hora_lembrete_jantar': instance.horaLembreteJantar,
  'lembrar_agua': instance.lembrarAgua,
  'usar_semaforo': instance.usarSemaforo,
  'tamanho_fonte': instance.tamanhoFonte,
  'contraste_alto': instance.contrasteAlto,
};

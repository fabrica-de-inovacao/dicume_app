import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFirstLogin;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isFirstLogin = false,
    required this.preferences,
  });

  @override
  List<Object?> get props => [
    id,
    nome,
    email,
    telefone,
    avatarUrl,
    createdAt,
    updatedAt,
    isFirstLogin,
    preferences,
  ];

  User copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFirstLogin,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserPreferences extends Equatable {
  final bool notificacoesAtivas;
  final int horaLembreteAlmoco; // Hora em formato 24h (ex: 12 para 12:00)
  final int horaLembreteJantar; // Hora em formato 24h (ex: 19 para 19:00)
  final bool lembrarAgua;
  final bool usarSemaforo;
  final double tamanhoFonte; // Multiplicador de 1.0 a 2.0
  final bool contrasteAlto;

  const UserPreferences({
    this.notificacoesAtivas = true,
    this.horaLembreteAlmoco = 12,
    this.horaLembreteJantar = 19,
    this.lembrarAgua = true,
    this.usarSemaforo = true,
    this.tamanhoFonte = 1.0,
    this.contrasteAlto = false,
  });

  @override
  List<Object?> get props => [
    notificacoesAtivas,
    horaLembreteAlmoco,
    horaLembreteJantar,
    lembrarAgua,
    usarSemaforo,
    tamanhoFonte,
    contrasteAlto,
  ];

  UserPreferences copyWith({
    bool? notificacoesAtivas,
    int? horaLembreteAlmoco,
    int? horaLembreteJantar,
    bool? lembrarAgua,
    bool? usarSemaforo,
    double? tamanhoFonte,
    bool? contrasteAlto,
  }) {
    return UserPreferences(
      notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
      horaLembreteAlmoco: horaLembreteAlmoco ?? this.horaLembreteAlmoco,
      horaLembreteJantar: horaLembreteJantar ?? this.horaLembreteJantar,
      lembrarAgua: lembrarAgua ?? this.lembrarAgua,
      usarSemaforo: usarSemaforo ?? this.usarSemaforo,
      tamanhoFonte: tamanhoFonte ?? this.tamanhoFonte,
      contrasteAlto: contrasteAlto ?? this.contrasteAlto,
    );
  }
}

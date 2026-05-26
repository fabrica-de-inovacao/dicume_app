# DICUMÊ - Análise Completa do Projeto

## 📋 Visão Geral

**DICUMÊ** é um aplicativo educacional nutricional para pessoas com diabetes tipo 2 em **Imperatriz-MA (Maranhão, Brasil)**.  
Desenvolvido em **Flutter** com **Clean Architecture**, focado em acessibilidade (60+ anos), regionalização nordestina e funcionalidade **offline-first**.

---

## 🏗️ Stack Tecnológico

| Componente | Tecnologia |
|---|---|
| **Framework** | Flutter 3.24+ (SDK ^3.7.2) |
| **Linguagem** | Dart 3.7+ |
| **Gerenciamento de Estado** | Riverpod + riverpod_annotation (codegen) |
| **Navegação** | GoRouter 15.x (ShellRoute + bottom nav) |
| **Banco Local** | Drift (SQLite) - 5 tabelas |
| **HTTP Client** | Dio + interceptors + pretty_dio_logger |
| **Autenticação** | Google Sign-In + JWT Decoder |
| **Armazenamento Seguro** | flutter_secure_storage |
| **Animações** | Lottie + flutter_animate |
| **Fontes** | Google Fonts (Montserrat) |
| **Funcional** | dartz (Either), equatable, json_annotation |
| **Feedback** | vibration + audioplayers |
| **Conectividade** | connectivity_plus |
| **Cache Imagens** | cached_network_image, shimmer |
| **Codegen** | build_runner, riverpod_generator, drift_dev, json_serializable |

---

## 📁 Estrutura do Projeto (Clean Architecture)

```
dicume_app/
├── lib/
│   ├── main.dart                          # Entry point, ProviderScope, rotas
│   ├── core/                              # Núcleo compartilhado
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # Config globais (URL API, timeouts, etc.)
│   │   │   ├── api_endpoints.dart         # Endpoints REST
│   │   │   └── animation_constants.dart   # Durações e curvas
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # Paleta refinada (marrom terroso, azul, semáforo)
│   │   │   ├── app_theme.dart             # ThemeData Material 3 completo
│   │   │   └── app_text_styles.dart       # Tipografia Montserrat
│   │   ├── router/
│   │   │   └── app_router.dart            # GoRouter: 12+ rotas, ShellRoute com bottom nav
│   │   ├── services/
│   │   │   ├── auth_service.dart          # Singleton: Google Sign-In, secure storage
│   │   │   ├── http_service.dart          # Dio wrapper + interceptors (token, erro)
│   │   │   ├── api_service.dart           # Chamadas de alto nível à API (perfil, refeições)
│   │   │   ├── feedback_service.dart      # Vibração + sons táteis (acessibilidade)
│   │   │   ├── sync_service.dart          # Sync automático periódico + connectivity listener
│   │   │   ├── database_service.dart      # Wrapper Drift para todas as tabelas
│   │   │   ├── mock_data_service.dart     # [VAZIO]
│   │   │   ├── mock_data_service_regional.dart  # Mock completo: 20 alimentos regionais
│   │   │   └── super_mock_data_service.dart    # [VAZIO]
│   │   ├── database/
│   │   │   ├── database.dart             # Schema Drift: 5 tabelas + migrations
│   │   │   └── database.g.dart           # Generated
│   │   ├── providers/
│   │   │   └── feedback_providers.dart    # Provider FeedbackService
│   │   ├── utils/
│   │   │   ├── alimento_display_helper.dart  # Helpers: cores, URLs, formatação
│   │   │   ├── auth_utils.dart            # requireAuthentication() utilitário
│   │   │   └── dicume_animations.dart    # [VAZIO]
│   │   ├── components/
│   │   │   └── dicume_components.dart    # [VAZIO]
│   │   └── widgets/
│   │       ├── dicume_elegant_components.dart  # ~400+ linhas: cards, botões, chips, modais
│   │       ├── dicume_modern_components.dart   # [VAZIO]
│   │       └── dicume_super_modern_components.dart  # [VAZIO]
│   ├── data/                              # Camada de dados
│   │   ├── datasources/
│   │   │   ├── auth_local_datasource.dart      # SecureStorage: cache user + token
│   │   │   ├── auth_remote_datasource.dart     # API: /auth/google, signout, refresh
│   │   │   ├── alimento_remote_datasource.dart # API: /dados/alimentos
│   │   │   └── refeicao_remote_datasource.dart # API: /diario/alimentos
│   │   ├── models/
│   │   │   ├── auth_model.dart            # AuthTokenModel + LoginRequestModel
│   │   │   ├── auth_response_model.dart   # AuthResponseModel (token + usuario)
│   │   │   ├── user_model.dart            # UserModel + UserPreferencesModel
│   │   │   ├── alimento_model.dart        # AlimentoModel (JSON ⇄ Entity)
│   │   │   ├── refeicao_pendente_model.dart # Refeição pendente + API request
│   │   │   ├── refeicao_do_dia_model.dart # Refeição do dia + itens + UI props
│   │   │   └── perfil_status_model.dart   # PerfilStatusModel + UltimaRefeicaoModel
│   │   ├── repositories/
│   │   │   ├── auth_repository_impl.dart     # GoogleAuth → API → cache local
│   │   │   ├── alimento_repository_impl.dart # API sync → Drift local → entities
│   │   │   └── refeicao_repository_impl.dart # Offline queue → API sync
│   │   └── providers/
│   │       ├── auth_providers.dart         # Riverpod: Dio, GoogleSignIn, Storage, Repo, UseCases
│   │       ├── alimento_providers.dart     # Riverpod + riverpod_annotation: cache alimentos
│   │       └── refeicao_providers.dart     # Riverpod: offline queue, sync, perfil status
│   ├── domain/                            # Regras de negócio (puro Dart)
│   │   ├── entities/
│   │   │   ├── user.dart                  # User + UserPreferences (Equatable)
│   │   │   ├── auth.dart                  # AuthCredential, AuthToken, LoginRequest
│   │   │   ├── alimento.dart              # Alimento + ClassificacaoCor enum + GrupoDicume enum
│   │   │   ├── alimento_simples.dart      # AlimentoSimples (mock inline)
│   │   │   ├── grupo_alimento.dart        # GrupoAlimento: 8 grupos regionais
│   │   │   ├── refeicao.dart              # RefeicaoPendente + ItemRefeicaoPendente + TipoRefeicao
│   │   │   ├── item_prato.dart            # [VAZIO]
│   │   │   ├── prato.dart                 # [VAZIO]
│   │   │   ├── medida_caseira.dart        # [VAZIO]
│   │   │   └── failures.dart              # AuthFailure hierarquia (12+ tipos)
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart        # Interface: signIn, signOut, getCurrentUser, etc.
│   │   │   ├── alimento_repository.dart    # Interface: CRUD alimentos + sync + cache
│   │   │   └── refeicao_repository.dart    # Interface: offline queue + sync
│   │   └── usecases/
│   │       ├── sign_in_with_google_usecase.dart
│   │       ├── sign_out_usecase.dart
│   │       ├── is_authenticated_usecase.dart
│   │       └── get_current_user_usecase.dart
│   └── presentation/                      # Interface do usuário
│       ├── controllers/
│       │   ├── auth_controller.dart        # Riverpod @riverpod: AuthState (initial/loading/authenticated/error)
│       │   └── auth_controller.g.dart      # Generated
│       ├── providers/
│       │   └── prato_providers.dart        # [VAZIO]
│       ├── screens/
│       │   ├── splash/splash_screen.dart   # Animated logo → onboarding/home
│       │   ├── onboarding/onboarding_screen.dart  # 3 páginas de boas-vindas
│       │   ├── auth/auth_modal_screen.dart # Modal login Google
│       │   ├── main/main_navigation_screen.dart  # BottomNavigationBar: Buscar|Início|Meu Dia|Aprender
│       │   ├── home/home_screen_elegante.dart    # Home: CTA, semáforo, carrossel, dicas
│       │   ├── buscar/buscar_alimento_screen.dart # Busca com debounce + filtros + grid
│       │   ├── montar_prato/
│       │   │   ├── montar_prato_virtual_screen.dart  # Tela principal "Montar Prato"
│       │   │   ├── selecionar_grupo_screen.dart
│       │   │   └── widgets/
│       │   │       ├── summary_bottom_sheet.dart  # Resumo + SlideToConfirm
│       │   │       └── slide_to_confirm.dart       # Componente deslizar para confirmar
│       │   ├── meu_dia/meu_dia_screen.dart   # Diário de refeições do dia
│       │   ├── historico/historico_screen_v3.dart  # Histórico mockado
│       │   ├── aprender/aprender_screen.dart       # "Em Construção"
│       │   ├── perfil/
│       │   │   ├── perfil_screen_v3.dart           # Perfil, preferências, conquistas
│       │   │   ├── perfil_usuario_screen.dart
│       │   │   └── edit_profile_bottom_sheet.dart
│       │   ├── setup/
│       │   │   ├── setup_loading_screen.dart
│       │   │   └── setup_loading_screen_simple.dart
│       │   └── developer/developer_screen.dart
│       └── widgets/
│           ├── home_banner_carousel.dart          # Carrossel automático 3 banners
│           └── alimento_details_bottom_sheet.dart # Modal detalhes + seletor quantidade
├── assets/
│   ├── icons/                   # app_icon.png, foreground, background
│   └── lottie/                  # plate_empty.json, cooking.json, celebration.json
├── alimentos_completos_versao_final.json  # 1219 linhas: dados completos de alimentos
├── android/
├── ios/
├── pubspec.yaml
├── README.md
└── LICENSE (MIT)
```

---

## 🎯 Funcionalidades Core

### 1. Autenticação (Google Sign-In)
- Login via Google com `serverClientId`
- Persistência segura em `flutter_secure_storage`
- JWT decode para verificação de expiração
- Stream de estado de autenticação (realtime)
- Sistema de "primeiro acesso" → onboarding

### 2. Semáforo Nutricional
- Classificação **verde/amarelo/vermelho** baseada em IG
- Alimentos "PODE COMER A VONTADE" / "COM MODERAÇÃO" / "EVITAR"
- Feedback visual com animações, gradientes e cores
- Cards com indicadores animados

### 3. Montar Prato
- Seleção visual de alimentos por grupos regionais (8 grupos)
- Medidas caseiras regionais (ex: colheres de sopa, unidades)
- Seletor de quantidade com botões +/-
- Slide to confirm para finalizar
- Resumo da refeição com classificações

### 4. Offline-First
- Drift/SQLite local para alimentos (cache 24h)
- Queue de refeições pendentes com sync automático
- SyncService com listener de conectividade
- Sincronização periódica a cada 5 minutos
- Fallback para dados mock quando offline

### 5. Acessibilidade (WCAG AA)
- `FeedbackService`: vibração + som para interações
- Touch targets mínimos de 48x48dp
- Texto escalável (0.8x a 2.0x)
- Cores de alto contraste disponíveis
- Feedback tátil para semáforo (verde=leve, amarelo=médio, vermelho=forte)

---

## 🗄️ Banco de Dados (Drift/SQLite) - 5 Tabelas

| Tabela | Descrição |
|---|---|
| **Alimentos** | id, nome, categoria, carboidratos, proteinas, gorduras, calorias, IG, isFavorito |
| **Refeicoes** | id, nome, tipo, dataHora, totais nutricionais, observacoes |
| **ItensRefeicao** | id, refeicaoId (FK), alimentoId (FK), quantidade, macros |
| **CacheApi** | key, data, expiresAt (cache genérico de API) |
| **RefeicoesPendentes** | id, tipoRefeicao, dataRefeicao, itensJson, isSyncing, syncAttempts |

---

## 🌐 API REST - Endpoints

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/` | Health check |
| POST | `/auth/google` | Login Google (body: `token_google`) |
| POST | `/auth/logout` | Logout |
| POST | `/auth/refresh-token` | Refresh JWT |
| GET | `/dados/alimentos` | Lista completa de alimentos |
| POST | `/diario/alimentos` | Enviar refeição |
| GET | `/diario/refeicoes/{data}` | Refeições por data |
| GET | `/perfil/status` | Status do perfil do usuário |
| PUT | `/users/{id}` | Atualizar usuário |
| Base URL | `http://189.90.44.226:5050/api/v1` | Servidor |

---

## 🎨 Design System

### Paleta de Cores
- **Primary**: Marrom Terroso `#6D4C41` (raízes maranhenses)
- **Secondary**: Azul Vibrante `#2196F3` (céu/mar)
- **Background**: Off-white `#FAFAFA`
- **Semáforo**: Verde `#4CAF50` | Laranja `#FF9800` | Vermelho `#F44336`
- **Tipografia**: Montserrat (Google Fonts)

### Design Tokens
- `borderRadius`: 12.0 (constante)
- `buttonHeight`: 56.0
- `minTouchTarget`: 48.0
- Sombras: softShadow, mediumShadow, strongShadow
- Gradientes: subtleGradient, successGradient, warningGradient, dangerGradient

### Componentes Elegantes (DicumeElegantComponents)
- `DicumeBottomNavigationBar` - Bottom nav com 4 itens + ícones animados
- `DicumeElegantCard` - Card com borderRadius 16, sombras suaves
- `DicumeElegantButton` - Botão principal/secundário/outlined
- `DicumeElegantAppBar` - AppBar padronizada
- `DicumeElegantChip` - Chip com cor personalizada
- `DicumeSemaforoNutricional` - Indicador visual do semáforo
- `DicumeEmptyState` - Estado vazio com Lottie animation
- `DicumeElegantModalSheet` - Modal sheet padronizada

---

## 🔄 Fluxo de Dados

1. **App inicia** → `main()` → ProviderScope → SplashScreen
2. **Splash** → verifica `isFirstLaunch()` → onboarding OU home
3. **Home** → `alimentosCacheProvider` inicializa cache Drift
4. **Login** → GoogleSignIn → API `/auth/google` → secure storage
5. **Montar Prato** → seleciona alimentos → salva refeição → queue offline → sync API
6. **Meu Dia** → API `/diario/refeicoes/{data}` → exibe refeições com semáforo
7. **Sync automático** → monitora connectivity → sync pendentes a cada 5min

---

## 🧩 Padrões Arquiteturais

### Clean Architecture (3 camadas)
- **Domain**: Entidades puras + interfaces de repositório + use cases
- **Data**: Implementações de repositório + datasources (remote/local) + models (JSON)
- **Presentation**: Screens (Widgets) + Controllers (Riverpod) + Providers

### Riverpod State Management
- `@riverpod` annotation para codegen
- `AuthController` (Notifier): `AuthState` com status `initial/loading/authenticated/unauthenticated/error`
- `AlimentosCache` (AsyncNotifier): cache de alimentos com sync automático
- `OfflineQueue` (AsyncNotifier): queue de refeições pendentes
- `SyncStatus` (Notifier): estado de sincronização
- Providers para dependências: `dioProvider`, `googleSignInProvider`, etc.

### Error Handling
- `dartz` `Either<Failure, Success>` em todos os repositórios
- Hierarquia `AuthFailure` com 12+ subtipos
- `AppException` com enum de tipos (network, auth, server, etc.)
- Tratamento de erro HTTP 401 no interceptor Dio

---

## 📝 Observações

### Arquivos Vazios (a implementar)
- `lib/domain/entities/item_prato.dart` - Placeholder
- `lib/domain/entities/prato.dart` - Placeholder
- `lib/domain/entities/medida_caseira.dart` - Placeholder
- `lib/presentation/providers/prato_providers.dart` - Placeholder
- `lib/core/services/mock_data_service.dart` - Vazio
- `lib/core/services/super_mock_data_service.dart` - Vazio
- `lib/core/utils/dicume_animations.dart` - Vazio
- `lib/core/components/dicume_components.dart` - Vazio
- `lib/core/widgets/dicume_modern_components.dart` - Vazio
- `lib/core/widgets/dicume_super_modern_components.dart` - Vazio

### Telas "Em Construção"
- `AprenderScreen` - Conteúdo educativo (placeholder)
- `DeveloperScreen` - Debug/developer tools

### Fluxo SMS
- SMS authentication foi completamente removido do código (comentários indicam "removed")

### Base URL
- API rodando em `http://189.90.44.226:5050/api/v1`
- Ambiente de desenvolvimento ativo

---

## 📊 Métricas de Qualidade (Targets)

| Métrica | Target |
|---|---|
| Startup | <3s em low-end |
| Navegação | <500ms entre telas |
| Memória | <200MB |
| Build Size | <50MB (Android) |
| Acessibilidade | WCAG AA |
| Offline | 100% core features |

---

## 👤 Desenvolvedor

**Vinícius Schneider**  
Projeto: DICUMÊ - Imperatriz/MA  
Educação nutricional para a comunidade diabética local

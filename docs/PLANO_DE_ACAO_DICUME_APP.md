# 📋 PLANO DE AÇÃO - DICUMÊ Flutter App

**Projeto:** Aplicativo móvel DICUMÊ para educação nutricional  
**Tecnologia:** Flutter + FVM + Riverpod + Isar + Lottie  
**Público-alvo:** Pessoas com diabetes tipo 2 em Imperatriz-MA  
**Estimativa:** 25 dias de desenvolvimento  
**Última Atualização:** 17/06/2025

---

## 📊 PROGRESSO GERAL

**STATUS ATUAL: 🟡 EM PROGRESSO** | **Dias decorridos:** 1 | **Progresso:** ~35%

### ✅ FASES CONCLUÍDAS

- **Fase 1:** Setup e Estrutura Base (100%)
- **Fase 2:** Theme e Design System (100%)
- **Fase 3:** Autenticação (75% - Backend completo, falta telas finais)

### 🔄 EM PROGRESSO

- **Fase 4:** Cache Local e Offline (0%)

### ⏳ PENDENTES

- Fases 5-11 (Navegação, Core Features, Polimento)

---

## 🎯 OBJETIVOS PRINCIPAIS

- ✅ App offline-first com sincronização inteligente
- ✅ Interface acessível para usuários 60+ com baixa literacia digital
- ✅ Sistema de "semáforo nutricional" visual e imediato
- ✅ Regionalização autêntica de Imperatriz-MA
- ✅ Animações fluidas e engajantes

---

## 📊 MÉTRICAS DE SUCESSO

- [ ] **Performance:** App inicia em <3s em dispositivos baixo-end
- [ ] **Acessibilidade:** 100% compatível com leitores de tela
- [ ] **Offline:** Todas funcionalidades core funcionam sem internet
- [ ] **UX:** Usuários conseguem montar primeiro prato em <2min
- [ ] **Regionalização:** 100% do conteúdo adaptado para Imperatriz-MA

---

## 🏗️ FASE 1: SETUP E ESTRUTURA BASE ✅ CONCLUÍDA

**Duração:** 2 dias | **Responsável:** Dev Principal  
**Objetivo:** Ambiente configurado e estrutura base funcional  
**Status:** ✅ **CONCLUÍDA (100%)**

### ✅ CHECKPOINTS FASE 1

#### Checkpoint 1.1: Configuração do Ambiente (4h) ✅

- ✅ Flutter FVM instalado e configurado
- ✅ Projeto `dicume_app` criado com FVM
- ✅ Versão Flutter estável mais recente ativa
- ✅ Android Studio/VS Code configurado
- ✅ Emulador Android funcionando
- ✅ **VALIDAÇÃO:** `flutter doctor` sem erros críticos

#### Checkpoint 1.2: Dependências e Configuração (4h) ✅

- ✅ `pubspec.yaml` com todas as dependências principais
- ✅ Configuração Firebase (não necessário - auth via API)
- ✅ Configuração Android (minSdkVersion 21)
- ✅ Configuração iOS (iOS 12+)
- ✅ **VALIDAÇÃO:** `flutter pub get` executa sem erros

#### Checkpoint 1.3: Estrutura de Pastas (2h) ✅

- ✅ Estrutura Clean Architecture implementada
- ✅ Pastas core/, data/, domain/, presentation/ criadas
- ✅ Arquivos base (.gitignore, README, etc.)
- ✅ **VALIDAÇÃO:** Estrutura de pastas conforme documentação

### 📋 ENTREGÁVEIS FASE 1 ✅

- ✅ Projeto Flutter configurado e executável
- ✅ Estrutura de pastas Clean Architecture
- ✅ Todas dependências instaladas e funcionais
- ✅ Git repository iniciado com commit inicial

---

## 🎨 FASE 2: THEME E DESIGN SYSTEM ✅ CONCLUÍDA

**Duração:** 1 dia | **Responsável:** Dev Principal  
**Objetivo:** Design system completo implementado  
**Status:** ✅ **CONCLUÍDA (100%)**

### ✅ CHECKPOINTS FASE 2

#### Checkpoint 2.1: Cores e Tipografia (3h) ✅

- ✅ `app_colors.dart` com paleta maranhense completa
- ✅ `app_text_styles.dart` com Montserrat configurada
- ✅ Cores do semáforo (Verde/Amarelo/Vermelho) definidas
- ✅ **VALIDAÇÃO:** Cores testadas em tema claro

#### Checkpoint 2.2: Theme Material 3 (3h) ✅

- ✅ `app_theme.dart` com ThemeData completo
- ✅ ColorScheme Material 3 implementado
- ✅ Componentes customizados (botões, cards, etc.)
- ✅ **VALIDAÇÃO:** MaterialApp usando tema personalizado

#### Checkpoint 2.3: Widgets Base (2h) ✅

- ✅ Botões customizados (primary, secondary)
- ✅ Cards customizados para alimentos/refeições
- ✅ Loading widgets base
- ✅ **VALIDAÇÃO:** Widgets renderizam corretamente

### 📋 ENTREGÁVEIS FASE 2 ✅

- ✅ Design system completo e funcional
- ✅ Tema Material 3 aplicado
- ✅ Widgets base reutilizáveis
- ✅ Demonstração visual dos componentes

---

## 🔐 FASE 3: AUTENTICAÇÃO 🔄 75% CONCLUÍDA

**Duração:** 2 dias | **Responsável:** Dev Principal  
**Objetivo:** Sistema de login completo (Google + SMS)  
**Status:** 🔄 **EM PROGRESSO (75%)**

### ✅ CHECKPOINTS FASE 3

#### Checkpoint 3.1: Splash Screen (2h) ✅

- ✅ Tela splash com logo animado (Lottie)
- ✅ Verificação de token JWT válido
- ✅ Navegação para login ou home
- ✅ **VALIDAÇÃO:** Splash funciona em device real

#### Checkpoint 3.2: Tela de Login (4h) 🔄 PARCIAL

- ✅ Interface de login responsiva básica
- 🔄 Botão "Entrar com Google" estilizado (funcional)
- 🔄 Botão "Entrar com Celular" + modal SMS (em desenvolvimento)
- ⏳ Animações de entrada e transições
- ⏳ **VALIDAÇÃO:** Layout aprovado conforme design

#### Checkpoint 3.3: Implementação Auth API (6h) ✅

- ✅ `AuthRepository` interface definida
- ✅ `AuthApiService` consumindo endpoints da API
- ✅ `AuthProvider` com Riverpod
- ✅ Google Sign-In integrado
- ✅ **VALIDAÇÃO:** Login Google funcional end-to-end

#### Checkpoint 3.4: Auth SMS e Persistência (4h) ✅

- ✅ Fluxo SMS completo (solicitar + validar)
- ✅ JWT armazenado com flutter_secure_storage
- ✅ Auto-login para usuários logados
- ✅ **VALIDAÇÃO:** Ambos fluxos de auth funcionais

### 📋 ENTREGÁVEIS FASE 3

- ✅ Sistema de autenticação completo (backend)
- ✅ Splash screen animada
- ✅ Persistência segura de sessão
- 🔄 Testes manuais de login aprovados (pendente refinamento UI)

---

## 💾 FASE 4: CACHE LOCAL E OFFLINE

**Duração:** 1 dia | **Responsável:** Dev Principal  
**Objetivo:** Estratégia offline-first implementada

### ✅ CHECKPOINTS FASE 4

#### Checkpoint 4.1: Configuração Isar (3h)

- [ ] Modelos Isar (Alimento, Refeicao, Usuario)
- [ ] Annotations e code generation configurados
- [ ] `IsarService` com CRUD operations
- [ ] **VALIDAÇÃO:** Build runner gera código sem erros

#### Checkpoint 4.2: Cache de Alimentos (3h)

- [ ] Endpoint `GET /dados/alimentos` consumido
- [ ] Cache inicial no primeiro login
- [ ] Sincronização periódica em background
- [ ] **VALIDAÇÃO:** Alimentos salvos localmente

#### Checkpoint 4.3: Queue Offline (2h)

- [ ] Modelo para refeições pendentes
- [ ] Queue de sincronização
- [ ] Indicadores visuais de status
- [ ] **VALIDAÇÃO:** Funciona offline completo

### 📋 ENTREGÁVEIS FASE 4

- Banco Isar configurado e funcionando
- Cache de alimentos implementado
- Sistema de queue offline
- Testes de conectividade offline/online

---

## 🏠 FASE 5: TELA PRINCIPAL E NAVEGAÇÃO

**Duração:** 2 dias | **Responsável:** Dev Principal  
**Objetivo:** Navegação principal e home funcional

### ✅ CHECKPOINTS FASE 5

#### Checkpoint 5.1: Bottom Navigation (3h)

- [ ] BottomNavigationBar customizada
- [ ] 3 tabs: Montar Prato, Histórico, Perfil
- [ ] Ícones regionalizados e animados
- [ ] **VALIDAÇÃO:** Navegação fluida entre tabs

#### Checkpoint 5.2: Home/Montar Prato (4h)

- [ ] Tela principal "Montar Prato"
- [ ] FAB "Botar Comida" com animação
- [ ] Área de composição do prato
- [ ] Saudação personalizada
- [ ] **VALIDAÇÃO:** Layout responsivo aprovado

#### Checkpoint 5.3: Router e Transições (3h)

- [ ] Sistema de rotas configurado
- [ ] Transições animadas entre telas
- [ ] Deep linking básico
- [ ] **VALIDAÇÃO:** Navegação sem travamentos

#### Checkpoint 5.4: Estados Vazios (2h)

- [ ] Empty states com ilustrações
- [ ] Mensagens de boas-vindas
- [ ] Call-to-actions claros
- [ ] **VALIDAÇÃO:** UX de primeiro uso aprovada

### 📋 ENTREGÁVEIS FASE 5

- Navegação principal completa
- Home screen funcional
- Router configurado
- Estados vazios implementados

---

## 🍽️ FASE 6: MONTAR PRATO - CORE FEATURE

**Duração:** 4 dias | **Responsável:** Dev Principal  
**Objetivo:** Funcionalidade principal de montagem de pratos

### ✅ CHECKPOINTS FASE 6

#### Checkpoint 6.1: Seleção de Grupos (6h)

- [ ] Grid de grupos de alimentos
- [ ] Cards animados com fotos/ícones
- [ ] Transições para lista de alimentos
- [ ] Grupos regionalizados (nomes locais)
- [ ] **VALIDAÇÃO:** Navegação entre grupos fluida

#### Checkpoint 6.2: Lista de Alimentos (8h)

- [ ] Lista infinita de alimentos por grupo
- [ ] Cards com fotos do manual fotográfico
- [ ] Search/filtro com debounce
- [ ] Loading shimmer effects
- [ ] **VALIDAÇÃO:** Performance com 200+ alimentos

#### Checkpoint 6.3: Seleção de Quantidade (8h)

- [ ] Modal/bottom sheet de quantidades
- [ ] Medidas caseiras regionais
- [ ] Stepper animado para ajustar
- [ ] Preview visual da porção
- [ ] **VALIDAÇÃO:** UX de seleção aprovada

#### Checkpoint 6.4: Composição do Prato (6h)

- [ ] Área visual do "prato montado"
- [ ] Lista de itens adicionados
- [ ] Animações de add/remove
- [ ] Validações e feedback
- [ ] **VALIDAÇÃO:** Fluxo completo funcional

#### Checkpoint 6.5: Finalização (4h)

- [ ] Botão "Tá Pronto Meu Rango!" destacado
- [ ] Validação mínima de itens
- [ ] Transição para semáforo
- [ ] **VALIDAÇÃO:** Integração com API funcional

### 📋 ENTREGÁVEIS FASE 6

- Funcionalidade core completa
- Interface aprovada pelos stakeholders
- Performance otimizada
- Testes manuais aprovados

---

## 🚦 FASE 7: SEMÁFORO NUTRICIONAL

**Duração:** 2 dias | **Responsável:** Dev Principal  
**Objetivo:** Sistema de feedback visual implementado

### ✅ CHECKPOINTS FASE 7

#### Checkpoint 7.1: Widget Semáforo (4h)

- [ ] Círculo animado com mudança de cores
- [ ] Ícones animados (👍, ⚠️, ❌)
- [ ] Animação de "revelação" dramática
- [ ] Efeitos visuais de impacto
- [ ] **VALIDAÇÃO:** Animação fluida e impactante

#### Checkpoint 7.2: Lógica de Classificação (3h)

- [ ] Implementação das regras do semáforo
- [ ] Integração com API `POST /diario/refeicoes`
- [ ] Tratamento de resposta da API
- [ ] **VALIDAÇÃO:** Classificações corretas

#### Checkpoint 7.3: Feedback e Mensagens (4h)

- [ ] Mensagens regionalizadas por cor
- [ ] Animações de texto aparecendo
- [ ] Botões de ação (salvar, refazer)
- [ ] Celebração para resultados verdes
- [ ] **VALIDAÇÃO:** Mensagens aprovadas

#### Checkpoint 7.4: Persistência (3h)

- [ ] Salvar refeição no histórico local
- [ ] Sincronização com API
- [ ] Handling de erros de rede
- [ ] **VALIDAÇÃO:** Funciona offline/online

### 📋 ENTREGÁVEIS FASE 7

- Semáforo nutricional funcional
- Feedback visual impactante
- Mensagens regionalizadas
- Integração completa com API

---

## 📱 FASE 8: TELAS SECUNDÁRIAS

**Duração:** 3 dias | **Responsável:** Dev Principal  
**Objetivo:** Histórico e Perfil completos

### ✅ CHECKPOINTS FASE 8

#### Checkpoint 8.1: Tela de Histórico (6h)

- [ ] Lista de refeições por data
- [ ] Calendário para navegação
- [ ] Cards com status semáforo
- [ ] Filtros por tipo de refeição
- [ ] **VALIDAÇÃO:** Histórico carrega corretamente

#### Checkpoint 8.2: Detalhes da Refeição (4h)

- [ ] Tela de detalhes expandida
- [ ] Lista de alimentos consumidos
- [ ] Informações nutricionais
- [ ] **VALIDAÇÃO:** Navegação para detalhes

#### Checkpoint 8.3: Tela de Perfil Base (4h)

- [ ] Formulário de dados pessoais
- [ ] Campos com validação
- [ ] Avatar/foto placeholder
- [ ] **VALIDAÇÃO:** Formulário responsivo

#### Checkpoint 8.4: Perfil Avançado (6h)

- [ ] Campos demográficos opcionais
- [ ] Integração com API `PUT /perfil`
- [ ] Animações de input focus
- [ ] Estados de loading/sucesso
- [ ] **VALIDAÇÃO:** CRUD de perfil funcional

#### Checkpoint 8.5: Configurações (4h)

- [ ] Tela de configurações básicas
- [ ] Logout com confirmação
- [ ] About/informações do app
- [ ] **VALIDAÇÃO:** Navegação para config

### 📋 ENTREGÁVEIS FASE 8

- Histórico completo e funcional
- Perfil de usuário editável
- Configurações básicas
- Navegação entre telas secundárias

---

## 🎯 FASE 9: POLIMENTO E UX

**Duração:** 3 dias | **Responsável:** Dev Principal  
**Objetivo:** Experiência de usuário refinada

### ✅ CHECKPOINTS FASE 9

#### Checkpoint 9.1: Acessibilidade (6h)

- [ ] Semantics em todos os widgets interativos
- [ ] Labels para leitores de tela
- [ ] Testes com TalkBack (Android)
- [ ] Contraste verificado (WCAG AA)
- [ ] **VALIDAÇÃO:** Aprovação em testes de acessibilidade

#### Checkpoint 9.2: Micro-interações (4h)

- [ ] Feedback haptic em ações
- [ ] Ripple effects customizados
- [ ] Animações de loading state
- [ ] Transições entre componentes
- [ ] **VALIDAÇÃO:** Interações fluidas e naturais

#### Checkpoint 9.3: Estados de Erro (4h)

- [ ] Error boundaries globais
- [ ] Retry mechanisms
- [ ] Fallbacks para offline
- [ ] Mensagens user-friendly
- [ ] **VALIDAÇÃO:** Graceful error handling

#### Checkpoint 9.4: Performance (6h)

- [ ] Profile de performance executado
- [ ] Otimização de imagens
- [ ] Lazy loading implementado
- [ ] Build size otimizado
- [ ] **VALIDAÇÃO:** <60fps constante, app <50MB

#### Checkpoint 9.5: Polimento Visual (4h)

- [ ] Spacing e alinhamentos revisados
- [ ] Animações refinadas
- [ ] Empty states ilustrados
- [ ] Loading states consistentes
- [ ] **VALIDAÇÃO:** Review de UI/UX aprovado

### 📋 ENTREGÁVEIS FASE 9

- App acessível e inclusivo
- Performance otimizada
- Estados de erro tratados
- Micro-interações polidas

---

## 🧪 FASE 10: TESTES E REFINAMENTO

**Duração:** 3 dias | **Responsável:** Dev Principal  
**Objetivo:** Qualidade assegurada e bugs corrigidos

### ✅ CHECKPOINTS FASE 10

#### Checkpoint 10.1: Unit Tests (6h)

- [ ] Tests para providers/repositories
- [ ] Tests para models e entities
- [ ] Tests para utils e helpers
- [ ] Coverage >80% no core business
- [ ] **VALIDAÇÃO:** Todos testes passando

#### Checkpoint 10.2: Widget Tests (6h)

- [ ] Tests para widgets críticos
- [ ] Tests para telas principais
- [ ] Tests de acessibilidade
- [ ] **VALIDAÇÃO:** UI widgets testados

#### Checkpoint 10.3: Integration Tests (6h)

- [ ] Fluxo de autenticação E2E
- [ ] Fluxo de montar prato E2E
- [ ] Fluxo offline/online E2E
- [ ] **VALIDAÇÃO:** Fluxos principais funcionais

#### Checkpoint 10.4: Testes de Dispositivo (4h)

- [ ] Testes em dispositivos low-end
- [ ] Testes em diferentes tamanhos de tela
- [ ] Testes de conectividade
- [ ] **VALIDAÇÃO:** Funciona em devices reais

#### Checkpoint 10.5: Bug Fixes (2h)

- [ ] Correção de bugs encontrados
- [ ] Refinamentos finais
- [ ] Code review final
- [ ] **VALIDAÇÃO:** App estável para release

### 📋 ENTREGÁVEIS FASE 10

- Suite de testes implementada
- Bugs críticos corrigidos
- App validado em dispositivos reais
- Código pronto para produção

---

## 🚀 FASE 11: BUILD E DEPLOY

**Duração:** 2 dias | **Responsável:** Dev Principal  
**Objetivo:** App pronto para distribuição

### ✅ CHECKPOINTS FASE 11

#### Checkpoint 11.1: Configuração Android (4h)

- [ ] Build configuration para release
- [ ] Proguard/R8 configurado
- [ ] Assinatura do APK/AAB
- [ ] Ícones adaptativos
- [ ] **VALIDAÇÃO:** APK release gerado

#### Checkpoint 11.2: Configuração iOS (4h)

- [ ] Build configuration para App Store
- [ ] Certificados e provisioning
- [ ] Info.plist otimizado
- [ ] Ícones para iOS
- [ ] **VALIDAÇÃO:** IPA release gerado

#### Checkpoint 11.3: Assets Finais (2h)

- [ ] Splash screens otimizadas
- [ ] Ícones finais em todas as resoluções
- [ ] Assets comprimidos
- [ ] **VALIDAÇÃO:** Assets aprovados

#### Checkpoint 11.4: Documentação (4h)

- [ ] README do projeto atualizado
- [ ] Documentação de build
- [ ] Guia de deployment
- [ ] Changelog da versão
- [ ] **VALIDAÇÃO:** Documentação completa

#### Checkpoint 11.5: Release Final (2h)

- [ ] Versioning final (1.0.0)
- [ ] Tags no Git
- [ ] Build final testado
- [ ] **VALIDAÇÃO:** Release candidato aprovado

### 📋 ENTREGÁVEIS FASE 11

- APK/AAB Android assinado
- IPA iOS pronto para App Store
- Documentação completa
- Release candidato validado

---

## 📁 ARQUIVOS IMPLEMENTADOS

### ✅ Core/Constants

- ✅ `lib/core/constants/app_constants.dart` - Constantes globais
- ✅ `lib/core/constants/api_endpoints.dart` - URLs e endpoints da API
- ✅ `lib/core/constants/animation_constants.dart` - Constantes de animação

### ✅ Core/Theme

- ✅ `lib/core/theme/app_colors.dart` - Paleta de cores maranhense
- ✅ `lib/core/theme/app_text_styles.dart` - Tipografia Montserrat
- ✅ `lib/core/theme/app_theme.dart` - ThemeData Material 3 completo

### ✅ Domain Layer

- ✅ `lib/domain/entities/user.dart` - Entidade User + UserPreferences
- ✅ `lib/domain/entities/auth.dart` - Entidades de autenticação
- ✅ `lib/domain/entities/failures.dart` - Classes de erro tipadas
- ✅ `lib/domain/repositories/auth_repository.dart` - Contrato AuthRepository
- ✅ `lib/domain/usecases/sign_in_with_google_usecase.dart` - Use case Google
- ✅ `lib/domain/usecases/request_sms_code_usecase.dart` - Use case SMS request
- ✅ `lib/domain/usecases/verify_and_sign_in_with_sms_usecase.dart` - Use case SMS verify
- ✅ `lib/domain/usecases/sign_out_usecase.dart` - Use case logout
- ✅ `lib/domain/usecases/get_current_user_usecase.dart` - Use case current user
- ✅ `lib/domain/usecases/is_authenticated_usecase.dart` - Use case auth check

### ✅ Data Layer

- ✅ `lib/data/models/user_model.dart` + `.g.dart` - Modelo User + JSON
- ✅ `lib/data/models/auth_model.dart` + `.g.dart` - Modelos Auth + JSON
- ✅ `lib/data/datasources/auth_remote_datasource.dart` - API calls
- ✅ `lib/data/datasources/auth_local_datasource.dart` - Cache seguro
- ✅ `lib/data/repositories/auth_repository_impl.dart` - Implementação repository
- ✅ `lib/data/providers/auth_providers.dart` - Providers Riverpod

### ✅ Presentation Layer

- ✅ `lib/presentation/controllers/auth_controller.dart` + `.g.dart` - Controller auth
- ✅ `lib/presentation/screens/splash/splash_screen.dart` - Tela splash animada
- ✅ `lib/presentation/screens/auth/simple_login_screen.dart` - Tela login básica

### ✅ Main & Config

- ✅ `lib/main.dart` - App principal com Riverpod + navegação
- ✅ `pubspec.yaml` - Dependências completas
- ✅ `test/widget_test.dart` - Teste básico

### ⏳ Pendentes Implementação

- ⏳ `lib/data/models/alimento_model.dart` - Modelo alimentos
- ⏳ `lib/data/models/refeicao_model.dart` - Modelo refeições
- ⏳ `lib/data/datasources/isar_datasource.dart` - Cache Isar
- ⏳ `lib/presentation/screens/home/` - Tela principal
- ⏳ `lib/presentation/screens/montar_prato/` - Core feature
- ⏳ `lib/presentation/widgets/` - Widgets reutilizáveis

---

## 📈 ESTATÍSTICAS DO PROJETO

### 📊 Arquivos Implementados

- **Total:** 29 arquivos Dart + 4 arquivos .g.dart gerados
- **Core:** 6 arquivos (100%)
- **Domain:** 11 arquivos (100%)
- **Data:** 8 arquivos (80% - falta Isar)
- **Presentation:** 4 arquivos (30% - falta telas principais)

### 🚀 Performance do Build

- **Flutter analyze:** ✅ 0 erros, 13 warnings (style)
- **Build time:** ~30s (build_runner)
- **Compilation:** ✅ Sem erros críticos

### 📱 Funcionalidades Testadas

- ✅ Splash screen animada
- ✅ Navegação básica
- ✅ Tema Material 3 aplicado
- 🔄 Login Google (backend pronto, UI básica)
- 🔄 Login SMS (backend pronto, UI pendente)
- ⏳ Cache offline (não iniciado)

---

## 🎯 PRÓXIMOS PASSOS IMEDIATOS

### 1. **Finalizar UI de Autenticação** (2-3 horas)

- Melhorar design da tela de login
- Implementar modal SMS com validação
- Adicionar animações de transição
- Testar fluxo completo Google + SMS

### 2. **Implementar Cache Isar** (4-5 horas)

- Criar modelos Isar para Alimento, Refeição
- Implementar IsarService com CRUD
- Cache inicial de alimentos da API
- Sistema de queue offline

### 3. **Navegação Principal** (3-4 horas)

- Bottom Navigation Bar customizada
- Tela Home/Montar Prato
- Router com transições
- Estados vazios

### 🎯 Meta para Hoje

- ✅ Atualizar plano de ação
- 🔄 Finalizar Fase 3 (Auth UI)
- 🚀 Iniciar Fase 4 (Cache Isar)

---

## 🛠️ TOOLS E RECURSOS

### Desenvolvimento

- **Flutter FVM:** Gerenciamento de versões
- **VS Code:** IDE principal + extensões Flutter
- **Android Studio:** Emuladores e debugging
- **Git:** Controle de versão + conventional commits

### Testing

- **Flutter Test:** Unit e Widget tests
- **Integration Test:** E2E testing
- **Golden Tests:** UI regression testing

### Monitoring

- **Flutter Inspector:** Debug de widgets
- **DevTools:** Performance profiling
- **Firebase Crashlytics:** Crash reporting (se usar)

### Assets

- **Lottie:** Animações vetoriais
- **Manual Fotográfico:** Fotos dos alimentos
- **Figma/Design:** Referências visuais

---

## 📝 TEMPLATE DE DAILY STANDUPS

### Formato Diário (15min)

1. **Ontem:** Checkpoints completados
2. **Hoje:** Checkpoints planejados
3. **Bloqueios:** Impedimentos técnicos ou de recursos
4. **Riscos:** Potenciais atrasos identificados

### Template de Update

```markdown
## Daily Update - DD/MM/YYYY

### ✅ Completado

- [ ] Checkpoint X.Y: Descrição

### 🔄 Em Progresso

- [ ] Checkpoint X.Y: Descrição (XX% completo)

### 📋 Próximos

- [ ] Checkpoint X.Y: Descrição

### 🚨 Bloqueios

- Nenhum / Descrição do bloqueio

### 📊 Status da Fase

- Fase atual: X - Nome da Fase
- Progresso: XX/YY checkpoints (XX%)
- No prazo: ✅/❌
```

---

## 🎯 CRITÉRIOS DE ACEITAÇÃO FINAL

### Funcionalidades Core

- ✅ Usuário consegue fazer login (Google + SMS)
- ✅ Usuário consegue montar um prato offline
- ✅ Semáforo nutricional funciona corretamente
- ✅ Histórico de refeições é persistido
- ✅ Perfil do usuário é editável

### Qualidade

- ✅ App funciona offline completamente
- ✅ Performance aceitável em devices baixo-end
- ✅ Acessível para leitores de tela
- ✅ Interface responsiva para diferentes telas
- ✅ Animações fluidas e não bloqueantes

### Regional/Cultural

- ✅ Linguagem regionalizada de Imperatriz-MA
- ✅ Fotos do manual fotográfico local
- ✅ Medidas caseiras familiares
- ✅ Cores e identidade visual apropriadas

---

**Documento criado em:** 17 de junho de 2025  
**Última atualização:** [Data da última modificação]  
**Versão:** 1.0  
**Status:** Em Planejamento ➜ Em Desenvolvimento

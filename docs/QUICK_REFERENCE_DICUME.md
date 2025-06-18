# ⚡ DICUMÊ - Quick Reference Guide

## 🎯 OBJETIVOS DO PROJETO

- App educacional nutricional para diabéticos em Imperatriz-MA
- Interface acessível (60+ anos, baixa literacia digital)
- Sistema "semáforo nutricional" visual
- Funcionalidade offline-first
- Regionalização autêntica maranhense

## 🏗️ STACK TÉCNICO

- **Framework:** Flutter + FVM
- **Estado:** Riverpod + Annotations
- **Cache:** Drift (SQL local)
- **HTTP:** Dio
- **Animações:** Lottie + flutter_animate
- **Auth:** API gerencia auth (Google + SMS via Supabase)

## 📱 FUNCIONALIDADES CORE

1. **Autenticação:** Google + SMS
2. **Montar Prato:** Seleção visual de alimentos
3. **Semáforo:** Verde/Amarelo/Vermelho
4. **Histórico:** Refeições anteriores
5. **Perfil:** Dados demográficos opcionais

## 🚦 REGRAS DO SEMÁFORO

- **🔴 Vermelho:** Contém alimentos do "grupo dos doces"
- **🟡 Amarelo:** Contém alimentos de "moderação" (arroz, batata)
- **🟢 Verde:** Apenas alimentos "pode comer à vontade"

## 🎨 DESIGN TOKENS

### Cores Principais

```dart
// Paleta Maranhense
primary: Color(0xFF5D4037)      // Marrom Terroso
secondary: Color(0xFF1E88E5)    // Azul Vibrante
background: Color(0xFFF5F5F5)   // Cinza Claro

// Semáforo
verde: Color(0xFF4CAF50)
amarelo: Color(0xFFC107)
vermelho: Color(0xF44336)
```

### Tipografia

```dart
// Montserrat Font
headlineMedium: 28px, w700   // Títulos principais
titleLarge: 22px, w700       // Títulos de seção
bodyLarge: 18px, w400        // Texto principal
```

## 🗂️ ESTRUTURA DE PASTAS

```
lib/
├── core/          # Constants, theme, utils, models
├── data/          # Local (Isar) + Remote (API) + Repositories
├── domain/        # Entities, repository contracts, usecases
├── presentation/  # Providers, screens, widgets, routes
└── main.dart
```

## 🌐 API ENDPOINTS & FLUXO AUTH

```dart
// Base URL: https://api.dicume.com/api/v1

// ⚠️ IMPORTANTE: A API gerencia toda a autenticação
// Flutter apenas coleta dados e envia para API

// Auth - Retorna JWT do DICUMÊ (não tokens externos)
POST /auth/google              // Envia: {token_google: "..."}
                              // Recebe: {token: "jwt.dicume", usuario: {...}}

POST /auth/solicitar-codigo    // Envia: {telefone: "5599912345678"}
                              // Recebe: {sucesso: true, mensagem: "..."}

POST /auth/validar-codigo      // Envia: {telefone: "...", codigo: "123456"}
                              // Recebe: {token: "jwt.dicume", usuario: {...}}

// Dados - Todas precisam de JWT via Authorization: Bearer <token>
GET /dados/alimentos           // Lista completa para cache

// Refeições
POST /diario/refeicoes         // Salvar + análise semáforo
GET /diario/refeicoes/:data    // Histórico por data

// Perfil
GET /perfil                    // Dados do usuário
PUT /perfil                    // Atualizar perfil
```

## 🔐 FLUXO DE AUTENTICAÇÃO DETALHADO

### Google Sign-In Flow

```dart
// 1. Flutter: Obter token de ID do Google
GoogleSignInAccount account = await GoogleSignIn().signIn();
GoogleSignInAuthentication auth = await account.authentication;
String idToken = auth.idToken; // Este é o token para enviar

// 2. Flutter: Enviar para API DICUMÊ
Response response = await dio.post('/auth/google', data: {
  'token_google': idToken
});

// 3. API: Valida token com Supabase Auth e retorna JWT próprio
// 4. Flutter: Armazenar JWT do DICUMÊ
String dicumeJWT = response.data['token'];
await secureStorage.write(key: 'auth_token', value: dicumeJWT);
```

### SMS Flow

```dart
// 1. Flutter: Solicitar código
await dio.post('/auth/solicitar-codigo', data: {
  'telefone': '5599912345678'
});

// 2. API: Envia SMS via Supabase Auth
// 3. Flutter: Usuário digita código e valida
await dio.post('/auth/validar-codigo', data: {
  'telefone': '5599912345678',
  'codigo': '123456'
});

// 4. API: Valida código e retorna JWT do DICUMÊ
// 5. Flutter: Armazenar JWT
```

### Uso do JWT em Requisições

```dart
// Todas as requisições autenticadas usam o JWT do DICUMÊ
dio.options.headers['Authorization'] = 'Bearer $dicumeJWT';

// Exemplo
final alimentos = await dio.get('/dados/alimentos');
// API valida JWT e retorna dados
```

## 📋 CHECKLIST RÁPIDO POR TELA

### 🔐 Login

- [ ] Splash animada com logo
- [ ] Botão Google Sign-In (obtém token de ID)
- [ ] Enviar token Google para API `/auth/google`
- [ ] Modal SMS (solicita código via API)
- [ ] Validar código SMS via API `/auth/validar-codigo`
- [ ] Armazenar JWT do DICUMÊ (não token Google)
- [ ] Usar JWT em todas requisições subsequentes
- [ ] Transições suaves

### 🏠 Home/Montar Prato

- [ ] Bottom Navigation (3 tabs)
- [ ] FAB "Botar Comida" destacado
- [ ] Área composição do prato
- [ ] Saudação personalizada
- [ ] Estados vazios amigáveis

### 🥘 Seleção de Alimentos

- [ ] Grid grupos regionalizados
- [ ] Lista alimentos com fotos
- [ ] Search/filtro com debounce
- [ ] Modal quantidades (medidas caseiras)
- [ ] Animações add/remove

### 🚦 Semáforo

- [ ] Círculo grande animado
- [ ] Ícones expressivos (👍⚠️❌)
- [ ] Mensagens regionais
- [ ] Botões salvar/refazer
- [ ] Celebração para verde

### 📚 Histórico

- [ ] Lista por data
- [ ] Cards com status semáforo
- [ ] Filtros por refeição
- [ ] Loading shimmer
- [ ] Empty states

### 👤 Perfil

- [ ] Formulário responsivo
- [ ] Campos opcionais validados
- [ ] Avatar placeholder
- [ ] Sincronização API
- [ ] Configurações básicas

## 🎯 STATUS ATUAL (Atualizado: 18/06/2025)

### ✅ CONCLUÍDO

- **Fase 1:** Setup e Estrutura Base (100%)
- **Fase 2:** Theme e Design System (100%)
- **Fase 3:** Autenticação (75% - backend funcional)
- **Fase 4:** Cache Local e Offline (100% - migrado para Drift)

### 🔄 EM PROGRESSO

- **Fase 5:** Navegação Principal (próxima)

### 🏗️ ARQUITETURA IMPLEMENTADA

- ✅ Drift database com cache inteligente
- ✅ Queue offline para refeições pendentes
- ✅ Sistema de sincronização automática
- ✅ Providers Riverpod com code generation
- ✅ Clean Architecture com repositories
- ✅ Remote e local datasources
- ✅ Estados de sincronização com feedback visual

### 🚀 READY FOR

- Bottom Navigation implementation
- Home screen development
- Core features (Montar Prato)

---

## 📊 MILESTONE TARGETS

### Dia 5: Auth + Theme ✅

- Login funcionando
- Design system aplicado

### Dia 10: Navegação + Cache ✅

- Bottom nav completa
- Cache offline funcionando

### Dia 15: Core Feature ✅

- Montar prato completo
- Integração API básica

### Dia 20: Feature Complete ✅

- Semáforo funcionando
- Histórico + Perfil

### Dia 25: Production Ready ✅

- Testes passando
- Build otimizada
- Acessibilidade completa

## 🚨 RED FLAGS

- **Performance:** Startup >5s
- **Memory:** Usage >300MB
- **Accessibility:** Widgets sem Semantics
- **Offline:** Core features não funcionam
- **Regional:** Linguagem não adaptada

---

**📞 Dúvidas?** Consulte o PLANO_DE_ACAO_DICUME_APP.md completo  
**📊 Progress?** Use TRACKING_DICUME_APP.md para acompanhamento

# 🥘 DICUMÊ - App Educacional Nutricional

[![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7%2B-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Aplicativo móvel educacional nutricional para pessoas com diabetes mellitus tipo 2 em Imperatriz-MA. Desenvolvido com foco em acessibilidade, regionalização e funcionalidade offline-first.

## 🎯 Objetivos

- **Educação nutricional visual** através do sistema "semáforo nutricional"
- **Interface acessível** para usuários 60+ com baixa literacia digital
- **Regionalização autêntica** adaptada à cultura de Imperatriz-MA
- **Funcionalidade offline-first** para áreas com conectividade limitada
- **Experiência fluida** com animações e micro-interações

## 🏗️ Arquitetura

### Stack Tecnológico

- **Framework:** Flutter + FVM
- **Gerenciamento de Estado:** Riverpod + Annotations
- **Cache Local:** Isar (NoSQL)
- **Cliente HTTP:** Dio
- **Animações:** Lottie + flutter_animate
- **Autenticação:** Google Sign-In + SMS via API

### Estrutura do Projeto (Clean Architecture)

```
lib/
├── core/                   # Núcleo da aplicação
│   ├── constants/          # Constantes globais
│   ├── theme/             # Sistema de design
│   ├── utils/             # Utilitários
│   └── models/            # Modelos de dados
├── data/                  # Camada de dados
│   ├── local/             # Fonte de dados local (Isar)
│   ├── remote/            # Fonte de dados remota (API)
│   └── repositories/      # Implementação dos repositórios
├── domain/                # Regras de negócio
│   ├── entities/          # Entidades de domínio
│   ├── repositories/      # Contratos dos repositórios
│   └── usecases/          # Casos de uso
└── presentation/          # Interface do usuário
    ├── providers/         # Provedores Riverpod
    ├── screens/           # Telas da aplicação
    ├── widgets/           # Widgets reutilizáveis
    └── routes/            # Navegação
```

## 🎨 Design System

### Paleta de Cores (Identidade Maranhense)

- **Primary:** `#5D4037` (Marrom Terroso)
- **Secondary:** `#1E88E5` (Azul Vibrante)
- **Background:** `#F5F5F5` (Cinza Claro)

### Semáforo Nutricional

- **🟢 Verde** `#4CAF50`: Alimentos liberados
- **🟡 Amarelo** `#FFC107`: Moderação necessária
- **🔴 Vermelho** `#F44336`: Evitar

### Tipografia

- **Font Family:** Montserrat (Google Fonts)
- **Tamanhos:** Responsivos e acessíveis
- **Pesos:** Regular, SemiBold, Bold

## 📱 Funcionalidades

### Core Features

1. **Autenticação**

   - Login via Google
   - Login via SMS
   - Persistência segura de sessão

2. **Montar Prato**

   - Seleção visual de alimentos
   - Medidas caseiras regionais
   - Composição de refeições

3. **Semáforo Nutricional**

   - Análise automática das refeições
   - Feedback visual imediato
   - Mensagens regionalizadas

4. **Histórico**

   - Visualização de refeições passadas
   - Filtros por data e tipo
   - Estatísticas de consumo

5. **Perfil**
   - Dados demográficos opcionais
   - Configurações da aplicação
   - Informações para pesquisa

### Características Especiais

- **100% funcional offline**
- **Sincronização inteligente**
- **Acessibilidade completa (WCAG AA)**
- **Animações fluidas e responsivas**
- **Linguagem regionalizada**

## 🚀 Setup do Projeto

### Pré-requisitos

- Flutter 3.24+ instalado
- FVM (Flutter Version Management)
- Android Studio / VS Code
- Git

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/dicume_app.git
cd dicume_app

# Configure o FVM (se ainda não configurado)
fvm install stable
fvm use stable

# Instale as dependências
fvm flutter pub get

# Execute o code generation
fvm flutter packages pub run build_runner build

# Execute o app
fvm flutter run
```

### Comandos Úteis

```bash
# Gerar código (Riverpod + Isar)
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch mode para development
fvm flutter packages pub run build_runner watch

# Build para produção
fvm flutter build apk --release
fvm flutter build appbundle --release
```

## 📋 Progresso do Desenvolvimento

### ✅ Fase 1: Setup e Estrutura Base (Completo)

- [x] Configuração Flutter + FVM
- [x] Estrutura Clean Architecture
- [x] Dependências instaladas
- [x] Tema maranhense implementado
- [x] Animações básicas funcionando

### 🔄 Próximas Fases

- [ ] Fase 2: Design System completo
- [ ] Fase 3: Sistema de autenticação
- [ ] Fase 4: Cache local e offline
- [ ] Fase 5: Navegação principal
- [ ] Fase 6: Core feature - Montar Prato
- [ ] Fase 7: Semáforo nutricional
- [ ] Fase 8: Telas secundárias
- [ ] Fase 9: Polimento e UX
- [ ] Fase 10: Testes e refinamento
- [ ] Fase 11: Build e deploy

## 🎯 Métricas de Qualidade

### Performance Targets

- ⏱️ **Startup:** <3s em dispositivos low-end
- 🔄 **Navegação:** <500ms entre telas
- 💾 **Memory:** <200MB usage
- 📦 **Build Size:** <50MB (Android)

### Acessibilidade

- ♿ **WCAG AA** compliance
- 🔊 **TalkBack/VoiceOver** support
- 🔍 **Zoom** até 200% sem quebra de layout
- 🎯 **Touch targets** mínimo 48x48dp

### Offline Capability

- 📱 **100%** das funcionalidades core offline
- 🔄 **Sync automático** em background
- 📊 **Queue persistente** para refeições pendentes

## 📞 Contato

**Desenvolvedor:** Vinícius Schneider  
**Projeto:** DICUMÊ - Imperatriz/MA  
**Documentação:** [Ver docs completas](../PLANO_DE_ACAO_DICUME_APP.md)

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

**Feito com ❤️ em Imperatriz-MA para a comunidade diabética local**

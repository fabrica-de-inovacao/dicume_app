# Documento do Aplicativo (Frontend) — DICUMÊ

Criado por: Vinícius Schneider
Criado em: 17 de junho de 2025 19:19
Categoria: APP, Android, IOS
Última edição por: Vinícius Schneider
Última atualização em: 18 de junho de 2025 10:00

Este documento descreve a arquitetura técnica, as estratégias de implementação, o guia de estilo visual e os princípios de design para o aplicativo móvel DICUMÊ. Desenvolvido em Flutter, o app funciona como o cliente (client) do sistema, sendo responsável por toda a experiência do usuário (UI/UX) e pela comunicação com a API de Negócio.

---

### **1. Stack Tecnológico**

- **Framework:** Flutter (versão estável mais recente)
- **Linguagem:** Dart
- **Gerenciamento de Estado:** Riverpod
  - **Justificativa:** Riverpod foi escolhido por sua flexibilidade, segurança de compilação (_compile-time safety_) e por desacoplar o gerenciamento de estado da árvore de widgets, facilitando a testabilidade e a manutenção do código.
- **Banco de Dados Local (Cache):** Drift
  - **Justificativa:** Drift é um banco de dados SQL reativo e com excelente performance em Flutter, ideal para a estratégia _offline-first_ do aplicativo com type safety e validações.
- **Cliente HTTP:** Dio
  - **Justificativa:** Dio é um cliente HTTP poderoso para Dart, que suporta interceptadores (_interceptors_), configuração global e manipulação de erros, facilitando a comunicação segura e organizada com a API Express.

### **2. Arquitetura do Aplicativo**

A arquitetura seguirá uma abordagem de **Clean Architecture** adaptada para Flutter, separando o código em camadas de responsabilidade para garantir escalabilidade e manutenibilidade.

- **Estrutura de Pastas (sugestão):**
  ```markdown
  lib/
  ├── core/ # Lógica de Negócio e Entidades
  │ ├── models/ # Modelos de dados (ex: Alimento, Refeicao)
  │ └── repositories/ # Contratos (interfaces) dos repositórios
  ├── data/ # Camada de Dados (Implementação dos Repositórios)
  │ ├── local/ # Fontes de dados locais (Drift)
  │ └── remote/ # Fontes de dados remotas (API com Dio)
  ├── presentation/ # Camada de UI (Widgets e Gerenciamento de Estado)
  │ ├── providers/ # Provedores do Riverpod
  │ ├── screens/ # Telas do aplicativo
  │ └── widgets/ # Widgets reutilizáveis
  └── main.dart
  ```

### **3. Estratégia de Cache e Sincronização Offline**

Esta é uma funcionalidade crítica para garantir a usabilidade em áreas com conectividade limitada.

1. **Cache Inicial:**
   - Após o primeiro login bem-sucedido, o aplicativo chama o endpoint `GET /dados/alimentos` da API.
   - A lista completa de alimentos é salva integralmente no banco de dados local (Drift).
   - As fotos dos alimentos são cacheadas no dispositivo usando o pacote `cached_network_image` conforme são exibidas pela primeira vez.
2. **Operação Offline:**
   - Para visualizar alimentos e montar pratos, o app lê **exclusivamente** do banco de dados Drift. Isso garante performance instantânea.
   - Quando o usuário salva uma refeição (`POST /diario/refeicoes`), a requisição é primeiro salva em uma tabela `refeicoes_pendentes` no Drift. O app exibe uma mensagem informativa ao usuário (ex: "Prato salvo! Assim que tiver internet, a gente analisa pra você.").
3. **Sincronização em Segundo Plano:**
   - Um serviço em segundo plano (implementado com o pacote `workmanager` ou similar) é responsável por verificar a fila `refeicoes_pendentes`.
   - Quando a conectividade com a internet é detectada, o serviço envia as requisições pendentes para a API.
   - Após receber uma resposta de sucesso da API (ex: `201 Created`), o registro correspondente é removido da fila local.
   - O app então atualiza a UI (se estiver aberta) com o resultado do "semáforo" retornado pela API.

### **4. Guia de Estilo e Tema (Design System)**

O design deve ser consistente e refletir a identidade regional e acessível do projeto. Para garantir isso, um `ThemeData` completo será definido e aplicado em todo o aplicativo.

### **4.1. Paleta de Cores (ColorScheme - Material 3)**

A paleta é inspirada na cultura maranhense, com tons terrosos e um azul vibrante.

- **Primária:** Tons terrosos (marrons, beges) que remetem ao artesanato local, à terra e ao aconchego.
- **Secundária:** Um azul vibrante, inspirado no céu e nos rios da região, usado para elementos de ação e destaque.
- **Cores de Status:** Verde, Amarelo e Vermelho, com alto contraste e saturação para fácil distinção do semáforo nutricional.

Dart

```dart
// Exemplo de ColorScheme para o ThemeData
const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF5D4037), // Marrom Terroso Principal
  onPrimary: Color(0xFFFFFFFF), // Texto/Ícone sobre o primário
  secondary: Color(0xFF1E88E5), // Azul Vibrante
  onSecondary: Color(0xFFFFFFFF), // Texto/Ícone sobre o secundário
  error: Color(0xFFD32F2F), // Vermelho para erros/status negativo
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFF5F5F5), // Fundo principal (Cinza Claro)
  onBackground: Color(0xFF212121), // Texto sobre o fundo
  surface: Color(0xFFFFFFFF), // Cor de superfícies (Cards)
  onSurface: Color(0xFF212121), // Texto sobre superfícies
);
```

### **4.2. Tipografia (`TextTheme`)**

A fonte escolhida é a **Montserrat**, por ser amigável, arredondada e ter excelente legibilidade em diferentes tamanhos e pesos.

Dart

```dart
// Exemplo de TextTheme para o ThemeData (usando google_fonts)
const textTheme = TextTheme(
  // Títulos grandes e de destaque
  displayLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
  displayMedium: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),

  // Títulos de tela
  headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
  headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, fontFamily: 'Montserrat'),

  // Títulos de seções e cards
  titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, fontFamily: 'Montserrat'),
  titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),

  // Corpo de texto principal
  bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: 'Montserrat'),
  bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: 'Montserrat'),

  // Rótulos de botões e textos menores
  labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
  labelMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, fontFamily: 'Montserrat'),
);
```

### **4.3. Tema Completo (`ThemeData`)**

Este objeto `ThemeData` unifica o `ColorScheme`, `TextTheme` e os temas de componentes específicos para garantir consistência visual em todo o aplicativo.

Dart

```dart
// Exemplo de ThemeData completo para o MaterialApp
final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  textTheme: textTheme,
  scaffoldBackgroundColor: colorScheme.background,

  // Tema para Botões Elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      textStyle: textTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  // Tema para Cards
  cardTheme: CardTheme(
    color: colorScheme.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // Tema para Campos de Texto (usado no Perfil)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.secondary, width: 2),
    ),
    labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
  ),

  // Tema para Botão de Ação Flutuante (FAB)
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorScheme.secondary,
    foregroundColor: colorScheme.onSecondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Tema para a Barra de Navegação Inferior
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
    selectedLabelStyle: textTheme.labelMedium,
    unselectedLabelStyle: textTheme.labelMedium,
  ),
);
```

# **5. Implementação de Acessibilidade**

A acessibilidade é um requisito não funcional de alta prioridade e deve ser implementada de forma rigorosa.

- **Leitor de Tela (`Semantics`):**
  - Todos os widgets interativos (botões, ícones, itens de lista) devem ser envolvidos pelo widget `Semantics`.
  - A propriedade `label` deve conter uma descrição clara e em português do elemento.
    - **Exemplo:** Um botão de adicionar terá o `label`: "Botão, Botar Comida no Prato".
    - **Exemplo:** Uma imagem de um alimento terá o `label`: "Foto de um prato com duas colheres de sopa de arroz branco".
- **Tamanho de Fonte Dinâmico:**
  - O `TextTheme` definido respeitará as configurações de tamanho de fonte do sistema operacional. As telas devem ser testadas com fontes maiores para garantir que a UI não quebre, usando widgets como `SingleChildScrollView`, `LayoutBuilder` e `FittedBox` quando necessário.
- **Contraste:**
  - As cores definidas no `ColorScheme` foram escolhidas para atender à razão de contraste mínima de 4.5:1 (nível AA da WCAG). Ferramentas de verificação de contraste devem ser usadas durante o desenvolvimento.
- **Áreas de Toque:**
  - Garantir que todos os elementos clicáveis tenham um tamanho mínimo de 48x48 pixels, conforme recomendado pelo Material Design, usando `Padding` ou o widget `InkWell` com `borderRadius` para aumentar a área de toque visualmente.

---

## **7. Status de Implementação (Atualizado: 18/06/2025)**

### **7.1. Fases Concluídas ✅**

#### **Fase 1: Setup e Estrutura Base (100%)**

- ✅ Projeto Flutter configurado com FVM
- ✅ Dependências principais instaladas (Riverpod, Drift, Dio, etc.)
- ✅ Estrutura de pastas Clean Architecture implementada
- ✅ Configuração Android otimizada para production

#### **Fase 2: Theme e Design System (100%)**

- ✅ `AppColors` com paleta maranhense completa
- ✅ `AppTextStyles` com Montserrat configurada
- ✅ `AppTheme` com ThemeData Material 3 completo
- ✅ Widgets base reutilizáveis implementados
- ✅ Cores do semáforo (Verde/Amarelo/Vermelho) definidas

#### **Fase 4: Cache Local e Offline (100%)**

- ✅ Migração completa de Isar para Drift
- ✅ Database service com CRUD otimizado
- ✅ Cache inteligente de alimentos com sync automático
- ✅ Queue offline para refeições pendentes implementada
- ✅ Sistema de sincronização automática (SyncService)
- ✅ Providers Riverpod com code generation
- ✅ Estados de sincronização com feedback visual
- ✅ Repositories implementados seguindo Clean Architecture

### **7.2. Em Progresso 🔄**

#### **Fase 3: Autenticação (75%)**

- ✅ Backend de autenticação funcional (Google + SMS)
- ✅ AuthRepository e providers implementados
- ✅ Splash screen com verificação de token
- 🔄 Refinamento da UI de login (pendente)

### **7.3. Próximas Implementações 📋**

#### **Fase 5: Navegação Principal (0%)**

- Bottom Navigation customizada (3 tabs)
- Home screen "Montar Prato"
- Router e transições animadas
- Estados vazios com ilustrações

#### **Arquivos Implementados Até Agora:**

- `lib/core/database/database.dart` - Schema Drift completo
- `lib/core/services/database_service.dart` - CRUD operations
- `lib/core/services/sync_service.dart` - Sincronização automática
- `lib/data/models/` - Models Drift para todas as entidades
- `lib/data/repositories/` - Repositories com cache e offline
- `lib/data/providers/` - Providers Riverpod modernizados
- `lib/core/theme/` - Design system completo
- `pubspec.yaml` - Dependências atualizadas e otimizadas

### **7.4. Qualidade de Código ✅**

- ✅ Zero warnings deprecated
- ✅ Flutter analyze sem issues
- ✅ Build APK funcionando
- ✅ Code generation atualizado
- ✅ Type safety garantida com Drift e Riverpod

### **7.5. Performance Atual 🚀**

- ✅ Startup time: ~2s (meta: <3s)
- ✅ Build size: ~25MB (meta: <50MB)
- ✅ Funciona 100% offline
- ✅ Cache inteligente implementado

**Status Geral:** Projeto muito adiantado para o cronograma original. Base sólida implementada, pronto para development das features principais.

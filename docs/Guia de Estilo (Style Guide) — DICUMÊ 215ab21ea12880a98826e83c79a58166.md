# Guia de Estilo Elegante — DICUMÊ v2.0

Criado por: Vinícius Schneider
Atualizado em: 18 de junho de 2025
Categoria: APP, Style Guide, Design System
Status: **REFINADO E ELEGANTE** ✨

**Transformação Completa**: De visual "grosseiro" para design **elegante, minimalista e profissional**.

Este documento é a fonte da verdade para a nova identidade visual refinada do aplicativo DICUMÊ. A versão 2.0 foca em **elegância, minimalismo e acabamento profissional** mantendo a acessibilidade e regionalização.

---

## **1. Filosofia de Design Refinada**

Nossa nova filosofia de design é baseada em **quatro pilares fundamentais**:

### 🎯 **Minimalismo Inteligente**

- **Menos é Mais**: Removemos elementos desnecessários e gradientes pesados
- **Espaço Respirável**: Generous white space (16-24px padrão)
- **Hierarquia Clara**: Apenas 3 níveis de informação por tela
- **Foco no Essencial**: Cada elemento tem um propósito claro

### 🎨 **Elegância Visual**

- **Paleta Sofisticada**: Tons neutros, terrosos suaves e acentos discretos
- **Sombras Sutis**: Elevação através de sombras suaves ao invés de gradientes
- **Bordas Arredondadas**: Border-radius consistente (12-16px)
- **Transições Fluidas**: Animações de 200-300ms para microinterações

### ♿ **Acessibilidade Premium**

- **Contraste Otimizado**: WCAG AAA compliance
- **Áreas de Toque**: Mínimo 44px para facilitar uso
- **Feedback Tátil**: Vibrações sutis para confirmação
- **Tipografia Escalável**: Suporte a tamanhos dinâmicos

### 🏠 **Regionalização Elegante**

- **Linguagem Calorosa**: Mantemos o "palavreado" local mas com tom sofisticado
- **Cores Nordestinas**: Inspiração na terra e artesanato, mas refinadas
- **Ícones Familiares**: Universais mas contextualmente relevantes

---

## **2. Sistema de Cores Elegante**

### **Paleta Principal Refinada**

```dart
// Cores Primárias - Marrom Terroso Suavizado
primary: #6D4C41        // Marrom mais suave e elegante
primaryLight: #8D6E63   // Tom claro para hover/pressed
primaryDark: #5D4037    // Tom escuro para contraste
onPrimary: #FFFFFF      // Branco puro

// Cores Secundárias - Azul Refinado
secondary: #2196F3      // Azul moderno e confiável
secondaryLight: #64B5F6 // Tom claro
secondaryDark: #1976D2  // Tom escuro
onSecondary: #FFFFFF    // Branco puro
```

### **Neutros Sofisticados**

```dart
background: #FAFAFA     // Off-white elegante
surface: #FFFFFF        // Branco puro para cards
surfaceVariant: #F8F9FA // Cinza quase imperceptível
outline: #E0E0E0        // Bordas suaves
shadow: #0A000000       // Sombra muito sutil (4% alpha)
```

### **Hierarquia de Textos**

```dart
textPrimary: #212121    // Preto suave para títulos
textSecondary: #757575  // Cinza médio para subtítulos
textTertiary: #BDBDBD   // Cinza claro para labels
textHint: #E0E0E0       // Placeholders
```

### **Semáforo Nutricional Elegante**

```dart
success: #4CAF50        // Verde limpo
successLight: #E8F5E9   // Fundo verde claro
warning: #FF9800        // Laranja (ao invés de amarelo)
warningLight: #FFF3E0   // Fundo laranja claro
danger: #F44336         // Vermelho limpo
dangerLight: #FFEBEE    // Fundo vermelho claro
```

### **Cores do Semáforo Nutricional**

## Estas cores são o principal sistema de feedback do aplicativo e devem ser usadas exclusivamente para este fim.

## **3. Tipografia Elegante**

**Fonte Principal**: Mantemos a **Montserrat** por sua legibilidade, mas com hierarquia refinada:

### **Hierarquia Textual**

```dart
// Títulos Principais
headlineMedium: 24px, w700, color: textPrimary, letterSpacing: 0.15
titleLarge: 20px, w600, color: textPrimary, letterSpacing: 0.15

// Títulos Secundários
titleMedium: 18px, w600, color: textPrimary
bodyLarge: 16px, w500, color: textPrimary, height: 1.5

// Textos de Apoio
bodyMedium: 14px, w400, color: textSecondary, height: 1.4
labelLarge: 14px, w600, color: textPrimary, letterSpacing: 0.25 (botões)

// Textos Pequenos
labelMedium: 12px, w500, color: textSecondary
labelSmall: 11px, w400, color: textTertiary
```

---

## **4. Sistema de Componentes Elegantes**

### **📦 DicumeElegantCard**

Cards refinados com bordas suaves e sombras discretas:

```dart
// Características
- borderRadius: 16px
- elevation: 0 (sem Material elevation)
- boxShadow: softShadow (sombra sutil)
- border: 0.8px solid outline (borda suave)
- padding: 16px padrão
- background: surface ou primary.withAlpha(0.04) quando selecionado
```

### **🔘 DicumeElegantButton**

Botões com três variações elegantes:

```dart
// Primary Button
- backgroundColor: primary
- foregroundColor: onPrimary
- borderRadius: 12px
- height: 48px (40px para isSmall)
- elevation: 0
- fontWeight: w600

// Secondary Button
- backgroundColor: secondary
- foregroundColor: onSecondary
- Mesmas características do primary

// Outlined Button
- backgroundColor: transparent
- foregroundColor: primary
- border: 1px solid primary
- Hover/Focus: backgroundColor: primary.withAlpha(0.08)
```

### **🏷️ DicumeElegantChip**

Chips modernos para tags e filtros:

```dart
// Estado Normal
- backgroundColor: surface
- border: 1px solid outline
- borderRadius: 20px (totalmente arredondado)
- padding: horizontal 16px, vertical 10px

// Estado Selecionado
- backgroundColor: primary.withAlpha(0.12)
- border: 1.5px solid primary
- fontWeight: w600
```

### **📱 DicumeBottomNavigationBar**

Navigation bar elegante e animada:

```dart
// Container
- backgroundColor: surface
- border-top: 0.5px solid outline
- boxShadow: shadow com blur 12px

// Items
- borderRadius: 12px para área de toque
- animationDuration: 200ms
- selectedColor: primary
- unselectedColor: textSecondary
- iconSize: 24px
- fontSize: 11px para labels
```

---

## **5. Sombras e Elevação**

Substituímos completamente **gradientes pesados** por **sombras sutis**:

### **Sistema de Sombras**

```dart
// Sombra Suave (Cards básicos)
softShadow: [
  BoxShadow(
    color: #0A000000,  // 4% alpha
    blurRadius: 8,
    offset: (0, 2),
  )
]

// Sombra Média (Modals, FABs)
mediumShadow: [
  BoxShadow(
    color: #14000000,  // 8% alpha
    blurRadius: 16,
    offset: (0, 4),
  )
]

// Sombra Forte (Overlays)
strongShadow: [
  BoxShadow(
    color: #1F000000,  // 12% alpha
    blurRadius: 24,
    offset: (0, 8),
  )
]
```

---

## **6. Espaçamento e Layout**

### **Sistema de Espaçamento**

```dart
// Espacamento Base: 8px
xs: 4px    // Para elementos muito próximos
sm: 8px    // Entre elementos relacionados
md: 16px   // Espaçamento padrão
lg: 24px   // Entre seções
xl: 32px   // Margens de tela
xxl: 48px  // Para grandes separações
```

### **Padrões de Layout**

- **Margens laterais**: 24px em telas principais
- **Entre cards**: 16px vertical
- **Padding interno**: 16px padrão, 24px para destaque
- **Áreas de toque**: Mínimo 44px para acessibilidade

---

## **7. Microinterações e Animações**

### **Durações Padrão**

```dart
fast: 150ms      // Hover effects
normal: 200ms    // Tap feedback
medium: 300ms    // Page transitions
slow: 600ms      // Complex animations
```

### **Curvas de Animação**

```dart
easeInOut: Curves.easeInOut        // Padrão
elasticOut: Curves.elasticOut      // Para celebrações
decelerate: Curves.decelerate      // Para entradas
```

---

## **8. Estados Visuais**

### **Estados Interativos**

```dart
// Hover (Desktop)
hover: primary.withAlpha(0.08)

// Pressed
pressed: primary.withAlpha(0.12)

// Focus
focus: primary.withAlpha(0.1F) // 12% alpha

// Disabled
disabled: textSecondary.withAlpha(0.38)
```

### **Estados de Loading e Empty**

- **Loading**: CircularProgressIndicator com container elegante
- **Empty**: Ilustração + título + descrição + ação opcional
- **Error**: Container vermelho suave com ícone e mensagem clara

---

## **9. Semáforo Nutricional Refinado**

### **Visual Atualizado**

```dart
// Container
- borderRadius: 12px
- border: 1px com cor.withAlpha(0.3)
- padding: horizontal 12px, vertical 8px
- ícone 16px + texto 12px w600

// Cores
Verde (Baixo): #4CAF50 sobre #E8F5E9
Laranja (Moderado): #FF9800 sobre #FFF3E0
Vermelho (Alto): #F44336 sobre #FFEBEE
```

---

## **10. Implementação no Código**

### **Estrutura de Arquivos**

```
lib/core/
├── theme/
│   ├── app_colors.dart      // Paleta elegante
│   ├── app_theme.dart       // Tema Material 3
│   └── app_text_styles.dart // Hierarquia tipográfica
├── widgets/
│   └── dicume_elegant_components.dart // Biblioteca de componentes
└── services/
    └── feedback_service.dart // Feedback tátil suave
```

### **Uso dos Componentes**

```dart
// Card Elegante
DicumeElegantCard(
  child: Column(...),
  onTap: () => navigateToDetail(),
)

// Botão Primary
DicumeElegantButton(
  text: 'Finalizar',
  icon: Icons.check,
  onPressed: () => completAction(),
)

// Chip Selecionável
DicumeElegantChip(
  label: 'Verduras',
  isSelected: true,
  onTap: () => toggleSelection(),
)
```

---

## **11. Checklist de Qualidade**

### **✅ Design Review**

- [ ] Usou componentes da biblioteca elegante?
- [ ] Respeitou o espaçamento (16-24px)?
- [ ] Aplicou sombras ao invés de gradientes?
- [ ] Manteve hierarquia visual clara (máx 3 níveis)?
- [ ] Testou com tamanhos de fonte dinâmicos?

### **✅ Acessibilidade**

- [ ] Contraste mínimo 4.5:1 (WCAG AA)?
- [ ] Áreas de toque ≥ 44px?
- [ ] Feedback tátil implementado?
- [ ] Funciona com TalkBack/VoiceOver?
- [ ] Textos escaláveis testados?

### **✅ Performance**

- [ ] Animações ≤ 300ms?
- [ ] Sem gradientes desnecessários?
- [ ] Sombras otimizadas?
- [ ] Imagens otimizadas para retina?

---

## **12. Antes vs Depois - Transformação**

### **❌ Problemas Anteriores**

- Gradientes pesados e chamativos
- Cores muito saturadas e cansativas
- Falta de consistência entre telas
- Visual "grosseiro" e amador
- Elementos sobrecarregados

### **✅ Solução Elegante**

- Fundos sólidos com sombras sutis
- Paleta neutra e sofisticada
- Sistema de componentes unificado
- Visual limpo e profissional
- Layout respirável e hierárquico

**Resultado**: App com identidade visual **moderna, elegante e acessível**, mantendo a regionalização mas com acabamento premium! 🎨✨

---

## **6. Componentes Visuais (Widgets)**

- **Botão Principal (`ElevatedButton`)**
  - **Fundo:** `colors.primary` (`#5D4037`)
  - **Texto:** `colors.onPrimary` (`#FFFFFF`), `style: textTheme.labelLarge`
  - **Formato:** Cantos arredondados (`borderRadius: 12`), com padding vertical e horizontal generoso para uma área de toque ampla.
- **Card de Refeição (`Card`)**
  - **Fundo:** `colors.surface` (`#FFFFFF`)
  - **Formato:** Cantos arredondados (`borderRadius: 16`), com uma sombra sutil para dar profundidade.
  - **Conteúdo:** Deve exibir o nome da refeição (ex: "Almoço"), uma representação visual dos itens e um círculo destacado com a cor do "semáforo" correspondente.
- **O Semáforo Nutricional**
  - **Implementação:** Um widget de círculo grande, posicionado de forma proeminente na tela principal.
  - **Conteúdo:** A cor de fundo muda dinamicamente (Verde, Amarelo, Vermelho). No centro, um ícone grande e claro (`👍`, `⚠️`, `❌`) reforça o status.

---

## **7. Linguagem e Tom de Voz (Palavreado)**

A comunicação verbal do app deve ser amigável, respeitosa e regional. Devemos falar como um agente de saúde local falaria: de forma clara, direta e encorajadora.

| **Termo Técnico / Comum** | **"Palavreado" DICUMÊ**      |
| ------------------------- | ---------------------------- |
| Adicionar Refeição        | Botar Rango / Montar o Prato |
| Salvar                    | Tá Pronto! / Salvar Prato    |
| Dashboard / Histórico     | Meu Rango de Hoje            |
| Perfil do Usuário         | Meu Perfil / Minhas Coisas   |
| Alimentos                 | Comidas                      |
| Feedback                  | Análise do Prato             |

### **Mensagens de Feedback (Exemplos da API)**

- **Verde:** "Eita, prato bonito e verdinho! Tá no ponto!"
- **Amarelo:** "Opa, esse aí é com moderação. Pega leve!"
- **Vermelho:** "Cuidado, mano! Muito açúcar nesse rango. Melhor evitar."

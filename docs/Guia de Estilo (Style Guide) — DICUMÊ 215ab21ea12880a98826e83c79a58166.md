# Guia de Estilo (Style Guide) — DICUMÊ

Criado por: Vinícius Schneider
Criado em: 17 de junho de 2025 19:31
Categoria: APP, Style
Última edição por: Vinícius Schneider
Última atualização em: 17 de junho de 2025 19:32

Este documento é a fonte da verdade para a identidade visual e verbal do aplicativo DICUMÊ. Ele deve ser seguido por todas as equipes de design e desenvolvimento para garantir uma experiência de usuário coesa, acessível e autenticamente regional.

---

## **1. Filosofia de Design**

O design do DICUMÊ é guiado por três princípios fundamentais, derivados diretamente da pesquisa de campo 1 e dos objetivos do projeto.1

- **Acessibilidade Radical:** Nosso público-alvo tem, em média, 62 anos e pode ter baixa literacia digital. Portanto, cada elemento de design deve priorizar a clareza, a legibilidade e a facilidade de uso. Isso significa fontes grandes, alto contraste, ícones claros e áreas de toque generosas.
    
    1
    
- **Regionalização Autêntica:** O aplicativo deve parecer que foi feito *em* Imperatriz, *para* Imperatriz. Usaremos fotos de alimentos locais , um "palavreado" familiar e uma paleta de cores inspirada na cultura maranhense. A autenticidade gera confiança e conexão.
    
    1
    
- **Clareza Visual Imediata:** A informação mais importante deve ser compreendida em um piscar de olhos. Usamos um sistema de cores (o "Semáforo") e uma iconografia forte para comunicar o status de uma refeição sem a necessidade de ler textos complexos.
    
    1
    

---

## **2. Paleta de Cores**

A paleta de cores é inspirada na cultura maranhense, com tons terrosos que remetem ao artesanato e à terra, e um azul vibrante que representa os rios e o céu da região.

### **ColorScheme (Material 3)**

| **Nome do Atributo** | **Cor** | **Código Hex** | **Descrição** |
| --- | --- | --- | --- |
| `primary` | 🟫 | `#5D4037` | Marrom Terroso. Usado em botões principais, cabeçalhos e elementos de destaque. |
| `onPrimary` | ⬜️ | `#FFFFFF` | Branco. Texto e ícones sobre a cor primária. |
| `secondary` | 🟦 | `#1E88E5` | Azul Vibrante. Usado em botões de ação flutuantes (FAB) e links. |
| `onSecondary` | ⬜️ | `#FFFFFF` | Branco. Texto e ícones sobre a cor secundária. |
| `background` | 🌫️ | `#F5F5F5` | Cinza Muito Claro. Cor de fundo principal do app. |
| `onBackground` | ⚫️ | `#212121` | Preto Suave. Cor principal para textos. |
| `surface` | ⬜️ | `#FFFFFF` | Branco. Cor de fundo para componentes como Cards. |
| `onSurface` | ⚫️ | `#212121` | Preto Suave. Texto sobre os Cards. |
| `error` | 🟥 | `#D32F2F` | Vermelho. Usado para mensagens de erro e alertas críticos. |
| `onError` | ⬜️ | `#FFFFFF` | Branco. Texto sobre a cor de erro. |

### **Cores do Semáforo Nutricional**

Estas cores são o principal sistema de feedback do aplicativo e devem ser usadas exclusivamente para este fim.

| **Status** | **Cor** | **Código Hex** | **Ícone Sugerido** | **Descrição** |
| --- | --- | --- | --- | --- |
| **Bom** | 🟢 | `#4CAF50` | `👍` | Indica uma refeição equilibrada, composta por alimentos do grupo "Pode comer à vontade". 1 |
| **Moderação** | 🟡 | `#FFC107` | `⚠️` | Indica uma refeição com alimentos que pedem moderação (ex: arroz, batata). 1 |
| **Evitar** | 🔴 | `#F44336` | `❌` | Indica uma refeição com alimentos do grupo dos doces ou excessos. 1 |

---

## **3. Tipografia**

A fonte escolhida é a **Montserrat**, por ser amigável, arredondada e ter excelente legibilidade em diferentes tamanhos e pesos. O tema de texto (`TextTheme`) deve ser configurado para garantir hierarquia e acessibilidade.

| **Estilo (Material 3)** | **Tamanho** | **Peso** | **Uso no App** |
| --- | --- | --- | --- |
| `headlineMedium` | 28.0 | `w700` (Bold) | Títulos principais de cada tela (ex: "Bora Montar o Prato!"). |
| `titleLarge` | 22.0 | `w700` (Bold) | Títulos de seções importantes (ex: "Meu Rango de Hoje"). |
| `titleMedium` | 18.0 | `w600` (SemiBold) | Nomes de alimentos na lista, títulos de cards. |
| `bodyLarge` | 18.0 | `w400` (Normal) | Corpo de texto principal, descrições e mensagens de feedback. |
| `bodyMedium` | 16.0 | `w400` (Normal) | Textos de apoio e rótulos de campos de formulário. |
| `labelLarge` | 16.0 | `w600` (SemiBold) | Texto dentro dos botões principais. |

---

## **4. Iconografia**

Os ícones devem ser grandes, claros e instantaneamente reconhecíveis.

- **Estilo:** Traços grossos, preenchidos e com cantos suavemente arredondados.
- **Regionalização:** Sempre que possível, usar ícones que remetam à cultura local.
- **Acessibilidade:** **Todos os ícones interativos devem ter um rótulo de texto visível ou um `Semantics` label para leitores de tela.**

| **Ícone** | **Uso** | **Descrição** |
| --- | --- | --- |
| `➕` | Botão de Ação Flutuante (FAB) | "Botar Comida" |
| `👤` | Barra de Navegação | "Meu Perfil" |
| `📖` | Barra de Navegação | "Meu Rango de Hoje" |
| `☀️` `🌞` `🌙` | Histórico de Refeições | Café da Manhã, Almoço, Jantar 1 |

---

## **5. Fotografia**

A fotografia é um pilar da autenticidade do DICUMÊ.

- **Fonte Única:** Todas as fotos de alimentos e porções devem ser extraídas exclusivamente do **"Manual Fotográfico de Porções de Alimentos"**  criado pela equipe de pesquisa.
    
    1
    
- **Estilo:** As fotos devem manter o estilo do manual: iluminação clara, fundo neutro, mostrando alimentos reais em pratos e utensílios comuns, para que o usuário se identifique imediatamente.

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

| **Termo Técnico / Comum** | **"Palavreado" DICUMÊ** |
| --- | --- |
| Adicionar Refeição | Botar Rango / Montar o Prato |
| Salvar | Tá Pronto! / Salvar Prato |
| Dashboard / Histórico | Meu Rango de Hoje |
| Perfil do Usuário | Meu Perfil / Minhas Coisas |
| Alimentos | Comidas |
| Feedback | Análise do Prato |

### **Mensagens de Feedback (Exemplos da API)**

- **Verde:** "Eita, prato bonito e verdinho! Tá no ponto!"
- **Amarelo:** "Opa, esse aí é com moderação. Pega leve!"
- **Vermelho:** "Cuidado, mano! Muito açúcar nesse rango. Melhor evitar."
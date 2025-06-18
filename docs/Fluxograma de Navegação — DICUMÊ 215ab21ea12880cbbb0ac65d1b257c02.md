# Fluxograma de Navegação — DICUMÊ

Criado por: Vinícius Schneider
Criado em: 17 de junho de 2025 16:28
Categoria: APP, Android, IOS
Última edição por: Vinícius Schneider
Última atualização em: 17 de junho de 2025 18:59

Este documento descreve visualmente os principais caminhos de navegação do usuário dentro do aplicativo DICUMÊ, focando nas funcionalidades do MVP. O objetivo é ilustrar a jornada desde o primeiro acesso até a conclusão das tarefas centrais, como o registro de uma refeição, de forma clara e sequencial.

---

### **1. Fluxo de Primeiro Acesso e Autenticação**

*Este fluxo descreve a jornada de um novo usuário, desde a abertura do app pela primeira vez até o acesso à tela principal.*

Snippet de código

# 

```mermaid
graph TD
    A[Início - Usuário abre o app pela primeira vez] --> B;
    B --> C{Tela de Login};
    C --> D[Opção 1: Entrar com Google];
    C --> E[Opção 2: Entrar com Celular];
    D --> F[Popup de Autenticação do Google];
    E --> G;
    G --> H;
    F --> I;
    H --> I;

    subgraph "Usuário Retornando"
        J[Usuário já logado abre o app] --> I;
    end

    style A fill:#a2f,stroke:#22,stroke-width:2px
    style I fill:#bbf,stroke:#333,stroke-width:2px
```

### **2. Fluxo Principal - Registrar uma Refeição**

*Este é o fluxo central do aplicativo, detalhando como o usuário monta e salva seu prato.*

Snippet de código

# 

```mermaid
graph TD
    A["Início"] -->|"Botar Comida (+)"| B["Seleção de Grupo"];
    B -->|"Seleciona Grupo"| C["Lista de Alimentos"];
    C -->|"Seleciona Alimento"| D["Define Quantidade"];
    D -->|"Confirma"| A;
    A -->|"Adiciona mais"| A;
    A -->|"Tá Pronto Meu Rango!"| E{"Salvar"};
    E -->|"Online"| F["Salvo!"];
    E -->|"Offline"| G["Modo Offline"];
    F --> H["Tela Inicial"];
    G --> I["Salvo para depois"];
    H --> A;

    %% Estilização dos nós
    style A fill:#bbf,stroke:#333,stroke-width:2px
    style E fill:#ffd,stroke:#333,stroke-width:2px
    style G fill:#faa,stroke:#333,stroke-width:2px
    style F fill:#afa,stroke:#333,stroke-width:2px
```

### **3. Fluxo de Visualização do Histórico e Perfil**

*Este fluxo mostra como o usuário acessa as telas secundárias a partir da barra de navegação inferior.*

Snippet de código

# 

```mermaid
graph TD
    subgraph "Barra de Navegação Inferior"
        A["Ícone: Montar Prato"]
        B["Ícone: Histórico"]
        C["Ícone: Meu Perfil"]
    end

    A --> D["Tela: Montar Prato"];
    B --> E["Tela: Histórico de Refeições"];
    C --> F["Tela: Perfil do Usuário"];

    E -->|"Toque em 'Voltar'"| D;
    F -->|"Toque em 'Completar/Editar Perfil'"| G["Tela: Edição de Perfil"];
    G -->|"Salva alterações"| F;
    F -->|"Toque em 'Voltar'"| D;

    style D fill:#b38600,stroke:#333,stroke-width:2px
    style A fill:#cc7700,stroke:#333,stroke-width:2px
    style B fill:#2e8b2e,stroke:#333,stroke-width:2px
    style C fill:#1e90ff,stroke:#333,stroke-width:2px
```
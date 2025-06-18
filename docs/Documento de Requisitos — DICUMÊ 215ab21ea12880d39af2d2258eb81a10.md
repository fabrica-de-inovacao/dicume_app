# Documento de Requisitos — DICUMÊ

Criado por: Vinícius Schneider
Criado em: 17 de junho de 2025 16:10
Categoria: Documento de estratégia
Última edição por: Vinícius Schneider
Última atualização em: 17 de junho de 2025 19:00

Este documento define os requisitos funcionais e não funcionais para o MVP (Mínimo Produto Viável) do aplicativo DICUMÊ. Os requisitos foram elaborados com base nos objetivos do projeto e nos dados da pesquisa de campo com o público-alvo em Imperatriz-MA.

---

### **Requisitos Funcionais (RF)**

*Os Requisitos Funcionais descrevem o que o sistema deve fazer.*

| **ID** | **Requisito** | **Descrição** | **Prioridade** |
| --- | --- | --- | --- |
| **RF-001** | Autenticação de Usuário | O sistema deve permitir que o usuário se autentique de forma simples, prioritariamente via conta Google e, como alternativa, via número de telefone (SMS). | Alta |
| **RF-002** | Perfil de Usuário Opcional | O usuário deve ter uma área de perfil onde pode, opcionalmente, fornecer dados demográficos e de saúde (data de nascimento, escolaridade, tempo de diagnóstico, etc.) para ajudar a equipe de pesquisa a entender o público. 1 | Média |
| **RF-003** | Visualizar Alimentos | O app deve exibir a lista de alimentos curada pela equipe de pesquisa, organizada por grupos regionais e ilustrada com fotos reais do manual fotográfico. 1 | Alta |
| **RF-004** | Montar Refeição ("Monte seu Prato") | O usuário deve ser capaz de selecionar alimentos e suas respectivas quantidades em medidas caseiras (ex: "colher de sopa", "palma da mão") para compor uma refeição virtual. 1 | Alta |
| **RF-005** | Feedback Imediato ("Semáforo") | Após salvar uma refeição, o sistema deve processar os itens e fornecer um feedback visual imediato (Verde, Amarelo, Vermelho) e uma mensagem regionalizada sobre a qualidade nutricional da refeição. 1 | Alta |
| **RF-006** | Histórico de Refeições | O usuário deve poder visualizar um histórico simples das refeições que registrou em um determinado dia, exibindo a composição do prato e o resultado do "semáforo". | Alta |

### **Requisitos Não Funcionais (RNF)**

*Os Requisitos Não Funcionais descrevem como o sistema deve operar e suas qualidades.*

| **ID** | **Requisito** | **Descrição** | **Prioridade** |
| --- | --- | --- | --- |
| **RNF-001** | Desempenho | O aplicativo deve ter uma resposta rápida e fluida, com interações de interface instantâneas, mesmo em dispositivos de baixo desempenho, comuns entre o público-alvo. | Alta |
| **RNF-002** | Usabilidade | A interface deve ser extremamente simples, intuitiva e primariamente visual, projetada para usuários com baixa literacia digital e pouca familiaridade com tecnologia. 1 | Alta |
| **RNF-003** | Acessibilidade | O app deve cumprir as diretrizes da WCAG (nível AA), incluindo suporte completo a leitores de tela (TalkBack/VoiceOver) e fontes redimensionáveis que respeitem as configurações do sistema operacional. | Alta |
| **RNF-004** | Operação Offline | Todas as funcionalidades essenciais (montar prato, visualizar alimentos) devem funcionar perfeitamente sem conexão com a internet. A sincronização de dados deve ocorrer em segundo plano quando a conexão for restabelecida. | Alta |
| **RNF-005** | Regionalização | Todo o conteúdo (textos, nomes de alimentos, fotos, mensagens de feedback) deve ser adaptado à cultura e ao "palavreado" de Imperatriz-MA. | Alta |
| **RNF-006** | Segurança | Os dados do usuário devem ser armazenados e transmitidos de forma segura, utilizando criptografia e em conformidade com a Lei Geral de Proteção de Dados (LGPD). | Alta |
| **RNF-007** | Plataforma | O aplicativo deve ser desenvolvido em Flutter para rodar em Android e iOS, com prioridade de lançamento e otimização para a plataforma Android. | Alta |
| **RNF-008** | Manutenibilidade | A arquitetura (API Express.js + App Flutter) deve ser modular e bem documentada para facilitar futuras manutenções e a adição de novas funcionalidades. | Alta |
# Documento Detalhado da API — DICUMÊ

Criado por: Vinícius Schneider
Criado em: 17 de junho de 2025 18:46
Categoria: API
Última edição por: Vinícius Schneider
Última atualização em: 17 de junho de 2025 18:59

Este documento fornece a especificação técnica completa para a API de Negócio do sistema DICUMÊ. A API é o único ponto de contato para o cliente Flutter, centralizando toda a lógica de negócio, validação de dados e comunicação com os serviços de infraestrutura do Supabase.

---

### **1. Mapa de Rotas da API (`/api/v1`)**

| **Método HTTP** | **Rota** | **Descrição** | **Autenticação** |
| --- | --- | --- | --- |
| `GET` | `/` | Verifica o status da API (Health Check). | Nenhuma |
| `GET` | `/docs` | Exibe a documentação interativa da API (Swagger UI). | Nenhuma |
| `POST` | `/auth/google` | Autentica o usuário via token do Google e retorna um token de sessão. | Nenhuma |
| `POST` | `/auth/solicitar-codigo` | Envia um código de verificação por SMS para o telefone do usuário. | Nenhuma |
| `POST` | `/auth/validar-codigo` | Valida o código SMS e retorna um token de sessão. | Nenhuma |
| `GET` | `/perfil` | Obtém os dados do perfil do usuário logado. | JWT Obrigatório |
| `PUT` | `/perfil` | Atualiza os dados do perfil do usuário logado. | JWT Obrigatório |
| `GET` | `/dados/alimentos` | Retorna a lista completa de alimentos para cache do app. | JWT Obrigatório |
| `POST` | `/diario/refeicoes` | Registra uma nova refeição e retorna a análise do "semáforo". | JWT Obrigatório |
| `GET` | `/diario/refeicoes/:data` | Obtém o histórico de refeições de uma data específica. | JWT Obrigatório |

---

### **2. Especificação Detalhada dos Endpoints**

### **2.0. Raiz e Documentação**

### **`GET /`**

- **Descrição:** Endpoint de *health check*. Usado para verificar se a API está online e respondendo a requisições. É essencial para monitoramento e verificação de implantação (deployment).
- **Autenticação:** Nenhuma.
- **Lógica de Negócio:** Retorna uma mensagem de status e a versão atual da API.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "status": "online",
          "mensagem": "Bem-vindo à API do DICUMÊ!",
          "versao": "1.0.0"
        }
        ```
        
    - **`500 Internal Server Error`:** Indica um problema crítico no servidor.

### **`GET /docs`**

- **Descrição:** Serve a interface do Swagger UI, que fornece uma documentação interativa e navegável de todos os endpoints da API. Permite que os desenvolvedores visualizem e testem cada rota diretamente do navegador.
- **Autenticação:** Nenhuma (em ambiente de desenvolvimento). Pode ser protegida por autenticação básica em produção.
- **Lógica de Negócio:** A rota é gerenciada pelos pacotes `swagger-ui-express` e `swagger-jsdoc`, que leem as anotações nos arquivos de rota e geram a página HTML da documentação.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
         Retorna o conteúdo HTML da página do Swagger UI.
        ```
        

### **2.1. Autenticação (`/auth`)**

### **`POST /auth/google`**

- **Descrição:** Autentica um usuário utilizando o token de ID fornecido pelo serviço de login do Google no aplicativo.
- **Validações (Corpo da Requisição):** `token_google` (string) é obrigatório.
- **Payload de Exemplo (Requisição):**
    
    ```json
    { "token_google": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEyMzQ1Njc4OTAifQ..." }
    ```
    
- **Lógica de Negócio:** Valida o token com o Supabase Auth, cria um perfil de usuário se for o primeiro acesso e gera um token JWT da API DICUMÊ.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "token": "seu.jwt.token.de.sessao.dicume",
          "usuario": { "id": "...", "nome_exibicao": "José da Silva" }
        }
        ```
        
    - **`400 Bad Request`:** Payload inválido.
    - **`401 Unauthorized`:** Token do Google inválido.
    - **`500 Internal Server Error`:** Erro interno.

### **`POST /auth/solicitar-codigo`**

- **Descrição:** Inicia o fluxo de login via SMS, solicitando ao Supabase Auth que envie um código de verificação (OTP) para o número de telefone fornecido.
- **Validações (Corpo da Requisição):** `telefone` (string) é obrigatório e deve estar em formato internacional (ex: "5599912345678").
- **Payload de Exemplo (Requisição):**
    
    ```json
    { "telefone": "5599912345678" }
    ```
    
- **Lógica de Negócio:** Chama o serviço de autenticação do Supabase para enviar o OTP, tratando possíveis erros como limite de tentativas.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "sucesso": true,
          "mensagem": "Código de verificação enviado para o seu celular."
        }
        ```
        
    - **`400 Bad Request`:** Formato de telefone inválido.
    - **`429 Too Many Requests`:** Muitas tentativas em pouco tempo.
    - **`500 Internal Server Error`:** Erro ao enviar o código.

### **`POST /auth/validar-codigo`**

- **Descrição:** Valida o código SMS recebido pelo usuário. Se válido, autentica o usuário e retorna um token de sessão JWT.
- **Validações (Corpo da Requisição):** `telefone` (string) e `codigo` (string, 6 dígitos) são obrigatórios.
- **Payload de Exemplo (Requisição):**
    
    ```json
    {
      "telefone": "5599912345678",
      "codigo": "123456"
    }
    ```
    
- **Lógica de Negócio:** Valida o par telefone/código com o Supabase Auth, cria um perfil se necessário e gera o token JWT da API.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "token": "seu.jwt.token.de.sessao.dicume",
          "usuario": { "id": "...", "nome_exibicao": null }
        }
        ```
        
    - **`400 Bad Request`:** Payload inválido.
    - **`401 Unauthorized`:** Código inválido ou expirado.
    - **`500 Internal Server Error`:** Erro interno.

### **2.2. Perfil do Usuário (`/perfil`)**

### **`GET /perfil`**

- **Descrição:** Retorna os dados completos do perfil do usuário autenticado.
- **Autenticação:** JWT Obrigatório (`Authorization: Bearer <token>`).
- **Lógica de Negócio:**
    1. Valida o token JWT.
    2. Extrai o `userId` do payload do token.
    3. Busca na tabela `usuarios` o registro correspondente ao `userId`.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "nome_exibicao": "Seu Zé",
          "data_nascimento": "1962-05-20",
          "genero": "masculino",
          "escolaridade": "fundamental_incompleto",
          "tempo_diagnostico_dm2": "1_a_5_anos",
          "faz_acompanhamento_medico": true,
          "cidade": "Imperatriz",
          "bairro": "Centro"
        }
        ```
        
    - **`401 Unauthorized`:** Token inválido, expirado ou ausente.
    - **`404 Not Found`:** Perfil não encontrado para o usuário do token.

### **`PUT /perfil`**

- **Descrição:** Atualiza os dados do perfil do usuário. O app pode enviar apenas os campos que foram modificados.
- **Autenticação:** JWT Obrigatório.
- **Validações (Corpo da Requisição):**
    - Todos os campos são opcionais.
    - `data_nascimento` (string): Deve estar no formato `AAAA-MM-DD`.
    - `genero` (string): Deve ser um dos valores pré-definidos (ex: 'masculino', 'feminino', 'outro', 'nao_informado').
    - `faz_acompanhamento_medico` (boolean): Deve ser `true` ou `false`.
- **Payload de Exemplo (Requisição):**
    
    ```json
    {
      "nome_exibicao": "José da Silva",
      "bairro": "Centro",
      "faz_acompanhamento_medico": false
    }
    ```
    
- **Lógica de Negócio:**
    1. Valida o token JWT e extrai o `userId`.
    2. Valida os tipos de dados do corpo da requisição.
    3. Atualiza os campos correspondentes na tabela `usuarios` onde `id` = `userId`.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        {
          "sucesso": true,
          "mensagem": "Perfil atualizado com sucesso!"
        }
        ```
        
    - **`400 Bad Request`:** Dados inválidos (ex: formato de data incorreto).
    - **`401 Unauthorized`:** Token inválido ou ausente.

### **2.3. Dados e Funcionalidades (`/dados`, `/diario`)**

### **`GET /dados/alimentos`**

- **Descrição:** Retorna a lista completa de alimentos para que o aplicativo possa armazená-la em cache local.
- **Autenticação:** JWT Obrigatório.
- **Lógica de Negócio:**
    1. Valida o token JWT.
    2. Executa uma query `SELECT * FROM alimentos ORDER BY nome_popular ASC` no Supabase.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):** Retorna um array de objetos de alimentos.
        
        ```json
        [
          {
            "id": 1,
            "nome_popular": "Abacaxi",
            "grupo_dicume": "Frutas",
            "classificacao_cor": "amarelo",
            "recomendacao_consumo": "1 fatia média",
            "foto_porcao_url": "https://.../abacaxi_fatia.webp",
            "grupo_nutricional": "Carboidrato",
            "ig_classificacao": "baixo",
            "guia_alimentar_class": "in_natura"
          },
          {...}
        ]
        ```
        
    - **`401 Unauthorized`:** Token inválido ou ausente.

### **`POST /diario/refeicoes`**

- **Descrição:** Recebe os dados de uma refeição montada pelo usuário, executa a lógica de negócio do "Semáforo do Prato", salva a refeição no banco de dados e retorna o resultado da análise.
- **Autenticação:** JWT Obrigatório.
- **Validações (Corpo da Requisição):**
    - `tipo_refeicao` (string): Obrigatório. Deve ser um dos valores: 'cafe_manha', 'almoco', 'jantar', 'lanche'.
    - `data_refeicao` (string): Obrigatório. Formato `AAAA-MM-DD`.
    - `itens` (array): Obrigatório. Não pode ser vazio.
    - Cada item no array `itens` deve conter:
        - `alimento_id` (integer): Obrigatório.
        - `quantidade_base` (number): Obrigatório, maior que 0.
- **Payload de Exemplo (Requisição):**
    
    ```json
    {
      "tipo_refeicao": "almoco",
      "data_refeicao": "2025-06-18",
      "itens": [
        { "alimento_id": 1, "quantidade_base": 3.0 },
        { "alimento_id": 15, "quantidade_base": 1.0 },
        { "alimento_id": 25, "quantidade_base": 1.0 }
      ]
    }
    ```
    
- **Lógica de Negócio (Regras do Semáforo):**
    1. Valida o token JWT e o corpo da requisição.
    2. Para cada `item` na requisição, busca os dados completos do alimento correspondente na tabela `alimentos`.
    3. **Regra de Classificação (executada em ordem de prioridade):**
        - **VERMELHO:** A refeição é classificada como `'vermelho'` se **pelo menos um** dos seus itens pertencer ao `"GRUPO DOS DOCES"` (conforme `grupo_dicume` na tabela `alimentos`).
            
            1
            
        - **AMARELO:** Se não for `'vermelho'`, a refeição é classificada como `'amarelo'` se **pelo menos um** dos seus itens tiver `classificacao_cor` igual a `'amarelo'` (ex: alimentos do grupo "Moderação" como arroz, batata, pães, a maioria das frutas). [15, 15]
        - **VERDE:** Se não for `'vermelho'` nem `'amarelo'`, a refeição é classificada como `'verde'`. Isso significa que ela é composta exclusivamente por alimentos com `classificacao_cor` `'verde'` (ex: a maioria das verduras e legumes do grupo "Pode comer a vontade"). [15, 15]
    4. Define a `mensagem` de feedback com base na cor final e na linguagem regional.
    5. Salva a refeição na tabela `refeicoes` e os itens na tabela `refeicao_itens`.
- **Respostas Possíveis:**
    - **`201 Created` (Sucesso):**
        
        ```json
        {
          "refeicao_id": 123,
          "classificacao_final": "amarelo",
          "mensagem": "Opa, esse aí é com moderação. Pega leve!"
        }
        ```
        
    - **`400 Bad Request`:** Payload inválido, faltando campos obrigatórios ou com tipos de dados incorretos.
    - **`401 Unauthorized`:** Token inválido ou ausente.

### **`GET /diario/refeicoes/:data`**

- **Descrição:** Retorna o histórico de todas as refeições registradas pelo usuário em uma data específica.
- **Autenticação:** JWT Obrigatório.
- **Parâmetro de Rota:** `data` no formato `AAAA-MM-DD`.
- **Lógica de Negócio:**
    1. Valida o token JWT e o formato do parâmetro `data`.
    2. Busca no Supabase todas as refeições do usuário para a data especificada, fazendo um `JOIN` com as tabelas `refeicao_itens` e `alimentos` para enriquecer os dados.
- **Respostas Possíveis:**
    - **`200 OK` (Sucesso):**
        
        ```json
        [
          {
            "id": 123,
            "tipo_refeicao": "almoco",
            "classificacao_final": "amarelo",
            "itens": [
              {
                "nome_popular": "Arroz branco",
                "quantidade_desc": "3 colheres de sopa",
                "foto_porcao_url": "https://.../arroz_branco_3_colheres.webp"
              },
              {
                "nome_popular": "Feijão",
                "quantidade_desc": "1 concha",
                "foto_porcao_url": "https://.../feijao_concha.webp"
              }
            ]
          }
        ]
        ```
        
    - **`400 Bad Request`:** Formato de data inválido.
    - **`401 Unauthorized`:** Token inválido ou ausente.
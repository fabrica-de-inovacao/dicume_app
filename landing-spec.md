# Prompt para Vercel (v0) — Landing page DICUMÊ

Objetivo

- Criar uma landing page estática (HTML/CSS/JS ou Next.js) que replique fielmente a composição visual da imagem anexa.
- Finalidade: página de divulgação e conversão (download / experimentar). Prioridade: fidelidade visual no desktop, responsividade e performance.

Instruções principais

- Siga a imagem anexa como referência obrigatória de layout, proporções, espaçamentos e hierarquia.
- Entregar código pronto para deploy no Vercel (pasta com build ou repositório Next.js). Incluir README com comandos de build/deploy.
- Otimizar imagens (WebP/AVIF), fornecer assets @2x e @3x quando aplicável.

Público e mensagem

- Público: adultos 20–55 anos preocupados com saúde e praticidade.
- Mensagem principal: montar pratos mais saudáveis com um semáforo nutricional simples e visual.

Copy (PT‑BR) — usar exatamente estes textos

- Hero title: "Monte pratos mais saudáveis em segundos"
- Hero subtitle: "DICUMÊ te ajuda a entender cada alimento com um semáforo nutricional simples. Busque, monte e salve suas refeições."
- Hero CTA primary: "Experimentar agora"
- Hero CTA secondary: "Ver demonstração"
- Feature titles e descrições:
  - "Coleções locais" — "Conteúdo regional e porções recomendadas."
  - "Recomendações personalizadas" — "Sugestões adaptadas ao seu perfil."
  - "Finalização rápida" — "Salve e sincronize com um toque."
- Steps (How it works):
  1. "Buscar alimento" — "Encontre alimentos por nome ou categoria."
  2. "Montar prato" — "Ajuste porções no prato virtual."
  3. "Salvar & Sincronizar" — "Guarde suas refeições e acesse de qualquer dispositivo."
  4. (opcional) "Compartilhar" — "Compartilhe suas escolhas com nutricionistas/amigos."
- Testimonials header: "Avaliações de usuários reais"
- CTA final title: "Pronto para montar pratos melhores?"
- Footer short: "Sobre · Privacidade · Contato"

Paleta de cores (tokens) — use exatamente

- --color-primary: #6D4C41
- --color-primary-light: #8D6E63
- --color-primary-dark: #5D4037
- --color-on-primary: #FFFFFF
- --color-secondary: #2196F3
- --color-background: #FAFAFA
- --color-surface: #FFFFFF
- --color-outline: #E0E0E0
- --color-text-primary: #212121
- --color-text-secondary: #757575
- --color-success: #4CAF50
- --color-warning: #FF9800
- --color-danger: #F44336

Tipografia

- Headings: Montserrat (SemiBold / Bold). H1 desktop ≈ 48px; H2 ≈ 32px; H3 ≈ 20–24px.
- Body: Inter ou Roboto regular 16px.
- Botões: Montserrat Medium 16px.
- Line‑height: body 1.5; headings 1.05–1.2.

Tokens CSS recomendados

```css
:root {
  --color-primary: #6d4c41;
  --color-primary-light: #8d6e63;
  --color-primary-dark: #5d4037;
  --color-on-primary: #ffffff;
  --color-secondary: #2196f3;
  --color-background: #fafafa;
  --color-surface: #ffffff;
  --color-outline: #e0e0e0;
  --color-text-primary: #212121;
  --color-text-secondary: #757575;
  --color-success: #4caf50;
  --color-warning: #ff9800;
  --color-danger: #f44336;
  --radius-lg: 16px;
  --radius-xl: 24px;
  --gap-section: 64px;
  --shadow-soft: 0 6px 16px rgba(0, 0, 0, 0.06);
}
```

Layout e espaçamentos

- Container centralizado com max‑width 1200–1400px.
- Padding lateral: desktop 96px; tablet 40–48px; mobile 20px.
- Gap entre seções: desktop 64px; mobile 32px.
- Radius de cards: 12–24px conforme contexto.

Hero — especificações

- Estrutura 2 colunas (desktop): texto à esquerda, mockup do app em mão à direita (mockup deve extrapolar levemente o card com sombra na base).
- Topbar: logo à esquerda; botão CTA "Download App" no canto superior direito (pill escuro com texto branco).
- Badges das lojas (App Store / Google Play) abaixo do subtítulo.
- Elementos decorativos: círculos/avatares distribuídos com baixa opacidade e linhas finas conectivas (SVG).

Feature cards

- Três cards em linha (desktop) com imagem retangular arredondada, título e descrição curta; pequeno ícone no canto superior direito como detalhe.

Steps (How it works)

- Cards numerados com bolha circular e micro‑cards explicativos; mockup do app posicionado ao lado conforme imagem.

Testimonials

- Carousel horizontal em fundo levemente tonalizado; cards com citação, nome e avatar; setas laterais e indicadores.

CTA final

- Grande card com mockup à direita, título e CTA principal à esquerda; badges das lojas abaixo do CTA.

Responsividade

- Desktop ≥1200px: layout 2 colunas onde aplicável.
- Tablet 768–1199px: ajustar escalas; H1 reduzido para ~32px.
- Mobile <768px: layout stacked (pilha); garantir botões touch‑friendly (mín. 44×44px).

Animações e micro‑interações

- Hero mockup: leve parallax/translateY ao scroll e micro tilt on hover (desktop). Duração ~300ms ease-out.
- Feature cards: hover translateY(-4px) + shadow increase (200ms).
- Decorative badges: subtle float/fade animations com delays.
- Steps reveal: staggered ao scroll (stagger 80ms).
- Carousel: autoplay 5s, pausável, controles acessíveis.

Acessibilidade

- Garantir contraste mínimo AA para textos.
- Alt text em todas as imagens; aria‑labels em botões.
- Fokus visível em todos os elementos interativos.

Assets e entregáveis esperados

- Código estático (HTML/CSS/JS) ou projeto Next.js pronto para deploy no Vercel.
- Figma/PSD com artboards Desktop/Tablet/Mobile.
- Logo em SVG (horizontal e ícone) e favicon.
- Mockup do celular em mão em PNG (fundo transparente) + versão alta resolução (3x).
- Screenshots do app para mockup: WebP/PNG @2x e @3x.
- Ícones SVG (semáforo 3 estados, search, save, share, arrows).
- Paleta em tokens JSON + arquivo .md com copy final.
- README com instruções de build e deploy no Vercel.

Critérios de aceitação (QA)

- Desktop deve representar com precisão a composição da imagem (proporções, espaçamentos, hierarquia).
- Tokens (cores, tipografia e espaçamentos) devem ser usados conforme especificado.
- Responsividade testada em 375px/768px/1366px.
- Performance otimizada: imagens otimizadas e carregamento rápido (Lighthouse ideal >=80).
- Todos os assets e o README entregues.

Observações finais

- A imagem anexa é a fonte de verdade para composição visual — siga‑a fielmente no desktop; permita pequenas adaptações para responsividade.
- Entregar branch ou build pronto para deploy com instruções claras.

---

Se quiser, eu também posso gerar automaticamente os arquivos `tokens.json` e `copy.txt` para anexar ao pedido do designer. Diga qual prefere que eu crie agora.

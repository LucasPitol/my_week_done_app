# Guia de Estilo — My Week Done
## Aplicação moderada do Liquid Glass (iOS 26 / tendência 2026)

---

## 1. Princípio central: glass é para navegação, não para conteúdo

Essa é a regra mais importante do estilo, e a que mais protege a identidade do app.

> Liquid Glass deve ser reservado para a camada de navegação que flutua sobre o conteúdo. Nunca aplicar ao conteúdo em si.

No **My Week Done**, isso se traduz assim:

| Aplica glass | NÃO aplica glass |
|---|---|
| Tab bar inferior (hoje / blocos / stats) | Lista de blocos de rotina |
| Botão flutuante de "+ novo bloco" | Cards de tarefa individual |
| Bottom sheet de detalhe/nota | Texto do bloco, horários, títulos |
| Header fixo com o anel de aderência (opcional) | Formulário de criação/edição |

O conteúdo (a lista do dia, os blocos, os textos) continua **sólido, opaco, de alto contraste** — é isso que garante legibilidade rápida, que é o requisito nº1 de um app de hábito. O glass entra só na "casca" que flutua por cima.

---

## 2. Onde o glass aparece no app

### Tab bar inferior
- Recuada das bordas da tela (não colada nos cantos), formato de cápsula (pill)
- Fundo translúcido com blur, deixando a lista rolar por baixo
- Item ativo em destaque com a cor de acento do app (não com glass extra — cor sólida basta)
- Conteúdo logo abaixo da tab bar recebe fade sutil ao se aproximar da borda

### Botão de ação flutuante (+)
- Círculo com glass, sombra suave, sempre visível sobre a lista
- Único elemento com leve "brilho" especular (reflexo sutil no topo) — reserve esse detalhe pra esse botão, não espalhe em todo lugar

### Bottom sheet (nota/detalhe do bloco)
- Fundo com glass ao abrir, mas o texto dentro do sheet é opaco e sólido
- Glass aqui reforça que é uma camada temporária "flutuando" sobre a tela principal, não conteúdo permanente

### Header com anel de aderência (opcional, avaliar depois)
- Se o header ficar fixo durante o scroll, pode receber glass leve — mas só se o número do anel continuar 100% legível

---

## 3. O que evitar (aprendido com os erros do próprio iOS 26)

A Apple corrigiu o próprio excesso de transparência depois do primeiro beta, porque texto ficava difícil de ler em baixo contraste (ex: luz solar direta). Isso vira regra prática pro nosso app:

- **Nunca** glass atrás de texto que precisa ser lido rápido (nome do bloco, horário, prazo de tarefa)
- **Nunca** empilhar glass sobre glass (ex: sheet com glass dentro de header com glass) — vira ruído visual e derruba contraste
- Blur com intensidade moderada — o objetivo é sugerir profundidade, não criar um efeito "vidro fosco" opaco demais nem "vidro cristalino" demais (ambos prejudicam leitura)
- Testar todo elemento de glass em fundo claro E escuro antes de aprovar

---

## 4. Especificações técnicas

### Blur e opacidade
- Tab bar: `blur ~20px`, opacidade do fundo entre 60–75%
- Botão flutuante: `blur ~15px`, opacidade 70–80%
- Bottom sheet: `blur ~25px` (mais forte, pois cobre mais área), opacidade 70%

### Cantos e forma
- Tab bar: formato de cápsula (raio = metade da altura)
- Botão flutuante: círculo perfeito
- Bottom sheet: cantos superiores arredondados, raio 20–24px

### Cor e tint
- Glass não deve ter cor própria forte — é um tint sutil sobre a paleta já definida (dark-first, com o mesmo acento usado no anel de aderência)
- Tint de cor só quando carrega significado semântico (ex: botão de ação usa o acento da marca), nunca como decoração pura

### Profundidade (camadas, do fundo pra frente)
1. Conteúdo (lista de blocos) — opaco, sem efeito
2. Fade de borda inferior (gradiente simples, sem blur)
3. Tab bar / botão flutuante — glass
4. Bottom sheet, quando aberto — glass, camada mais alta de todas

### Movimento
- Leve resposta ao toque no botão flutuante (scale down sutil + spring animation ao soltar)
- Bottom sheet sobe com easing suave, sem bounce exagerado — o app é sério, não lúdico
- Evitar qualquer efeito de "brilho seguindo o giroscópio" (isso existe no iOS nativo, mas é exagero pra um app desse porte)

---

## 5. Acessibilidade (não negociável)

- Contraste mínimo de texto sobre glass: seguir WCAG AA mesmo com blur (testar com o fundo mais desafiador — texto claro sobre foto clara, por exemplo)
- Respeitar a preferência de sistema "reduzir transparência" — quando ativa, trocar glass por fundo sólido equivalente, sem quebrar layout
- Nunca colocar informação crítica (prazo vencido, número de aderência) exclusivamente dentro de uma camada de glass sem fallback sólido

---

## 6. Notas de implementação em Flutter

Flutter não tem o material Liquid Glass nativo (é exclusivo SwiftUI/iOS), mas o efeito visual dá pra aproximar com:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(28),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // ajustar por tema
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
      ),
      child: /* conteúdo da tab bar ou botão */,
    ),
  ),
)
```

- `BackdropFilter` + `ImageFilter.blur` cobre o blur
- Um `border` sutil com baixa opacidade simula o "reflexo de borda" do vidro real, sem precisar de shaders
- Para o brilho especular do botão flutuante, um `LinearGradient` sutil no topo do círculo já resolve, sem precisar de shader customizado (evita custo de performance desnecessário pro escopo do MVP)
- Pacotes prontos como `glassmorphism` ou `liquid_glass_renderer` (comunidade) podem acelerar isso, mas o snippet acima já cobre 90% do efeito sem dependência extra — considerando que seu app prioriza performance e simplicidade (local-first, sem custo de API), recomendo começar sem pacote extra e só adotar um se o efeito manual não ficar satisfatório

---

## 7. Resumo executivo

Glass é tempero, não prato principal. No My Week Done, ele aparece em 3 lugares (tab bar, botão de ação, bottom sheet) e nunca toca o conteúdo real — blocos, horários, textos continuam sólidos e de alto contraste, porque a função do app é ser lido e marcado em 1 segundo, não admirado.


# Estilos — My Week Done

Documento de referência para tipografia e decisões visuais do MVP.

## Tipografia

### Decisão

| Papel | Fonte | Origem |
|-------|-------|--------|
| Títulos e headers | **Satoshi** | [Fontshare](https://www.fontshare.com/fonts/satoshi) |
| Corpo, listas e UI | **Inter** | [Google Fonts](https://fonts.google.com/specimen/Inter) |

### Por quê

- **Satoshi** traz personalidade geométrica e moderna nos títulos, sem competir com o conteúdo denso das telas (grid semanal, listas de blocos).
- **Inter** é neutra e altamente legível em tamanhos pequenos — ideal para corpo de texto, labels de navegação e itens de lista.
- A combinação segue o padrão comum de produto: display font com caráter + sans-serif funcional para leitura contínua.

### Licença

- **Satoshi**: ITF Free Font License (Fontshare) — uso pessoal e comercial permitido. Arquivos em `assets/fonts/satoshi/`.
- **Inter**: SIL Open Font License — via pacote `google_fonts`.

## Mapeamento no `TextTheme`

Estilos Material 3 mapeados em `lib/core/theme/app_theme.dart`:

| Estilo | Fonte | Uso típico |
|--------|-------|------------|
| `displayLarge` / `displayMedium` / `displaySmall` | Satoshi | Hero, números grandes (ex.: % aderência) |
| `headlineLarge` / `headlineMedium` / `headlineSmall` | Satoshi | Títulos de seção |
| `titleLarge` / `titleMedium` / `titleSmall` | Satoshi | AppBar, cards, subtítulos |
| `bodyLarge` / `bodyMedium` / `bodySmall` | Inter | Parágrafos, descrições |
| `labelLarge` / `labelMedium` / `labelSmall` | Inter | Chips, badges, metadados |

### Pesos

- Satoshi usa a fonte **variable** (`Satoshi-Variable.ttf`) — pesos 500–700 conforme o estilo.
- Inter segue os pesos padrão do Material 3 (400 para corpo, 500 para labels).

## Uso no código

Prefira sempre o tema em vez de `TextStyle` solto:

```dart
// Título de tela (Satoshi via AppBar / titleLarge)
Text('Hoje', style: Theme.of(context).textTheme.titleLarge)

// Corpo de lista (Inter)
Text(
  'Treino — 07:00',
  style: Theme.of(context).textTheme.bodyMedium,
)

// Header de seção (Satoshi)
Text(
  'Esta semana',
  style: Theme.of(context).textTheme.headlineSmall,
)
```

Constantes de família em `lib/core/theme/app_fonts.dart`:

- `AppFonts.satoshi` — quando precisar sobrescrever manualmente
- `AppFonts.inter` — referência; corpo já vem do `google_fonts`

## Arquivos

| Arquivo | Responsabilidade |
|---------|------------------|
| `assets/fonts/satoshi/Satoshi-Variable.ttf` | Satoshi regular (variable) |
| `assets/fonts/satoshi/Satoshi-VariableItalic.ttf` | Satoshi itálico (variable) |
| `pubspec.yaml` → `flutter.fonts` | Declaração da Satoshi |
| `lib/core/theme/app_theme.dart` | `TextTheme` e tema global |
| `lib/core/theme/app_fonts.dart` | Nomes das famílias |

## Manutenção

- **Adicionar peso Satoshi fixo**: incluir `.ttf` em `assets/fonts/satoshi/` e declarar em `pubspec.yaml`.
- **Trocar corpo**: alterar `GoogleFonts.interTextTheme()` em `app_theme.dart`.
- **Novas telas**: usar estilos do `Theme.of(context).textTheme`; não criar fontes ad hoc.

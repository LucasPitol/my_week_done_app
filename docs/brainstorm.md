# My Week Done

tracker de rotina fixa recorrente (blocos de horário que se repetem toda semana: treino, Trabalho, Almoço, Janta, Ler, aula de ingles, etc). Mais simples de modelar do que um calendário de eventos arbitrários (image.png)

**Legenda:** ✅ concluído · ⏳ parcial · ❌ pendente

## Escopo do MVP (v1 — local, sem auth)
Objetivo único: replicar a planilha como app, com check de feito/não feito por dia.

## Épico 1 — Estrutura de dados
- ✅ Tabela routine_blocks: id, dia_semana (1-7), hora_inicio, título, categoria (opcional/cor)
- ✅ Tabela daily_completions: id, routine_block_id, data, concluído (bool), nota (texto opcional)
- ✅ Extra: `groupId` para blocos criados em lote; cascade delete nas completions

## Épico 2 — Tela principal (grid semanal)
- ✅ View dia x hora (igual à planilha), com scroll vertical — disponível em **Calendário → Semana**; visão padrão é **Dia** (lista + pager)
- ✅ Toggle de conclusão por bloco (tap = marca feito)
- ✅ Indicador visual de "hoje" (destaque na coluna do dia atual)

## Épico 3 — CRUD de blocos
- ✅ Criar / editar / excluir bloco de rotina (nome, dia(s), horário)
- ✅ Duplicar bloco pra múltiplos dias de uma vez (ex: "Malhão" seg-sex) pra não recriar 5x
- ✅ Extra: edição/exclusão em grupo (todas as ocorrências vs uma só)

## Épico 4 — Feedback de disciplina (o "foco" do produto)
- ❌ % de aderência da semana (blocos concluídos / total esperado) — lógica no repositório (`adherenceForWeek`), **anel na UI ainda não existe**
- ❌ Histórico simples: últimos 7 dias, visual tipo streak — **aba Stats comentada; tela placeholder**

Contexto de dados (já implementado, sem mudança de schema)

routine_blocks: uma linha por (bloco, dia da semana), ligadas por groupId quando criadas em lote
daily_completions: uma linha por (routine_block_id, data) quando marcado feito; ausência = não feito
Sem soft delete: excluir bloco remove (cascade) as completions associadas

KPI 1 — Aderência diária
- ⏳ Lógica de estados (completo / parcial / sem rotina / em andamento) em `day_adherence.dart`
- ⏳ Visual no grid mensal (`month_day_cell.dart`); **não aparece na visão Dia**
- ⏳ Falta filtro por `created_at` (spec original; blocos não têm esse campo)

KPI 2 — Aderência semanal (o anel da tela principal)
- ⏳ `adherenceForWeek()` no repositório + testes
- ❌ Anel na tela principal
- ❌ Exclusão de dias futuros da semana atual no denominador

KPI 3 — Streak (constância)
- ❌ Cálculo de streak
- ❌ UI de streak (aba Stats)

Hoje nunca conta pro streak — o dia está em andamento, contar cedo demais criaria falso positivo/negativo. Hoje aparece separado na UI como "em andamento" (ex: "3 de 5 feitos hoje")
- ⏳ Estado `inProgress` existe na lógica; **"X de Y feitos hoje" só no grid mensal, não na visão Dia**

KPI 4 — Histórico de 7 dias (visual tipo streak/heatmap)
- ⏳ Cores de aderência por dia no grid mensal
- ❌ Widget dedicado dos últimos 7 dias corridos

Nota explícita sobre exclusão de blocos (documentar isso, é importante)
Excluir um bloco remove suas completions em cascade. Isso significa que o histórico passado pode mudar retroativamente se um bloco antigo for excluído — dias que antes mostravam 100% podem cair, porque o "esperado" daquele dia agora é recalculado sem o bloco excluído. Isso é uma limitação aceita do modelo atual (sem soft delete), não um bug — mas o Composer deve saber disso porque senão pode "corrigir" isso sem avisar, gerando comportamento não previsto.

Consultas necessárias (visão geral, sem prescrever query exata)
- ⏳ Aderência de um dia específico — `computeDayAdherence()`
- ⏳ Aderência agregada de um intervalo de dias — `adherenceForWeek()` (sem regras completas da spec)
- ❌ Streak — precisa iterar dia a dia de trás pra frente a partir de ontem até encontrar a primeira quebra

Fora de escopo deste épico
- ✅ floating_tasks não entram em nenhum dos 4 KPIs acima (decisão já tomada no Épico 5)
- ✅ Sem persistência de streak em cache — calcular sob demanda a partir de daily_completions é suficiente pro volume de dados esperado (uso pessoal, não multi-usuário)
- ✅ Sem gráfico histórico além de 7 dias neste épico (é o corte de produto já cogitado pra versão paga futura)

## Épico 5 - Floating tasks

routine_blocks representa recorrência fixa (mesma hora, mesmo(s) dia(s), toda semana). Uma tarefa solta com prazo é o oposto: acontece uma vez, não tem hora fixa, e sua visibilidade muda com o tempo (ela "aparece" nos dias antes do prazo, não só no dia do prazo). Forçar isso na tabela existente ia exigir campos nulos demais e lógica condicional espalhada pela UI. Melhor uma tabela nova, propósito único.

exemplo de caso de uso: usuario fica com tempo livre na terça, abre o app pra consultar suas tarefas e ve que tem uma tarefa sem dia definido, mas com prazo de quinta feira na visao 'hoje'

Modelo de dados novo
- ✅ Tabela floating_tasks: id, título, categoria (opcional), prazo (data opcional), concluído (bool), concluído_em, criado_em

Regra de exibição:
- ✅ Sem prazo: aparece todo santo dia até ser concluída (não some sozinha)
- ✅ Com prazo futuro: aparece todo dia a partir de quando foi criada até ser concluída
- ✅ Prazo é hoje: destaque visual (cor de urgência)
- ✅ Prazo vencido: destaque mais forte (vermelho/atrasado), continua aparecendo até concluir

- ✅ Ordenação dentro da seção: prazo mais próximo primeiro, sem-prazo por último (ou por ordem de criação)
- ✅ Decisão de escopo: essas tarefas não entram no anel de aderência (Épico 4)

Impacto nas outras telas
- ✅ Form de criação: toggle "rotina fixa" vs "tarefa solta" (`block_form_screen.dart`)
- ✅ Tela de blocos: duas seções (rotinas fixas / tarefas soltas)

resumo:
- ✅ Tabela floating_tasks: id, título, categoria (opcional), prazo (data opcional), concluído (bool), concluído_em, criado_em
- ✅ Nova seção "tarefas soltas" na tela principal (hoje), abaixo dos blocos com horário
- ✅ Regra de exibição: sem prazo = aparece todo dia; com prazo = aparece desde a criação até concluir; prazo hoje/vencido = destaque visual de urgência
- ✅ Form de criação com toggle "rotina fixa" / "tarefa solta" (campos mudam conforme o tipo)
- ✅ Fora do escopo do Épico 5: essas tarefas NÃO contam pro anel de aderência do Épico 4

## Fora do MVP v1 (fica pra v2)
- ❌ Auth / multi-dispositivo (Supabase entra aqui)
- ❌ Widget de home screen
- ❌ Notificações/lembretes
- ❌ Impactos com feriados

## Layout UI/UX

- ⏳ Onboarding apenas na primeira abertura — tela existe (`onboarding_screen.dart`), **não conectada ao fluxo de abertura**
- ⏳ Tela principal (hoje): seletor de dia ✅, lista ✅, anel de aderência ❌
- ✅ tab blocos: lista de rotinas, tab inferior / Form de bloco: criar, editar, dias multiplos
- ❌ tab Stats: streak — **comentada no nav; substituída por aba Perfil (stub vazio)**
- ⏳ Sheet de detalhe: nota opcional, expande no toque — `updateCompletionNote()` no repo; **sem bottom sheet na UI** (tap só alterna conclusão)

### Ergonomia por trás desse fluxo:

Hub único, sem hierarquia profunda. A tela principal é o centro de tudo — nada no MVP deve exigir mais de 2 toques a partir dela. Bottom nav fixa (3 abas: hoje, blocos, stats) em vez de menu hambúrguer ou drawer, porque o app é de uso rápido e recorrente (várias vezes ao dia), não de exploração.
- ⏳ Bottom nav ativa: Hoje / Rotinas / Perfil — **Stats ainda pendente**

Onboarding só aparece uma vez. Depois disso ele desaparece do fluxo — o app sempre abre direto na tela principal, no dia de hoje. Isso é importante pro caso de uso: você quer abrir, ver, marcar, fechar. Zero cerimônia.
- ❌ Fluxo de primeira abertura não implementado

Sheet de detalhe é modal, não tela nova. Notas tipo "3i", "moctra" (que vimos na planilha) ficam atrás de um toque expandido no bloco — um bottom sheet que sobe por cima da tela principal, sem navegação real. Isso evita que a lista principal fique poluída, mas mantém a informação a um toque de distância.
- ❌ Bottom sheet de detalhe/nota

Blocos e Stats são "irmãs", não aninhadas. Ambas penduradas direto na tab bar, sem passar uma pela outra — reforça que são utilitários de apoio (configurar rotina, ver progresso), não o fluxo principal do dia a dia.
- ⏳ Rotinas ✅; Stats ❌ (Perfil no lugar, ainda vazio)

### Considerações de ergonomia que valem entrar no design

Zona do polegar — os toques mais frequentes (marcar bloco como feito, trocar de dia) devem ficar na metade inferior da tela; ações raras (editar bloco, configurações) podem ficar no topo, onde o alcance é pior.
- ✅ Marcar bloco e trocar de dia na metade inferior

Estado vazio da tela de blocos — primeira abertura sem nenhum bloco criado precisa de um CTA claro tipo "criar primeiro bloco" em vez de tela em branco.
- ✅ `empty_blocks_state.dart`

Feedback tátil no toggle — um leve haptic feedback (HapticFeedback.lightImpact() no Flutter) no tap de conclusão reforça a sensação de "constância" sem precisar de animação chamativa.
- ✅ Implementado em blocos e floating tasks

Undo, não confirmação — desmarcar um bloco por engano deve ser reversível com um toque, não pedir modal de "tem certeza?". Confirmação modal mata a fluidez de um app de hábito.
- ✅ Toggle direto, sem confirmação ao desmarcar

---

## Extras implementados (fora do brainstorm original)

- ✅ Toggle de visão **Dia / Calendário** na tela Hoje
- ✅ Escopo de calendário **Semana / Mês** com grid e aderência visual por dia
- ⏳ Aba **Perfil** no lugar de Stats — stub vazio; spec em `docs/profile_page.md`

---

## Resumo rápido

| Área | Status |
|------|--------|
| Épico 1 — Dados | ✅ |
| Épico 2 — Grid semanal | ✅ |
| Épico 3 — CRUD | ✅ |
| Épico 4 — Disciplina (anel, streak, 7 dias) | ❌ / ⏳ |
| Épico 5 — Floating tasks | ✅ |
| UI/UX (onboarding, anel, sheet, stats) | ⏳ / ❌ |
| Fora do MVP v1 | ❌ (correto) |

**Principais pendências:** anel de aderência na tela principal, streak, histórico de 7 dias, aba Stats, onboarding na primeira abertura, bottom sheet de nota, tela de Perfil (`profile_page.md`).

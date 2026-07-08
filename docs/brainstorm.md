# My Week Done

tracker de rotina fixa recorrente (blocos de horário que se repetem toda semana: treino, Trabalho, Almoço, Janta, Ler, aula de ingles, etc). Mais simples de modelar do que um calendário de eventos arbitrários (image.png)

## Escopo do MVP (v1 — local, sem auth)
Objetivo único: replicar a planilha como app, com check de feito/não feito por dia.

## Épico 1 — Estrutura de dados
- Tabela routine_blocks: id, dia_semana (1-7), hora_inicio, título, categoria (opcional/cor)
- Tabela daily_completions: id, routine_block_id, data, concluído (bool), nota (texto opcional)

## Épico 2 — Tela principal (grid semanal)
- View dia x hora (igual à planilha), com scroll vertical
- Toggle de conclusão por bloco (tap = marca feito)
Indicador visual de "hoje" (destaque na coluna do dia atual)

## Épico 3 — CRUD de blocos
- Criar / editar / excluir bloco de rotina (nome, dia(s), horário)
- Duplicar bloco pra múltiplos dias de uma vez (ex: "Malhão" seg-sex) pra não recriar 5x

## Épico 4 — Feedback de disciplina (o "foco" do produto)
- % de aderência da semana (blocos concluídos / total esperado)
- Histórico simples: últimos 7 dias, visual tipo streak

## Épico 5 - Floating tasks

routine_blocks representa recorrência fixa (mesma hora, mesmo(s) dia(s), toda semana). Uma tarefa solta com prazo é o oposto: acontece uma vez, não tem hora fixa, e sua visibilidade muda com o tempo (ela "aparece" nos dias antes do prazo, não só no dia do prazo). Forçar isso na tabela existente ia exigir campos nulos demais e lógica condicional espalhada pela UI. Melhor uma tabela nova, propósito único.

exemplo de caso de uso: usuario fica com tempo livre na terça, abre o app pra consultar suas tarefas e ve que tem uma tarefa sem dia definido, mas com prazo de quinta feira na visao 'hoje'

Modelo de dados novo
Tabela floating_tasks

id
título
categoria (opcional, reaproveita as mesmas cores dos blocos)
prazo (data, opcional — pode não ter prazo nenhum)
concluído (bool)
concluído_em (timestamp, pra histórico)
criado_em

Regra de exibição:
Na tela "hoje", uma nova seção abaixo dos blocos com horário, tipo "tarefas soltas":
Sem prazo: aparece todo santo dia até ser concluída (não some sozinha)
Com prazo futuro: aparece todo dia a partir de quando foi criada até ser concluída — é exatamente seu caso de uso, terça vendo a tarefa que vence quinta
Prazo é hoje: destaque visual (ex: cor de urgência)
Prazo vencido: destaque mais forte (vermelho/atrasado), mas continua aparecendo — nunca some sozinha, só quando concluída

Ordenação dentro da seção: prazo mais próximo primeiro, sem-prazo por último (ou por ordem de criação).

Decisão de escopo: essas tarefas não entram no anel de aderência (Épico 4). Aderência é sobre constância de rotina fixa; tarefa avulsa é outra categoria de compromisso. Misturar os dois dilui o significado do número.

Impacto nas outras telas

Form de criação (Épico 3) precisa de um toggle no topo: "rotina fixa" vs "tarefa solta". Se for tarefa solta, os campos mudam: some dia da semana e hora, aparece um date picker opcional de prazo.
Tela de blocos: passa a listar duas seções (rotinas fixas / tarefas soltas) ou uma aba extra — decisão de UI pra hora de implementar.

resumo:
- Tabela floating_tasks: id, título, categoria (opcional), prazo (data opcional), 
  concluído (bool), concluído_em, criado_em
- Nova seção "tarefas soltas" na tela principal (hoje), abaixo dos blocos com horário
- Regra de exibição: sem prazo = aparece todo dia; com prazo = aparece desde a criação 
  até concluir; prazo hoje/vencido = destaque visual de urgência
- Form de criação com toggle "rotina fixa" / "tarefa solta" (campos mudam conforme o tipo)
- Fora do escopo do Épico 5: essas tarefas NÃO contam pro anel de aderência do Épico 4

## Fora do MVP v1 (fica pra v2)
- Auth / multi-dispositivo (Supabase entra aqui)
- Widget de home screen
- Notificações/lembretes
- Impactos com feriados

## Layout UI/UX

- Onboardin apenas na primeira abertura.
- Tela principal (hoje): seletor de dia, lista, anel de aderencia.
- tab blocos: lista de rotinas, tab inferior / Form de bloco: criar, editar, dias multiplos
- tab Stats: streak, tab inferior
- Sheet de detalhe: nota opcional, expande no toque

### Ergonomia por trás desse fluxo:

Hub único, sem hierarquia profunda. A tela principal é o centro de tudo — nada no MVP deve exigir mais de 2 toques a partir dela. Bottom nav fixa (3 abas: hoje, blocos, stats) em vez de menu hambúrguer ou drawer, porque o app é de uso rápido e recorrente (várias vezes ao dia), não de exploração.

Onboarding só aparece uma vez. Depois disso ele desaparece do fluxo — o app sempre abre direto na tela principal, no dia de hoje. Isso é importante pro caso de uso: você quer abrir, ver, marcar, fechar. Zero cerimônia.

Sheet de detalhe é modal, não tela nova. Notas tipo "3i", "moctra" (que vimos na planilha) ficam atrás de um toque expandido no bloco — um bottom sheet que sobe por cima da tela principal, sem navegação real. Isso evita que a lista principal fique poluída, mas mantém a informação a um toque de distância.

Blocos e Stats são "irmãs", não aninhadas. Ambas penduradas direto na tab bar, sem passar uma pela outra — reforça que são utilitários de apoio (configurar rotina, ver progresso), não o fluxo principal do dia a dia.

### Considerações de ergonomia que valem entrar no design

Zona do polegar — os toques mais frequentes (marcar bloco como feito, trocar de dia) devem ficar na metade inferior da tela; ações raras (editar bloco, configurações) podem ficar no topo, onde o alcance é pior.

Estado vazio da tela de blocos — primeira abertura sem nenhum bloco criado precisa de um CTA claro tipo "criar primeiro bloco" em vez de tela em branco.

Feedback tátil no toggle — um leve haptic feedback (HapticFeedback.lightImpact() no Flutter) no tap de conclusão reforça a sensação de "constância" sem precisar de animação chamativa.

Undo, não confirmação — desmarcar um bloco por engano deve ser reversível com um toque, não pedir modal de "tem certeza?". Confirmação modal mata a fluidez de um app de hábito.
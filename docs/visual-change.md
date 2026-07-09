## Spec: Visão "Dia" (estilo Trello/Jira mobile) + toggle Calendário/Dia

Objetivo:

Adicionar uma segunda forma de visualizar a semana: visão Dia, onde um único dia ocupa a tela inteira, com navegação horizontal por arraste (swipe) entre os dias — igual ao comportamento de colunas do Trello/Jira mobile (ex: arrastar de "To Do" pra "Done"). A visão atual em grid (visão Calendário) continua existindo, selecionável por um toggle. 
Padrão do app: abrir sempre na visão Dia.

## Comportamento da visão Dia

Cada dia da semana é uma "página" que ocupa 100% da largura da tela
- Arrastar (swipe) pra esquerda avança pro próximo dia; arrastar pra direita volta pro dia anterior
- Navegação infinita nos dois sentidos (não trava no domingo/segunda — o app é de rotina recorrente, então a navegação de dias continua indefinidamente pra frente e pra trás)
- Transição de página com snap suave (a página não fica "solta" no meio, sempre assenta no dia inteiro ao soltar o dedo)
- Header acima do conteúdo mostra: nome do dia por extenso + data (ex: "Quarta, 8 de julho"), atualizando conforme o swipe acontece
- Se o dia visível for hoje, mostrar indicador visual (ex: label "Hoje" ou destaque de cor) — se for outro dia, sem esse indicador
- Todos os blocos de rotina do dia (com horário) e a seção de tarefas soltas (sem horário) aparecem empilhados verticalmente dentro da página daquele dia, com scroll vertical normal
- Abaixo do header, pode manter um indicador leve de contexto (ex: pontinhos ou abreviação dos dias vizinhos), mas SEM os cards vazios das colunas laterais que existem na visão atual — a ideia é o dia atual dominar 100% da tela

## Comportamento da visão Calendário (já existente)

- Mantém exatamente como está hoje: grid horizontal com múltiplos dias visíveis, cada um em coluna estreita
- Sem mudanças de comportamento — só passa a ser uma opção alternativa, não mais a única

## Toggle entre visões

- Um seletor (ex: segmented control ou dois ícones no header) alternando entre "Dia" e "Calendário"
- Estado da visão escolhida deve persistir entre sessões (salvar preferência local, ex: shared_preferences), mas o valor padrão na primeira abertura do app é Dia
- Trocar de visão não deve perder a referência do dia atual — se o usuário está vendo quinta na visão Dia e troca pra Calendário, a visão Calendário deve abrir com quinta em destaque/contexto (não resetar pra hoje)

---

Considerações técnicas (Flutter)

Implementar a visão Dia com PageView.builder, usando um PageController com initialPage calculado a partir de um "índice infinito" (ex: número de dias desde uma data-base fixa, permitindn itemBuilder gerar qualquer dia positivo ou negativo sem limite)
Cada página do PageView deve buscar seus próprios dados (blocos + conclusões do dia) de forma independente, evitando recarregar todos os dias de uma vez — carregar sob demanda (lazy) conforme o usuário se aproxima da página
Prefetch de 1 dia adjacente pra cada lado, pra evitar flash de loading durante o swipe
Evitar rebuild de todas as páginas ao marcar um bloco como concluído — o estado de conclusão deve invalidar (via Riverpod) só a página do dia afetado

Fora de escopo dessa mudança

Não alterar o modelo de dados (routine_blocks, daily_completions, floating_tasks) — essa é uma mudança de camada de apresentação/navegação apenas
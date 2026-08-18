# Estrutura da tela (por prioridade de uso)

Seguindo o padrão de "Settings" nativo (iOS/Android), organizado em grupos, do mais usado pro menos usado:

## 1. Aparência

Tema: segmented control com 3 opções (Claro / Escuro / Sistema) — sistema como padrão.

## 2. Dados

Limpar dados — ação destrutiva, precisa de dupla confirmação (é irreversível, sem backup em nuvem ainda). Sugiro pedir pra digitar "limpar" ou confirmar duas vezes, já que não tem como desfazer

## 3. Apoie o projeto

Pix: chave copiável + opção de ver QR code: c49145ad-b0c2-4bc9-98a6-3d3ed246a67b
BTC: endereço copiável (sem nessa versao)
USDT: endereço copiável (precisa especificar a rede — TRC20 ou ERC20 (sem nessa versao) — senão o usuário pode mandar pra rede errada e perder o valor)
Todas com toque único pra copiar + feedback (haptic + toast "copiado")

## 4. Sobre

Versão do app (número de build, útil pra suporte)
Avalie o app (deep link pra store)
Política de privacidade — 


Por que esse recorte "sem exagero" faz sentido

Não incluí notificações (ainda fora do MVP), idioma (app é só PT-BR por enquanto), nem conta/perfil de usuário (não tem auth). Adicionar esses campos vazios ou "em breve" só polui a tela sem funcionalidade real por trás — meu critério foi: só entra o que já existe ou tem decisão tomada.

Detalhe de ergonomia que vale reforçar

Ação destrutiva sempre no final do primeiro grupo, com cor de perigo. "Limpar dados" fica isolado logo depois de "Aparência" — não escondido lá embaixo (usuário não deveria caçar), mas também não no topo (não é ação do dia a dia). A cor vermelha já sinaliza perigo antes mesmo do toque.

Doação como bloco próprio, não misturado com "Sobre". Doação é uma ação de intenção diferente (apoiar financeiramente) de "avaliar o app" ou "ver versão" — separar evita que pareça picture menor ou obrigação, e sim um convite opcional bem definido.
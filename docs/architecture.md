
## MVP

Viabilidade do "local-first, sem auth"
Funciona bem se você isolar a camada de dados desde o início. A ideia é: a UI nunca fala direto com storage — ela fala com um repository/service que hoje salva local (SQLite ou Hive/Isar) e amanhã vira Supabase, sem tocar em tela nenhuma.

UI (widgets Flutter)
   ↓
RoutineRepository (interface abstrata)
   ↓
LocalRoutineRepository (implementação v1 — SQLite/Drift ou Hive)
   ↓ (futuro, mesma interface)
SupabaseRoutineRepository (implementação v2)

## Gerenciador de estado: Riverpod

Trocar Local → Supabase sem tocar em telaProvider de repositório é injetado por interface; troca é 1 linha no provider raiz;
Tela principal reage a mudança de dado (toggle de conclusão)AsyncNotifierProvider ou StreamProvider cobre local (Drift stream de query) e futuro Supabase realtime com o mesmo padrão;
Testar repository isoladoProviders são facilmente sobrescritos em teste (ProviderScope(overrides: [...])), sem precisar de container global;
Simplicidade pro escopo do MVP (3 telas)Não exige boilerplate de Bloc (events/states separados) nem acopla rotas como o GetX


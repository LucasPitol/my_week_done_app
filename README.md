# My Week Done

Tracker de rotina fixa recorrente — blocos de horário que se repetem toda semana.

## Estrutura do projeto

```
lib/
├── app/                    # App root e shell de navegação
├── core/                   # Tema, constantes
├── data/
│   └── repositories/       # Implementações (LocalRoutineRepository v1)
├── domain/
│   ├── entities/           # RoutineBlock, DailyCompletion
│   └── repositories/       # Interface RoutineRepository
├── features/
│   ├── today/              # Tela principal (hoje)
│   ├── blocks/             # CRUD de blocos
│   ├── stats/              # Aderência e streak
│   └── onboarding/         # Primeira abertura
└── providers/              # Riverpod providers
```

## Stack

- **Flutter** + **Riverpod** para estado
- **Repository pattern** — UI desacoplada do storage (local hoje, Supabase no futuro)
- **LocalRoutineRepository** em memória (v1); migrar para Drift/SQLite depois

## Rodar

```bash
flutter pub get
flutter run
```

## Ícone do app

Fonte em `assets/icons/app_icon.png`. Para regenerar os ícones das plataformas após alterar a imagem:

```bash
dart run flutter_launcher_icons
```

## Docs

Ver `docs/brainstorm.md` e `docs/architecture.md` para escopo do MVP.

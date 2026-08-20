# My Week Done

Tracker de rotina fixa recorrente / blocos de horário que se repetem toda semana.

## Estrutura do projeto

```
lib/
├── app/                    # App root e shell de navegação
├── core/                   # Tema, constantes
├── data/
│   ├── local/              # AppDatabase (Drift/SQLite)
│   ├── mappers/            # Conversão domínio ↔ banco
│   └── repositories/       # LocalRoutineRepository
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
- **Repository pattern** — UI desacoplada do storage (local hoje, cloud amanhã)
- **LocalRoutineRepository** com SQLite via Drift (persistência local v1)

## Rodar

```bash
flutter pub get
flutter run
```

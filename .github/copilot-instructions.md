# Copilot Instructions

## Commands

```bash
# Run the server (listens on port 5469)
dart run bin/quiz_api.dart

# Run all tests
dart test

# Run a single test by name
dart test test/server_test.dart --name "Root"

# Code generation (required after changing annotated DTOs or router classes)
dart run build_runner build

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

The server uses [Shelf](https://pub.dev/packages/shelf) + [Shelf Router](https://pub.dev/packages/shelf_router) and is structured in two API versions, both mounted in `lib/src/routes/quiz_router.dart`:

- **`/api/v1`** — manual routing via `RoutesHandler` (`lib/src/routes/routes_handler.dart`)
- **`/api/v2`** — annotation-based routing using `shelf_router_generator` in `lib/src/modules/`

Request flow (v1): `QuizRouter` → `RoutesHandler.buildRouters()` → `QuizController` → `QuizService` → in-memory mock data

**Layers:**
- `lib/src/routes/` — mounts and delegates routes
- `lib/src/controller/` — parses requests, returns `Response`
- `lib/src/service/` — business logic
- `lib/src/model/` — domain models (`QuestionModel`, `UserModel`)
- `lib/src/data/` — in-memory mock data (`questions.mock.dart`, `users.mock.dart`)
- `lib/src/exceptions/` — typed exceptions with HTTP status codes

**Data persistence:** There is no database. State is held in in-memory `List<Map<String, dynamic>>` variables in the `data/` mock files. User state (answered questions) is mutated at runtime and lost on restart.

## Key Conventions

### Code Generation
Files ending in `.g.dart` are generated — never edit them manually. Run `build_runner` after changes to:
- Classes annotated with `@JsonSerializable()` (e.g., `QuestionAnswerDto`)
- Classes annotated with `@Route.*` in a `part '*.g.dart'` file (e.g., `QuizRouter`, `QuizModule`)

### Two Serialization Patterns
- **Request DTOs** (`controller/dto/request/`): use `@JsonSerializable` + `build_runner` → delegate to generated `_$ClassFromJson` / `_$ClassToJson`
- **Response DTOs and Models**: manual `toMap()` / `fromMap()` + `json.encode` / `json.decode`

> ⚠️ `QuestionModel.toMap()` uses the key `'catgory'` (typo) — `fromMap()` also reads `'catgory'`. Do not "fix" this without updating both ends.

### Exception Handling
All exceptions thrown from controller or service are caught centrally in `RoutesHandler._buildHttpRequest`. To signal an HTTP error:
1. Extend `CustomException` with the desired HTTP `status` code
2. Throw it from service or controller — the handler converts it to a JSON `{"message": "..."}` response automatically

### Adding Routes
- **v1**: Add entries to the `Router` in `RoutesHandler.buildRouters()` using `_buildHttpRequest` wrapper
- **v2**: Add `@Route.get`/`@Route.post` annotated methods to `QuizModule` (or a new module), then run `build_runner`

### Question Categories
Current categories in mock data: `generalKnowledge`, `geography`, `historyFashion`, `popCultureMusic`. The `category` query param on `GET /api/v1/questions/generate` filters by these values.

### v2 Roadmap
`QUIZ_V2.md` describes a planned redesign: JSON file-based questions per category (up to 100 each), point scoring, and timed answers. The v2 module (`lib/src/modules/`) is scaffolded but not yet implemented.

# Quiz API

API de quiz desenvolvida com [Shelf](https://pub.dev/packages/shelf),
[Shelf Router](https://pub.dev/packages/shelf_router) e
[Shelf Router Generator](https://pub.dev/packages/shelf_router_generator).
Inclui uma UI estática servida em `web/` e suporta execução via
[Docker](https://www.docker.com/).

A API está disponível em duas versões:

- **V1** — `GET/POST /api/v1/questions/*` — perguntas abertas (texto livre)
- **V2** — `GET/POST /api/v2/questions/*`, `GET /api/v2/quiz/result` — múltipla escolha com pontuação

## Executando com o Dart SDK

Certifique-se de ter o [Dart SDK](https://dart.dev/get-dart) instalado.

```bash
# Instalar dependências e gerar código
dart pub get
dart run build_runner build --delete-conflicting-outputs

# Iniciar o servidor (porta 5469)
dart run bin/quiz_api.dart
```

O servidor ficará disponível em `http://localhost:5469`.

## Executando com Docker

```bash
docker build . -t quiz-api
docker run -it -p 5469:5469 quiz-api
```

> **Atenção:** o `Dockerfile` atual expõe a porta 8080 e referencia `bin/server.dart`,
> o que diverge do entry point real (`bin/quiz_api.dart`, porta 5469).
> Corrija o Dockerfile antes de usar em produção.

## Comandos úteis

```bash
# Rodar todos os testes
dart test

# Análise estática
dart analyze

# Geração de código (após alterar DTOs ou rotas anotadas)
dart run build_runner build --delete-conflicting-outputs
```

## Estrutura

| Camada | Localização |
| --- | --- |
| Entry point | `bin/quiz_api.dart` |
| Roteamento | `lib/src/routes/`, `lib/src/modules/` |
| Controllers | `lib/src/controller/` |
| Serviços | `lib/src/service/` |
| Modelos | `lib/src/model/` |
| Dados mock V1 | `lib/src/data/` |
| Dados JSON V2 | `lib/data/v2/` |

Para a documentação completa da API V2, consulte [API_V2.md](API_V2.md).

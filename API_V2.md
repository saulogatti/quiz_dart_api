# API V2 — Documentação para Consumo Externo

> **Base URL:** `http://localhost:5469/api/v2`
>
> Todos os endpoints retornam e aceitam **JSON** (`Content-Type: application/json`).
> O estado (pontuação, perguntas já vistas) é mantido **em memória** no servidor
> e é perdido quando o processo reinicia.

---

## Categorias disponíveis

| Valor do campo `category` | Descrição |
| --- | --- |
| `generalKnowledge` | Conhecimentos gerais |
| `geography` | Geografia |
| `historyFashion` | História e Moda |
| `popCultureMusic` | Cultura Pop e Música |

---

## Endpoints

### 1. Gerar pergunta aleatória

Retorna uma pergunta de múltipla escolha de uma categoria, com as alternativas
embaralhadas. A resposta correta **nunca** é incluída. Quando `userEmail` é
informado, o servidor evita repetir perguntas que o usuário já recebeu na
sessão atual.

```http
GET /api/v2/questions/generate
```

#### Parâmetros de consulta

| Parâmetro | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `category` | `string` | ✅ Sim | Categoria da pergunta (ver tabela acima) |
| `userEmail` | `string` | ❌ Não | E-mail do usuário para filtrar perguntas já vistas |

#### Resposta de sucesso — `200 OK`

```json
{
  "id": 3,
  "question": "Quantas tiras há na bandeira dos Estados Unidos?",
  "category": "generalKnowledge",
  "options": ["11", "50", "13", "7"],
  "points": 10
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | `int` | Identificador único da pergunta na categoria |
| `question` | `string` | Enunciado da pergunta |
| `category` | `string` | Categoria da pergunta |
| `options` | `string[]` | Lista de alternativas (embaralhadas a cada chamada) |
| `points` | `int` | Pontos que o usuário ganha ao acertar |

#### Erros possíveis

| Código | Motivo |
| --- | --- |
| `400` | Parâmetro `category` ausente ou vazio |
| `404` | Categoria não encontrada **ou** usuário esgotou todas as perguntas da categoria |

**Exemplo de erro 404 (categoria esgotada):**

```json
{
  "message": "Sem mais perguntas na categoria \"generalKnowledge\" — você já respondeu todas as 20 disponíveis."
}
```

---

### 2. Enviar resposta

Verifica se a resposta do usuário está correta, atualiza o score acumulado e
retorna o resultado parcial.

```http
POST /api/v2/questions/answer
```

#### Corpo da requisição

```json
{
  "id": 3,
  "category": "generalKnowledge",
  "userEmail": "jogador@email.com",
  "answerResp": "13",
  "revealResult": true
}
```

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `id` | `int` | ✅ Sim | ID da pergunta retornado pelo endpoint de geração |
| `category` | `string` | ✅ Sim | Categoria da pergunta (deve corresponder ao ID) |
| `userEmail` | `string` | ✅ Sim | E-mail do usuário |
| `answerResp` | `string` | ✅ Sim | Texto exato de uma das alternativas recebidas |
| `revealResult` | `bool` | ❌ Não (padrão: `true`) | `false` ativa o **modo mistério** (veja abaixo) |

> **Modo mistério (`revealResult: false`):** o score é atualizado normalmente,
> mas a API **não revela** se a resposta estava correta nem quantos pontos foram
> ganhos. Use `GET /quiz/result` no final para obter o resultado completo.

#### Resposta de sucesso — `200 OK` (modo padrão, `revealResult: true`)

```json
{
  "correct": true,
  "pointsEarned": 10,
  "totalScore": 30,
  "totalAnswered": 3,
  "correctCount": 3,
  "wrongCount": 0
}
```

#### Resposta de sucesso — `200 OK` (modo mistério, `revealResult: false`)

```json
{
  "totalAnswered": 3
}
```

| Campo | Tipo | Presente quando | Descrição |
| --- | --- | --- | --- |
| `correct` | `bool` | `revealResult: true` | Indica se a resposta estava correta |
| `pointsEarned` | `int` | `revealResult: true` | Pontos ganhos nesta resposta (0 se errou ou já tinha respondido) |
| `totalScore` | `int` | `revealResult: true` | Pontuação total acumulada do usuário |
| `totalAnswered` | `int` | Sempre | Total de perguntas respondidas (certas + erradas) |
| `correctCount` | `int` | `revealResult: true` | Total de acertos |
| `wrongCount` | `int` | `revealResult: true` | Total de erros |

> **Obs.:** responder uma mesma pergunta mais de uma vez não acumula pontos
> nem altera os contadores — a segunda resposta em diante é ignorada silenciosamente.

#### Erros — Enviar resposta

| Código | Motivo |
| --- | --- |
| `400` | Body inválido ou campos obrigatórios ausentes |
| `404` | Pergunta com o `id` informado não encontrada na `category` |

**Exemplo de erro 400 (body inválido):**

```json
{
  "message": "Body inválido. Campos obrigatórios: id, category, userEmail, answerResp."
}
```

---

### 3. Obter resultado final

Retorna o score completo e as métricas acumuladas do usuário na sessão atual.
Pode ser chamado a qualquer momento — ideal para exibir o placar ao final do jogo.

```http
GET /api/v2/quiz/result
```

#### Parâmetros — Resultado final

| Parâmetro | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `userEmail` | `string` | ✅ Sim | E-mail do usuário |

#### Resposta de sucesso — resultado final (`200 OK`)

```json
{
  "userEmail": "jogador@email.com",
  "totalScore": 80,
  "totalAnswered": 10,
  "correctCount": 8,
  "wrongCount": 2
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `userEmail` | `string` | E-mail do usuário consultado |
| `totalScore` | `int` | Pontuação total acumulada |
| `totalAnswered` | `int` | Total de perguntas respondidas |
| `correctCount` | `int` | Total de acertos |
| `wrongCount` | `int` | Total de erros |

> Quando o usuário ainda não respondeu nenhuma pergunta, todos os campos
> numéricos retornam `0`.

#### Erros — Resultado final

| Código | Motivo |
| --- | --- |
| `400` | Parâmetro `userEmail` ausente ou vazio |

---

## Fluxo típico de integração

```text
1. GET /api/v2/questions/generate?category=generalKnowledge&userEmail=jogador@email.com
   → recebe a pergunta e suas options

2. Usuário seleciona uma alternativa

3. POST /api/v2/questions/answer
   Body: { id, category, userEmail, answerResp }
   → recebe correct, pointsEarned, totalScore, etc.

4. Repete os passos 1–3 até o usuário terminar ou a categoria ser esgotada (404)

5. GET /api/v2/quiz/result?userEmail=jogador@email.com
   → exibe o placar final
```

---

## Formato de resposta de erro (padrão)

Todos os erros seguem o mesmo envelope:

```json
{
  "message": "Descrição do erro."
}
```

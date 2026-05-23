# Quiz API V2

## Descrição: Esta é a nova versão da API de quiz

Essa api vai levar para nova rota de quiz que vai funcionar um pouco diferente. Vai servir para uma tela de quiz que vou desenvolver depois.
A ideia é essa nova rota vai gerar perguntas aleatórias podendo checar ate 100. Todas tem pergunta e resposta e vai ser em apis diferentes. A ideia é que a tela de quiz seja um jogo onde o usuário tem que responder as perguntas e ganhar pontos. As perguntas vão ser geradas aleatoriamente e o usuário vai ter um tempo para responder cada pergunta. Se ele acertar, ganha pontos, se errar, perde pontos. O objetivo é ganhar o máximo de pontos possível.
  
Bando de dados: Para ficar facil de adicionar dados, vou utilizar JSON para os dados com estutura simples que pode ser adicionado facilmente. A estrutura do JSON vai ser algo como:

```json
  {
    "category": "Geografia",
    "questions": [
      {
        "id": 1,
        "question": "Qual é a capital da França?",
        "answer": "Paris",
        "points": 10
      }
    ]
  }
```

Cada categoria vai ter um array de perguntas, cada pergunta tem um id, a pergunta em si, a resposta correta e os pontos que o usuário ganha se acertar. A lista vai ate 100 perguntas por categoria, e pode ter varias categorias. A ideia é que a tela de quiz possa escolher aleatoriamente uma categoria e uma pergunta dentro dessa categoria para o usuário responder. Cada JSON por categoria vai ser um arquivo separado, para facilitar a organização e a adição de novas categorias e perguntas. A API vai ter uma rota com parametro de categoria, e vai retornar uma pergunta aleatória dessa categoria. Se a categoria não existir, vai retornar um erro. A resposta correta da pergunta não vai ser retornada na API, para evitar que o usuário possa ver a resposta antes de responder a pergunta. A resposta correta só vai ser verificada quando o usuário enviar a resposta para a API, e a API vai retornar se a resposta está correta ou não, e quantos pontos o usuário ganhou ou perdeu.

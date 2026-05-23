/// Modelo interno de pergunta V2 carregado dos arquivos JSON por categoria.
///
/// A [answer] é usada apenas internamente no service e nunca exposta nas
/// respostas da API. As [options] contêm até 4 alternativas, sendo uma delas
/// igual a [answer] (a correta).
class QuestionV2Model {
  final int id;
  final String question;
  final List<String> options;
  final String answer;
  final int points;

  const QuestionV2Model({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.points,
  });

  factory QuestionV2Model.fromJson(Map<String, dynamic> json) => QuestionV2Model(
        id: json['id'] as int,
        question: json['question'] as String,
        options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
        answer: json['answer'] as String,
        points: json['points'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options,
        'answer': answer,
        'points': points,
      };
}

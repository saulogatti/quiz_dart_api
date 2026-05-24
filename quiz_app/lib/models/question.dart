/// Representa uma pergunta de múltipla escolha retornada pela API do Quiz V2.
class Question {
  /// Identificador único da pergunta.
  final int id;

  /// Texto do enunciado da pergunta.
  final String question;
  final String category;
  final List<String> options;
  final int points;

  Question({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
    required this.points,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      question: json['question'] as String,
      category: json['category'] as String,
      options: List<String>.from(json['options'] as List),
      points: json['points'] as int,
    );
  }
}

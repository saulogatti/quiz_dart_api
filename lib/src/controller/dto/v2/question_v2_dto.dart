import 'dart:convert';

/// DTO de resposta para uma pergunta V2 — a resposta correta nunca é incluída,
/// apenas as [options] de múltipla escolha.
class QuestionV2Dto {
  final int id;
  final String question;
  final String category;
  final List<String> options;
  final int points;

  const QuestionV2Dto({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
    required this.points,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'category': category,
        'options': options,
        'points': points,
      };

  String toJson() => json.encode(toMap());
}

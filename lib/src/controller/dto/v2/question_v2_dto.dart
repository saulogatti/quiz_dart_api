import 'dart:convert';

/// DTO de resposta para uma pergunta V2 — a [answer] nunca é incluída.
class QuestionV2Dto {
  final int id;
  final String question;
  final String category;
  final int points;

  const QuestionV2Dto({
    required this.id,
    required this.question,
    required this.category,
    required this.points,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'category': category,
        'points': points,
      };

  String toJson() => json.encode(toMap());
}

import 'dart:convert';

/// DTO de resposta para uma pergunta da API V1.
///
/// Expõe apenas o [id] e o enunciado ([question]) — a resposta correta
/// nunca é incluída.
class QuestionDto {
  final int id;
  final String question;

  const QuestionDto({required this.id, required this.question});

  factory QuestionDto.fromJson(String source) =>
      QuestionDto.fromMap(json.decode(source) as Map<String, dynamic>);

  factory QuestionDto.fromMap(Map<String, dynamic> map) {
    return QuestionDto(id: map['id'] as int, question: map['question'] as String);
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'question': question};
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuestionDto {
  final int id;
  final String question;

  const QuestionDto({
    required this.id,
    required this.question,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
    };
  }

  factory QuestionDto.fromMap(Map<String, dynamic> map) {
    return QuestionDto(
      id: map['id'] as int,
      question: map['question'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionDto.fromJson(String source) => QuestionDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

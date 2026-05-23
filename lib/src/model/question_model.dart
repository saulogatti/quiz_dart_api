import 'dart:convert';

class QuestionModel {
  final int id;
  final String category;
  final String question;
  final String answer;

  const QuestionModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'catgory': category,
      'question': question,
      'response': answer,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? 0,
      category: map['catgory'] ?? '',
      question: map['question'] ?? '',
      answer: map['response'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

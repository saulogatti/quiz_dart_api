import 'package:json_annotation/json_annotation.dart';

part 'question_model.g.dart';

@JsonSerializable()
class QuestionModel {
  final int id;
  final int points;
  final String question;
  final String answer;

  const QuestionModel({
    required this.id,
    required this.points,
    required this.question,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

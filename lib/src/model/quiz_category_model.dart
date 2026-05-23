import 'package:json_annotation/json_annotation.dart';
import 'package:quiz_api/src/model/question_model.dart';

part 'quiz_category_model.g.dart';

@JsonSerializable()
class QuizCategoryModel {
  final String category;
  final List<QuestionModel> questions;

  const QuizCategoryModel({required this.category, required this.questions});

  factory QuizCategoryModel.fromJson(Map<String, dynamic> json) => _$QuizCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizCategoryModelToJson(this);
}

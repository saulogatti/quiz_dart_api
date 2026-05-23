// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'question_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String email;
  List<QuestionModel> answeredQuestions;

  UserModel({required this.email, required this.answeredQuestions});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

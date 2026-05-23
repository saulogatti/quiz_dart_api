// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'question_model.dart';

class UserModel {
  String email;
  List<QuestionModel> answeredQuestions;

  UserModel({
    required this.email,
    required this.answeredQuestions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'answeredQuestions': answeredQuestions.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      answeredQuestions: List<QuestionModel>.from(
        (map['answeredQuestions'] as List<Map<String, dynamic>>).map<QuestionModel>(
          (x) => QuestionModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'package:json_annotation/json_annotation.dart';

import 'question_model.dart';

part 'user_model.g.dart';

/// Modelo de domínio de um usuário da API V1.
///
/// Mantém a lista de [answeredQuestions] respondidas corretamente, usada
/// para evitar respostas duplicadas na mesma sessão.
@JsonSerializable()
class UserModel {
  String email;
  List<QuestionModel> answeredQuestions;

  UserModel({required this.email, required this.answeredQuestions});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

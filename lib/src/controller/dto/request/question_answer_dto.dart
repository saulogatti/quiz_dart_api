import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'question_answer_dto.g.dart';

/// DTO de entrada para o endpoint `POST /api/v1/questions/answer`.
///
/// Carrega o [id] da pergunta, o [userEmail] do usuário e a [answerResp] enviada.
@JsonSerializable()
class QuestionAnswerDto {
  final int id;
  final String? userEmail;
  final String? answerResp;

  const QuestionAnswerDto({required this.id, required this.userEmail, required this.answerResp});

  factory QuestionAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionAnswerDtoToJson(this);

  String toJsonString() => jsonEncode(toJson());
}

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'question_answer_dto.g.dart';

@JsonSerializable()
class QuestionAnswerDto {
  final int id;
  final String? userEmail;
  final String? answerResp;

  const QuestionAnswerDto({
    required this.id,
    required this.userEmail,
    required this.answerResp,
  });

  factory QuestionAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionAnswerDtoToJson(this);

  String toJsonString() => jsonEncode(toJson());
}

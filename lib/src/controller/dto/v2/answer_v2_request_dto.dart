import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'answer_v2_request_dto.g.dart';

/// DTO de entrada para o endpoint `POST /api/v2/questions/answer`.
///
/// Carrega o [id] da pergunta, a [category], o [userEmail] do usuário
/// e a [answerResp] fornecida.
@JsonSerializable()
class AnswerV2RequestDto {
  final int id;
  final String category;
  final String userEmail;
  final String answerResp;

  const AnswerV2RequestDto({
    required this.id,
    required this.category,
    required this.userEmail,
    required this.answerResp,
  });

  factory AnswerV2RequestDto.fromJson(Map<String, dynamic> json) =>
      _$AnswerV2RequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerV2RequestDtoToJson(this);

  String toJsonString() => jsonEncode(toJson());
}

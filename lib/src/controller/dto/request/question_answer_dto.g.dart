// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionAnswerDto _$QuestionAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuestionAnswerDto', json, ($checkedConvert) {
      final val = QuestionAnswerDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        userEmail: $checkedConvert('userEmail', (v) => v as String?),
        answerResp: $checkedConvert('answerResp', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$QuestionAnswerDtoToJson(QuestionAnswerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userEmail': instance.userEmail,
      'answerResp': instance.answerResp,
    };

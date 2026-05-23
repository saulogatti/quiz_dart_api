// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_v2_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerV2RequestDto _$AnswerV2RequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AnswerV2RequestDto', json, ($checkedConvert) {
      final val = AnswerV2RequestDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        category: $checkedConvert('category', (v) => v as String),
        userEmail: $checkedConvert('userEmail', (v) => v as String),
        answerResp: $checkedConvert('answerResp', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AnswerV2RequestDtoToJson(AnswerV2RequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'userEmail': instance.userEmail,
      'answerResp': instance.answerResp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_v2_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionV2Model _$QuestionV2ModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuestionV2Model', json, ($checkedConvert) {
      final val = QuestionV2Model(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        question: $checkedConvert('question', (v) => v as String),
        answer: $checkedConvert('answer', (v) => v as String),
        points: $checkedConvert('points', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$QuestionV2ModelToJson(QuestionV2Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'points': instance.points,
    };

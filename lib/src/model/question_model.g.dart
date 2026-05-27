// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuestionModel', json, ($checkedConvert) {
      final val = QuestionModel(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        points: $checkedConvert('points', (v) => (v as num).toInt()),
        question: $checkedConvert('question', (v) => v as String),
        answer: $checkedConvert('answer', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'points': instance.points,
      'question': instance.question,
      'answer': instance.answer,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizCategoryModel _$QuizCategoryModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuizCategoryModel', json, ($checkedConvert) {
      final val = QuizCategoryModel(
        category: $checkedConvert('category', (v) => v as String),
        questions: $checkedConvert(
          'questions',
          (v) => (v as List<dynamic>)
              .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuizCategoryModelToJson(QuizCategoryModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

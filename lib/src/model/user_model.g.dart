// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserModel', json, ($checkedConvert) {
      final val = UserModel(
        email: $checkedConvert('email', (v) => v as String),
        answeredQuestions: $checkedConvert(
          'answeredQuestions',
          (v) => (v as List<dynamic>)
              .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'answeredQuestions': instance.answeredQuestions
      .map((e) => e.toJson())
      .toList(),
};

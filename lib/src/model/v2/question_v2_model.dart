import 'package:json_annotation/json_annotation.dart';

part 'question_v2_model.g.dart';

/// Modelo interno de pergunta V2 carregado dos arquivos JSON por categoria.
///
/// A [answer] é usada apenas internamente no service e nunca exposta nas respostas da API.
@JsonSerializable()
class QuestionV2Model {
  final int id;
  final String question;
  final String answer;
  final int points;

  const QuestionV2Model({
    required this.id,
    required this.question,
    required this.answer,
    required this.points,
  });

  factory QuestionV2Model.fromJson(Map<String, dynamic> json) => _$QuestionV2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionV2ModelToJson(this);
}

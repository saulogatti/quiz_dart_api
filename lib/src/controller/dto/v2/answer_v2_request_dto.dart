import 'dart:convert';

/// DTO de entrada para o endpoint `POST /api/v2/questions/answer`.
///
/// Carrega o [id] da pergunta, a [category], o [userEmail] do usuário,
/// a [answerResp] fornecida e o flag [revealResult] que controla o "modo
/// mistério": quando `false`, a API não devolve se o usuário acertou ou
/// errou, nem os pontos ganhos nessa rodada — apenas atualiza o score.
class AnswerV2RequestDto {
  final int id;
  final String category;
  final String userEmail;
  final String answerResp;
  final bool revealResult;

  const AnswerV2RequestDto({
    required this.id,
    required this.category,
    required this.userEmail,
    required this.answerResp,
    this.revealResult = true,
  });

  factory AnswerV2RequestDto.fromJson(Map<String, dynamic> json) => AnswerV2RequestDto(
        id: json['id'] as int,
        category: json['category'] as String,
        userEmail: json['userEmail'] as String,
        answerResp: json['answerResp'] as String,
        revealResult: json['revealResult'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'userEmail': userEmail,
        'answerResp': answerResp,
        'revealResult': revealResult,
      };

  String toJsonString() => jsonEncode(toJson());
}

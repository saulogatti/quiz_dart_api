import 'dart:convert';

/// DTO de resposta parcial após o usuário enviar uma resposta.
///
/// Quando o cliente envia `revealResult=false` (modo mistério), apenas
/// [totalAnswered] é exposto — todos os demais campos vêm nulos e são
/// omitidos do JSON, evitando que o usuário deduza acerto/erro pela
/// variação do score. O veredito completo só é revelado no final, via
/// `GET /quiz/result`.
class AnswerV2ResultDto {
  final bool? correct;
  final int? pointsEarned;
  final int? totalScore;
  final int totalAnswered;
  final int? correctCount;
  final int? wrongCount;

  const AnswerV2ResultDto({
    required this.correct,
    required this.pointsEarned,
    required this.totalScore,
    required this.totalAnswered,
    required this.correctCount,
    required this.wrongCount,
  });

  Map<String, dynamic> toMap() => {
        if (correct != null) 'correct': correct,
        if (pointsEarned != null) 'pointsEarned': pointsEarned,
        if (totalScore != null) 'totalScore': totalScore,
        'totalAnswered': totalAnswered,
        if (correctCount != null) 'correctCount': correctCount,
        if (wrongCount != null) 'wrongCount': wrongCount,
      };

  String toJson() => json.encode(toMap());
}

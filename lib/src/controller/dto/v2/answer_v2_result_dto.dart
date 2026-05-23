import 'dart:convert';

/// DTO de resposta parcial após o usuário enviar uma resposta.
///
/// Retorna se acertou, quantos pontos ganhou nessa rodada e o score acumulado.
class AnswerV2ResultDto {
  final bool correct;
  final int pointsEarned;
  final int totalScore;
  final int totalAnswered;
  final int correctCount;
  final int wrongCount;

  const AnswerV2ResultDto({
    required this.correct,
    required this.pointsEarned,
    required this.totalScore,
    required this.totalAnswered,
    required this.correctCount,
    required this.wrongCount,
  });

  Map<String, dynamic> toMap() => {
        'correct': correct,
        'pointsEarned': pointsEarned,
        'totalScore': totalScore,
        'totalAnswered': totalAnswered,
        'correctCount': correctCount,
        'wrongCount': wrongCount,
      };

  String toJson() => json.encode(toMap());
}

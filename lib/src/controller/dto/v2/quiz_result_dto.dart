import 'dart:convert';

/// DTO de resultado final do usuário — retorna score completo e métricas.
class QuizResultDto {
  final String userEmail;
  final int totalScore;
  final int totalAnswered;
  final int correctCount;
  final int wrongCount;

  const QuizResultDto({
    required this.userEmail,
    required this.totalScore,
    required this.totalAnswered,
    required this.correctCount,
    required this.wrongCount,
  });

  Map<String, dynamic> toMap() => {
        'userEmail': userEmail,
        'totalScore': totalScore,
        'totalAnswered': totalAnswered,
        'correctCount': correctCount,
        'wrongCount': wrongCount,
      };

  String toJson() => json.encode(toMap());
}

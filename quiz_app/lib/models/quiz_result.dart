/// Representa as estatísticas consolidadas finais de uma sessão de quiz de um jogador.
class QuizResult {
  /// E-mail do jogador associado à sessão.
  final String userEmail;

  /// Pontuação final acumulada.
  final int totalScore;
  final int totalAnswered;
  final int correctCount;
  final int wrongCount;

  QuizResult({
    required this.userEmail,
    required this.totalScore,
    required this.totalAnswered,
    required this.correctCount,
    required this.wrongCount,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      userEmail: json['userEmail'] as String,
      totalScore: json['totalScore'] as int,
      totalAnswered: json['totalAnswered'] as int,
      correctCount: json['correctCount'] as int,
      wrongCount: json['wrongCount'] as int,
    );
  }
}

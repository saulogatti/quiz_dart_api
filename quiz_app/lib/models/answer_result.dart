/// Representa o veredito e as estatísticas parciais retornadas após responder uma pergunta.
///
/// Em Modo Mistério (`mysteryMode`), a maioria dos campos de pontuação e status (como
/// [correct] e [totalScore]) serão nulos, contendo apenas o número total de respondidas.
class AnswerResult {
  /// Indica se a alternativa enviada estava correta. Nulo no Modo Mistério.
  final bool? correct;

  /// Pontos ganhos nesta pergunta específica. Nulo no Modo Mistério.
  final int? pointsEarned;
  final int? totalScore;
  final int totalAnswered;
  final int? correctCount;
  final int? wrongCount;

  AnswerResult({
    this.correct,
    this.pointsEarned,
    this.totalScore,
    required this.totalAnswered,
    this.correctCount,
    this.wrongCount,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      correct: json['correct'] as bool?,
      pointsEarned: json['pointsEarned'] as int?,
      totalScore: json['totalScore'] as int?,
      totalAnswered: json['totalAnswered'] as int,
      correctCount: json['correctCount'] as int?,
      wrongCount: json['wrongCount'] as int?,
    );
  }
}

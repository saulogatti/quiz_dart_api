/// Modelo em memória que rastreia o score acumulado de um usuário na V2.
class UserScoreModel {
  final String email;
  int totalScore;
  int correctCount;
  int wrongCount;

  /// IDs de perguntas já respondidas, mapeados por categoria para evitar duplicatas.
  final Map<String, Set<int>> answeredQuestionIds;

  /// IDs de perguntas já entregues ao usuário (respondidas ou ainda não),
  /// mapeados por categoria. Usado pelo gerador para nunca repetir uma
  /// pergunta na mesma sessão.
  final Map<String, Set<int>> seenQuestionIds;

  UserScoreModel({
    required this.email,
    this.totalScore = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    Map<String, Set<int>>? answeredQuestionIds,
    Map<String, Set<int>>? seenQuestionIds,
  })  : answeredQuestionIds = answeredQuestionIds ?? {},
        seenQuestionIds = seenQuestionIds ?? {};

  int get totalAnswered => correctCount + wrongCount;
}

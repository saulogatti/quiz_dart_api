/// Modelo em memória que rastreia o score acumulado de um usuário na V2.
class UserScoreModel {
  final String email;
  int totalScore;
  int correctCount;
  int wrongCount;

  /// IDs de perguntas já respondidas, mapeados por categoria para evitar duplicatas.
  final Map<String, Set<int>> answeredQuestionIds;

  UserScoreModel({
    required this.email,
    this.totalScore = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    Map<String, Set<int>>? answeredQuestionIds,
  }) : answeredQuestionIds = answeredQuestionIds ?? {};

  int get totalAnswered => correctCount + wrongCount;
}

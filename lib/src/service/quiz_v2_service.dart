import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../controller/dto/v2/answer_v2_result_dto.dart';
import '../controller/dto/v2/question_v2_dto.dart';
import '../controller/dto/v2/quiz_result_dto.dart';
import '../exceptions/category_not_found_exception.dart';
import '../exceptions/not_found_exceptions.dart';
import '../model/v2/question_v2_model.dart';
import '../model/v2/user_score_model.dart';

/// Serviço de negócio da API V2 do quiz.
///
/// Carrega perguntas de arquivos JSON por categoria (diretório [_dataDir]),
/// mantém um cache em memória e controla o score acumulado dos usuários
/// via [UserScoreModel]. Todo o estado é volátil e perdido ao reiniciar o servidor.
class QuizV2Service {
  /// Diretório base dos arquivos JSON de dados V2.
  static const String _dataDir = 'lib/data/v2';

  /// Score acumulado por email de usuário, mantido em memória.
  final Map<String, UserScoreModel> _userScores = {};

  /// Cache de perguntas carregadas por categoria.
  final Map<String, List<QuestionV2Model>> _categoryCache = {};

  /// Verifica a resposta do usuário e atualiza o score acumulado.
  ///
  /// Quando [revealResult] é `false`, o DTO retornado omite `correct` e
  /// `pointsEarned` — o score acumulado continua sendo atualizado normalmente.
  AnswerV2ResultDto answerQuestion({
    required int id,
    required String category,
    required String userEmail,
    required String answerResp,
    bool revealResult = true,
  }) {
    final questions = _loadCategory(category);

    final question = questions.where((q) => q.id == id).firstOrNull;
    if (question == null) {
      throw NotFoundExcpetion(
        message: 'Pergunta com id $id não encontrada na categoria "$category".',
      );
    }

    final userScore = _userScores.putIfAbsent(userEmail, () => UserScoreModel(email: userEmail));

    final answeredIds = userScore.answeredQuestionIds.putIfAbsent(category, () => {});
    userScore.seenQuestionIds.putIfAbsent(category, () => {}).add(id);
    final alreadyAnswered = answeredIds.contains(id);

    final bool correct = question.answer.toLowerCase().trim() == answerResp.toLowerCase().trim();
    final int pointsEarned = (!alreadyAnswered && correct) ? question.points : 0;

    if (!alreadyAnswered) {
      answeredIds.add(id);
      if (correct) {
        userScore.correctCount++;
      } else {
        userScore.wrongCount++;
      }
      userScore.totalScore += pointsEarned;
    }

    return AnswerV2ResultDto(
      correct: revealResult ? correct : null,
      pointsEarned: revealResult ? pointsEarned : null,
      totalScore: revealResult ? userScore.totalScore : null,
      totalAnswered: userScore.totalAnswered,
      correctCount: revealResult ? userScore.correctCount : null,
      wrongCount: revealResult ? userScore.wrongCount : null,
    );
  }

  /// Gera uma pergunta aleatória da [category] com as alternativas embaralhadas,
  /// pulando perguntas que [userEmail] já viu nesta sessão. Quando [userEmail]
  /// não é informado, opera sem filtro (modo anônimo).
  ///
  /// Lança [NotFoundExcpetion] se o usuário já esgotou todas as perguntas da
  /// categoria — o cliente deve tratar como "fim da categoria".
  QuestionV2Dto generateQuestion({required String category, String? userEmail}) {
    final questions = _loadCategory(category);

    if (questions.isEmpty) {
      throw NotFoundExcpetion(message: 'Nenhuma pergunta encontrada para a categoria "$category".');
    }

    final seen = (userEmail != null)
        ? _userScores
            .putIfAbsent(userEmail, () => UserScoreModel(email: userEmail))
            .seenQuestionIds
            .putIfAbsent(category, () => {})
        : null;

    final pool = (seen == null)
        ? questions
        : questions.where((q) => !seen.contains(q.id)).toList();

    if (pool.isEmpty) {
      throw NotFoundExcpetion(
        message: 'Sem mais perguntas na categoria "$category" — você já respondeu '
            'todas as ${questions.length} disponíveis.',
      );
    }

    final random = Random();
    final question = pool[random.nextInt(pool.length)];
    seen?.add(question.id);

    final shuffled = [...question.options]..shuffle(random);

    return QuestionV2Dto(
      id: question.id,
      question: question.question,
      category: category,
      options: shuffled,
      points: question.points,
    );
  }

  /// Retorna o resultado final acumulado do usuário.
  QuizResultDto getUserResult({required String userEmail}) {
    final userScore = _userScores[userEmail];

    if (userScore == null) {
      return QuizResultDto(
        userEmail: userEmail,
        totalScore: 0,
        totalAnswered: 0,
        correctCount: 0,
        wrongCount: 0,
      );
    }

    return QuizResultDto(
      userEmail: userEmail,
      totalScore: userScore.totalScore,
      totalAnswered: userScore.totalAnswered,
      correctCount: userScore.correctCount,
      wrongCount: userScore.wrongCount,
    );
  }

  List<QuestionV2Model> _loadCategory(String category) {
    if (_categoryCache.containsKey(category)) {
      return _categoryCache[category]!;
    }

    final file = File('$_dataDir/$category.json');
    if (!file.existsSync()) {
      throw CategoryNotFoundException(category: category);
    }

    final raw = file.readAsStringSync();
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final questionsJson = decoded['questions'] as List<dynamic>;

    final questions = questionsJson
        .map((q) => QuestionV2Model.fromJson(q as Map<String, dynamic>))
        .toList();

    _categoryCache[category] = questions;
    return questions;
  }
}

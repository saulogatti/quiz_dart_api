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
  /// Score acumulado por email de usuário, mantido em memória.
  final Map<String, UserScoreModel> _userScores = {};

  /// Cache de perguntas carregadas por categoria.
  final Map<String, List<QuestionV2Model>> _categoryCache = {};

  /// Diretório base dos arquivos JSON de dados V2.
  static const String _dataDir = 'lib/data/v2';

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

    final questions =
        questionsJson.map((q) => QuestionV2Model.fromJson(q as Map<String, dynamic>)).toList();

    _categoryCache[category] = questions;
    return questions;
  }

  /// Gera uma pergunta aleatória da [category] sem expor a resposta.
  QuestionV2Dto generateQuestion({required String category}) {
    final questions = _loadCategory(category);

    if (questions.isEmpty) {
      throw NotFoundExcpetion(message: 'Nenhuma pergunta encontrada para a categoria "$category".');
    }

    final index = Random().nextInt(questions.length);
    final question = questions[index];

    return QuestionV2Dto(
      id: question.id,
      question: question.question,
      category: category,
      points: question.points,
    );
  }

  /// Verifica a resposta do usuário e atualiza o score acumulado.
  ///
  /// Retorna [AnswerV2ResultDto] com resultado parcial (acerto/erro + score atual).
  AnswerV2ResultDto answerQuestion({
    required int id,
    required String category,
    required String userEmail,
    required String answerResp,
  }) {
    final questions = _loadCategory(category);

    final question = questions.where((q) => q.id == id).firstOrNull;
    if (question == null) {
      throw NotFoundExcpetion(
        message: 'Pergunta com id $id não encontrada na categoria "$category".',
      );
    }

    final userScore = _userScores.putIfAbsent(
      userEmail,
      () => UserScoreModel(email: userEmail),
    );

    final answeredIds = userScore.answeredQuestionIds.putIfAbsent(category, () => {});
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
      correct: correct,
      pointsEarned: pointsEarned,
      totalScore: userScore.totalScore,
      totalAnswered: userScore.totalAnswered,
      correctCount: userScore.correctCount,
      wrongCount: userScore.wrongCount,
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
}

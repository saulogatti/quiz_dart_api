import 'dart:math';

import '../controller/dto/response/question_dto.dart';
import '../data/questions.mock.dart';
import '../exceptions/answered_question_exception.dart';
import '../exceptions/invalid_answer_exception.dart';
import '../exceptions/not_found_exceptions.dart';
import '../model/question_model.dart';
import '../model/user_model.dart';
import 'user_service.dart';

/// Serviço de negócio da API V1 do quiz.
///
/// Opera sobre dados mock em memória (lista [questions]) e delega operações
/// de usuário ao [UserService]. Todo o estado é volátil.
class QuizService {
  final UserService _userService = UserService();

  /// Verifica se a resposta [answerResp] para a pergunta de [id] está correta.
  ///
  /// Lança [NotFoundExcpetion] se a pergunta não existir, [AnsweredQuestionException]
  /// se o usuário [userEmail] já respondeu corretamente, e [InvalidAnswerException]
  /// se a resposta estiver errada. Retorna `true` ao acertar e registra a
  /// pergunta na lista de respondidas do usuário.
  bool answerQuestion(int id, String answerResp, String userEmail) {
    Map<String, dynamic>? question = questions
        .where((element) => element['id'] == id)
        .toList()
        .firstOrNull;

    if (question == null || question.isEmpty) {
      throw NotFoundExcpetion(message: 'Ops, não foi possível encontrar a pergunta com id $id');
    }

    QuestionModel questionModel = QuestionModel.fromJson(question);

    UserModel user = _userService.findUserByEmail(userEmail);

    for (var answeredQuestion in user.answeredQuestions) {
      if (answeredQuestion.id == questionModel.id) {
        throw AnsweredQuestionException();
      }
    }

    bool answerIsCorrect = questionModel.answer.toLowerCase() == answerResp.toLowerCase();

    if (!answerIsCorrect) {
      throw InvalidAnswerException();
    }

    user.answeredQuestions.add(questionModel);
    _userService.updateUser(user.toJson());

    return answerIsCorrect;
  }

  /// Gera e retorna um [QuestionDto] aleatório.
  ///
  /// Quando [category] é informado, filtra as perguntas pela categoria correspondente.
  /// Lança [NotFoundExcpetion] se não houver perguntas disponíveis.
  QuestionDto generateRandomQuestion({String? category}) {
    List<Map<String, dynamic>> localQuestions = [];
    localQuestions.addAll(questions);

    if (category != null && category.isNotEmpty) {
      localQuestions.clear();
      localQuestions.addAll(questions.where((element) => element['category'] == category).toList());
    }

    if (localQuestions.isEmpty) {
      throw NotFoundExcpetion(message: 'Ops, não foi possível gerar uma pergunta. Tente novamente');
    }

    int ramdom = _buildRandomNumber(localQuestions.length);

    QuestionModel questionModel = QuestionModel.fromJson(localQuestions[ramdom]);

    QuestionDto questionDto = QuestionDto(id: questionModel.id, question: questionModel.question);

    return questionDto;
  }

  int _buildRandomNumber(int max) {
    return max > 0 ? Random().nextInt(max) : 0;
  }
}

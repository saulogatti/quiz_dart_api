import 'dart:math';
import '../controller/dto/response/question_dto.dart';
import '../data/questions.mock.dart';
import '../exceptions/answered_question_exception.dart';
import '../exceptions/invalid_answer_exception.dart';
import '../exceptions/not_found_exceptions.dart';
import '../model/question_model.dart';
import '../model/user_model.dart';
import 'user_service.dart';

class QuizService {
  final UserService _userService = UserService();

  QuestionDto generateRandomQuestion({String? category}) {
    List<Map<String, dynamic>> localQuestions = [];
    localQuestions.addAll(questions);

    if (category != null && category.isNotEmpty) {
      localQuestions.clear();
      localQuestions.addAll(localQuestions.where((element) {
        QuestionModel questionModel = QuestionModel.fromMap(element);
        return questionModel.category.contains(category);
      }).toList());
    }

    if (localQuestions.isEmpty) {
      throw NotFoundExcpetion(message: 'Ops, não foi possível gerar uma pergunta. Tente novamente');
    }

    int ramdom = _buildRandomNumber(localQuestions.length);

    QuestionModel questionModel = QuestionModel.fromMap(localQuestions[ramdom]);

    QuestionDto questionDto = QuestionDto(id: questionModel.id, question: questionModel.question);

    return questionDto;
  }

  bool answerQuestion(int id, String answerResp, String userEmail) {
    Map<String, dynamic>? question = questions.where((element) => element['id'] == id).toList().firstOrNull;

    if (question == null || question.isEmpty) {
      throw NotFoundExcpetion(message: 'Ops, não foi possível encontrar a pergunta com id $id');
    }

    QuestionModel questionModel = QuestionModel.fromMap(question);

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
    _userService.updateUser(user.toMap());

    return answerIsCorrect;
  }

  int _buildRandomNumber(int max) {
    return max > 0 ? Random().nextInt(max) : 0;
  }
}

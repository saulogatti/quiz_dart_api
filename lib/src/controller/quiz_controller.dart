import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import '../service/quiz_service.dart';
import 'dto/request/question_answer_dto.dart';
import 'dto/response/question_dto.dart';

class QuizController {
  static const baseRoute = '/quiz';

  final QuizService _quizService = QuizService();

  Response generateRandomQuestion(Request request) {
    Map<String, String> params = request.url.queryParameters;

    String? categoryPreference;
    if (params.containsKey('category')) {
      categoryPreference = params['category'];
    }

    QuestionDto question = _quizService.generateRandomQuestion(category: categoryPreference);

    return Response.ok(question.toJson(), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<Response> answerQuestionByEmail(Request request) async {
    final String requestBodyJson = await request.readAsString();

    QuestionAnswerDto questionAnswerDto = QuestionAnswerDto.fromMap(jsonDecode(requestBodyJson));

    _quizService.answerQuestion(
      questionAnswerDto.id,
      questionAnswerDto.answerResp ?? '',
      questionAnswerDto.userEmail ?? '',
    );

    return Response.ok('Resposta correta!', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
    });
  }
}

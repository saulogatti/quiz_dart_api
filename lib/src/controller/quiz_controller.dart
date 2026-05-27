import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../service/quiz_service.dart';
import 'dto/request/question_answer_dto.dart';
import 'dto/response/question_dto.dart';

/// Controlador HTTP para os endpoints da API V1 do quiz.
///
/// Delega a lógica de negócio ao [QuizService]. Erros do tipo [CustomException]
/// são tratados centralmente no [RoutesHandler].
class QuizController {
  final QuizService _quizService = QuizService();

  /// `POST /api/v1/questions/answer`
  ///
  /// Recebe um JSON com [QuestionAnswerDto] no corpo da requisição, verifica a
  /// resposta e retorna HTTP 200 com texto simples em caso de acerto.
  Future<Response> answerQuestionByEmail(Request request) async {
    final String requestBodyJson = await request.readAsString();

    QuestionAnswerDto questionAnswerDto = QuestionAnswerDto.fromJson(jsonDecode(requestBodyJson));

    _quizService.answerQuestion(
      questionAnswerDto.id,
      questionAnswerDto.answerResp ?? '',
      questionAnswerDto.userEmail ?? '',
    );

    return Response.ok('Resposta correta!', headers: {HttpHeaders.contentTypeHeader: 'text/plain'});
  }

  /// `GET /api/v1/questions/generate?category=X`
  ///
  /// Retorna uma pergunta aleatória. O query param `category` é opcional; quando
  /// ausente, a pergunta pode ser de qualquer categoria disponível.
  Response generateRandomQuestion(Request request) {
    Map<String, String> params = request.url.queryParameters;

    String? categoryPreference;
    if (params.containsKey('category')) {
      categoryPreference = params['category'];
    }

    QuestionDto question = _quizService.generateRandomQuestion(category: categoryPreference);

    return Response.ok(
      question.toJson(),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  }
}

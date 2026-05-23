import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../exceptions/custom_exception.dart';
import '../service/quiz_v2_service.dart';
import 'dto/response/error_dto.dart';
import 'dto/v2/answer_v2_request_dto.dart';

/// Controlador HTTP para os endpoints da API V2 do quiz.
///
/// Delega a lógica de negócio ao [QuizV2Service] e converte exceções do tipo
/// [CustomException] em respostas JSON com o status HTTP adequado.
class QuizV2Controller {
  final QuizV2Service _service = QuizV2Service();

  /// `POST /api/v2/questions/answer`
  ///
  /// Verifica a resposta e retorna o resultado parcial (score acumulado).
  Future<Response> answerQuestion(Request request) async {
    final body = await request.readAsString();

    AnswerV2RequestDto dto;
    try {
      dto = AnswerV2RequestDto.fromJson(jsonDecode(body) as Map<String, dynamic>);
    } catch (_) {
      return Response(
        400,
        body: jsonEncode({
          'message': 'Body inválido. Campos obrigatórios: id, category, userEmail, answerResp.',
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }

    try {
      final result = _service.answerQuestion(
        id: dto.id,
        category: dto.category,
        userEmail: dto.userEmail,
        answerResp: dto.answerResp,
        revealResult: dto.revealResult,
      );
      return Response.ok(
        result.toJson(),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    } on CustomException catch (e) {
      return Response(
        e.status,
        body: ErrorDto.fromMap({'message': e.message}).toJson(),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }
  }

  /// `GET /api/v2/questions/generate?category=X`
  ///
  /// Retorna uma pergunta aleatória da categoria informada, sem expor a resposta.
  Response generateQuestion(Request request) {
    final category = request.url.queryParameters['category'];
    final userEmail = request.url.queryParameters['userEmail'];

    if (category == null || category.isEmpty) {
      return Response(
        400,
        body: jsonEncode({'message': 'O parâmetro "category" é obrigatório.'}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }

    try {
      final dto = _service.generateQuestion(
        category: category,
        userEmail: (userEmail != null && userEmail.isNotEmpty) ? userEmail : null,
      );
      return Response.ok(
        dto.toJson(),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    } on CustomException catch (e) {
      return Response(
        e.status,
        body: ErrorDto.fromMap({'message': e.message}).toJson(),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }
  }

  /// `GET /api/v2/quiz/result?userEmail=X`
  ///
  /// Retorna o resultado final acumulado do usuário.
  Response getResult(Request request) {
    final userEmail = request.url.queryParameters['userEmail'];

    if (userEmail == null || userEmail.isEmpty) {
      return Response(
        400,
        body: jsonEncode({'message': 'O parâmetro "userEmail" é obrigatório.'}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }

    final result = _service.getUserResult(userEmail: userEmail);
    return Response.ok(
      result.toJson(),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  }
}

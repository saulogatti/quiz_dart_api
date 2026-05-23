import 'dart:convert';

import 'package:quiz_api/src/controller/quiz_v2_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

Request _get(String path) => Request('GET', Uri.parse('http://localhost$path'));

Request _post(String path, Map<String, dynamic> body) => Request(
      'POST',
      Uri.parse('http://localhost$path'),
      body: jsonEncode(body),
      headers: {'content-type': 'application/json'},
    );

void main() {
  group('QuizV2Controller', () {
    late QuizV2Controller controller;

    setUp(() {
      controller = QuizV2Controller();
    });

    // -------------------------------------------------------------------------
    // GET /questions/generate
    // -------------------------------------------------------------------------
    group('generateQuestion', () {
      test('retorna 200 com JSON válido para categoria existente', () async {
        final response = controller.generateQuestion(
          _get('/api/v2/questions/generate?category=geography'),
        );

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body['id'], isA<int>());
        expect(body['question'], isA<String>());
        expect(body['category'], equals('geography'));
        expect(body['points'], isA<int>());
        expect(body['options'], isA<List<dynamic>>());
        expect((body['options'] as List).length, lessThanOrEqualTo(4));
        expect(body.containsKey('answer'), isFalse);
      });

      test('retorna 400 quando category não é informado', () async {
        final response = controller.generateQuestion(
          _get('/api/v2/questions/generate'),
        );

        expect(response.statusCode, equals(400));
      });

      test('retorna 404 para categoria inexistente', () async {
        final response = controller.generateQuestion(
          _get('/api/v2/questions/generate?category=categoriaInexistente'),
        );

        expect(response.statusCode, equals(404));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body.containsKey('message'), isTrue);
      });

      test('Content-Type é application/json', () async {
        final response = controller.generateQuestion(
          _get('/api/v2/questions/generate?category=generalKnowledge'),
        );

        expect(response.headers['content-type'], contains('application/json'));
      });
    });

    // -------------------------------------------------------------------------
    // POST /questions/answer
    // -------------------------------------------------------------------------
    group('answerQuestion', () {
      test('retorna 200 com resultado parcial para resposta correta', () async {
        final response = await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 2,
            'category': 'geography',
            'userEmail': 'ctrl_acerto@test.com',
            'answerResp': 'vaticano',
          }),
        );

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body['correct'], isTrue);
        expect(body['pointsEarned'], greaterThan(0));
        expect(body['totalScore'], greaterThan(0));
        expect(body['totalAnswered'], equals(1));
        expect(body['correctCount'], equals(1));
        expect(body['wrongCount'], equals(0));
      });

      test('retorna 200 com resultado parcial para resposta errada', () async {
        final response = await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 2,
            'category': 'geography',
            'userEmail': 'ctrl_erro@test.com',
            'answerResp': 'errado',
          }),
        );

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body['correct'], isFalse);
        expect(body['pointsEarned'], equals(0));
        expect(body['totalScore'], equals(0));
        expect(body['wrongCount'], equals(1));
      });

      test('retorna 400 para body inválido', () async {
        final response = await controller.answerQuestion(
          Request(
            'POST',
            Uri.parse('http://localhost/api/v2/questions/answer'),
            body: 'isso nao é json',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(response.statusCode, equals(400));
      });

      test('retorna 404 para id inexistente na categoria', () async {
        final response = await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 9999,
            'category': 'geography',
            'userEmail': 'ctrl_naoexiste@test.com',
            'answerResp': 'qualquer',
          }),
        );

        expect(response.statusCode, equals(404));
      });

      test('revealResult=false não inclui correct nem pointsEarned no body', () async {
        final response = await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 2,
            'category': 'geography',
            'userEmail': 'ctrl_misterio@test.com',
            'answerResp': 'Vaticano',
            'revealResult': false,
          }),
        );

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body.containsKey('correct'), isFalse);
        expect(body.containsKey('pointsEarned'), isFalse);
        expect(body.containsKey('totalScore'), isFalse);
        expect(body.containsKey('correctCount'), isFalse);
        expect(body.containsKey('wrongCount'), isFalse);
        expect(body['totalAnswered'], equals(1));
      });

      test('retorna 404 para categoria inexistente', () async {
        final response = await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 1,
            'category': 'categoriaInvalida',
            'userEmail': 'ctrl_cat@test.com',
            'answerResp': 'qualquer',
          }),
        );

        expect(response.statusCode, equals(404));
      });
    });

    // -------------------------------------------------------------------------
    // GET /quiz/result
    // -------------------------------------------------------------------------
    group('getResult', () {
      test('retorna 200 com zeros para usuário sem histórico', () async {
        final response = controller.getResult(
          _get('/api/v2/quiz/result?userEmail=novo@test.com'),
        );

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body['userEmail'], equals('novo@test.com'));
        expect(body['totalScore'], equals(0));
        expect(body['totalAnswered'], equals(0));
        expect(body['correctCount'], equals(0));
        expect(body['wrongCount'], equals(0));
      });

      test('retorna 200 com métricas após respostas via controller', () async {
        const email = 'final@test.com';

        await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 3,
            'category': 'geography',
            'userEmail': email,
            'answerResp': 'ottawa',
          }),
        );
        await controller.answerQuestion(
          _post('/api/v2/questions/answer', {
            'id': 4,
            'category': 'geography',
            'userEmail': email,
            'answerResp': 'errado',
          }),
        );

        final response = controller.getResult(
          _get('/api/v2/quiz/result?userEmail=$email'),
        );

        final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
        expect(body['totalAnswered'], equals(2));
        expect(body['correctCount'], equals(1));
        expect(body['wrongCount'], equals(1));
        expect(body['totalScore'], greaterThan(0));
      });

      test('retorna 400 quando userEmail não é informado', () async {
        final response = controller.getResult(
          _get('/api/v2/quiz/result'),
        );

        expect(response.statusCode, equals(400));
      });

      test('Content-Type é application/json', () async {
        final response = controller.getResult(
          _get('/api/v2/quiz/result?userEmail=check@test.com'),
        );

        expect(response.headers['content-type'], contains('application/json'));
      });
    });
  });
}

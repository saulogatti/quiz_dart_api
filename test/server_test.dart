import 'dart:convert';

import 'package:quiz_api/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Handler handler;

  setUp(() {
    handler = createHandler();
  });

  // ---------------------------------------------------------------------------
  // V1 routes
  // ---------------------------------------------------------------------------
  group('GET /api/v1/questions/generate', () {
    test('retorna 200 com pergunta JSON para categoria válida', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v1/questions/generate?category=geography'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['id'], isA<int>());
      expect(body['question'], isA<String>());
    });

    test('retorna 404 para categoria inexistente', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v1/questions/generate?category=naoExiste'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(404));
    });
  });

  group('POST /api/v1/questions/answer', () {
    test('retorna 404 para pergunta com id inexistente', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/v1/questions/answer'),
        body: jsonEncode({'id': 9999, 'userEmail': 'v1_test@test.com', 'answerResp': 'qualquer'}),
        headers: {'content-type': 'application/json'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(404));
    });
  });

  // ---------------------------------------------------------------------------
  // V2 routes
  // ---------------------------------------------------------------------------
  group('GET /api/v2/questions/generate', () {
    test('retorna 200 com pergunta JSON sem answer', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v2/questions/generate?category=geography'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['id'], isA<int>());
      expect(body['question'], isA<String>());
      expect(body['category'], equals('geography'));
      expect(body['points'], isA<int>());
      expect(body.containsKey('answer'), isFalse);
    });

    test('retorna 400 sem parâmetro category', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v2/questions/generate'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(400));
    });

    test('retorna 404 para categoria inexistente', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v2/questions/generate?category=naoExiste'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(404));
    });
  });

  group('POST /api/v2/questions/answer', () {
    test('retorna 200 com resultado parcial para resposta correta', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/v2/questions/answer'),
        body: jsonEncode({
          'id': 2,
          'category': 'geography',
          'userEmail': 'server_test@test.com',
          'answerResp': 'vaticano',
        }),
        headers: {'content-type': 'application/json'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['correct'], isTrue);
      expect(body['pointsEarned'], greaterThan(0));
      expect(body['totalScore'], greaterThan(0));
    });

    test('retorna 200 com resultado parcial para resposta errada', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/v2/questions/answer'),
        body: jsonEncode({
          'id': 3,
          'category': 'geography',
          'userEmail': 'server_errado@test.com',
          'answerResp': 'resposta_errada',
        }),
        headers: {'content-type': 'application/json'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['correct'], isFalse);
      expect(body['pointsEarned'], equals(0));
    });

    test('retorna 400 para body inválido', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/v2/questions/answer'),
        body: 'nao_e_json',
        headers: {'content-type': 'application/json'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(400));
    });
  });

  group('GET /api/v2/quiz/result', () {
    test('retorna 200 com zeros para usuário sem histórico', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v2/quiz/result?userEmail=novo_server@test.com'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['totalScore'], equals(0));
      expect(body['totalAnswered'], equals(0));
    });

    test('retorna 400 sem parâmetro userEmail', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/v2/quiz/result'),
      );
      final response = await handler(request);

      expect(response.statusCode, equals(400));
    });
  });

  // ---------------------------------------------------------------------------
  // Rota inexistente
  // ---------------------------------------------------------------------------
  test('retorna 404 para rota inexistente', () async {
    final request = Request('GET', Uri.parse('http://localhost/rota-que-nao-existe'));
    final response = await handler(request);

    expect(response.statusCode, equals(404));
  });
}
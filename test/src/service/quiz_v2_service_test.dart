import 'dart:convert';
import 'dart:io';

import 'package:quiz_api/src/exceptions/category_not_found_exception.dart';
import 'package:quiz_api/src/exceptions/not_found_exceptions.dart';
import 'package:quiz_api/src/service/quiz_v2_service.dart';
import 'package:test/test.dart';

void main() {
  group('QuizV2Service', () {
    late QuizV2Service service;

    setUp(() {
      service = QuizV2Service();
    });

    // -------------------------------------------------------------------------
    // generateQuestion
    // -------------------------------------------------------------------------
    group('generateQuestion', () {
      test('retorna uma pergunta para categoria válida', () {
        final dto = service.generateQuestion(category: 'geography');

        expect(dto.id, isA<int>());
        expect(dto.question, isNotEmpty);
        expect(dto.category, equals('geography'));
        expect(dto.points, greaterThan(0));
      });

      test('nunca expõe a resposta no DTO retornado', () {
        final dto = service.generateQuestion(category: 'generalKnowledge');

        // QuestionV2Dto não tem campo answer — verificamos via toMap
        final map = dto.toMap();
        expect(map.containsKey('answer'), isFalse);
      });

      test('retorna opções de múltipla escolha (até 4)', () {
        final dto = service.generateQuestion(category: 'geography');

        expect(dto.options, isNotEmpty);
        expect(dto.options.length, lessThanOrEqualTo(4));
      });

      test('não repete perguntas para o mesmo userEmail', () {
        const email = 'sem-repetir@test.com';
        final seenIds = <int>{};

        // Esgota todas as perguntas — 10 por categoria
        for (var i = 0; i < 10; i++) {
          final dto = service.generateQuestion(category: 'geography', userEmail: email);
          expect(seenIds.contains(dto.id), isFalse,
              reason: 'pergunta id=${dto.id} foi repetida na iteração $i');
          seenIds.add(dto.id);
        }
        expect(seenIds.length, equals(10));
      });

      test('lança NotFoundExcpetion quando o usuário esgotou a categoria', () {
        const email = 'esgotou@test.com';
        for (var i = 0; i < 10; i++) {
          service.generateQuestion(category: 'geography', userEmail: email);
        }
        expect(
          () => service.generateQuestion(category: 'geography', userEmail: email),
          throwsA(isA<NotFoundExcpetion>()),
        );
      });

      test('lança CategoryNotFoundException para categoria inexistente', () {
        expect(
          () => service.generateQuestion(category: 'categoriaInexistente'),
          throwsA(isA<CategoryNotFoundException>()),
        );
      });

      test('retorna perguntas de todas as categorias disponíveis', () {
        final categories = ['generalKnowledge', 'geography', 'historyFashion', 'popCultureMusic'];
        for (final category in categories) {
          final dto = service.generateQuestion(category: category);
          expect(dto.category, equals(category));
        }
      });
    });

    // -------------------------------------------------------------------------
    // answerQuestion
    // -------------------------------------------------------------------------
    group('answerQuestion', () {
      test('acerto retorna correct=true e pontos da pergunta', () {
        final result = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: 'acerto@test.com',
          answerResp: 'Vaticano',
        );

        expect(result.correct, isTrue);
        expect(result.pointsEarned, greaterThan(0));
        expect(result.totalScore, equals(result.pointsEarned));
        expect(result.correctCount, equals(1));
        expect(result.wrongCount, equals(0));
      });

      test('erro retorna correct=false e pointsEarned=0', () {
        final result = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: 'erro@test.com',
          answerResp: 'resposta_errada',
        );

        expect(result.correct, isFalse);
        expect(result.pointsEarned, equals(0));
        expect(result.totalScore, equals(0));
        expect(result.correctCount, equals(0));
        expect(result.wrongCount, equals(1));
      });

      test('score acumula corretamente após múltiplos acertos', () {
        final email = 'acumula@test.com';

        final r1 = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: email,
          answerResp: 'Vaticano',
        );
        final r2 = service.answerQuestion(
          id: 3,
          category: 'geography',
          userEmail: email,
          answerResp: 'Ottawa',
        );

        expect(r2.totalScore, equals(r1.pointsEarned! + r2.pointsEarned!));
        expect(r2.correctCount, equals(2));
        expect(r2.totalAnswered, equals(2));
      });

      test('pergunta já respondida não soma pontos novamente', () {
        final email = 'duplicata@test.com';

        final r1 = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: email,
          answerResp: 'Vaticano',
        );
        final r2 = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: email,
          answerResp: 'Vaticano',
        );

        expect(r2.totalScore, equals(r1.totalScore));
        expect(r2.pointsEarned, equals(0));
        expect(r2.totalAnswered, equals(r1.totalAnswered));
      });

      test('lança NotFoundExcpetion para id inexistente na categoria', () {
        expect(
          () => service.answerQuestion(
            id: 9999,
            category: 'geography',
            userEmail: 'naoexiste@test.com',
            answerResp: 'qualquer',
          ),
          throwsA(isA<NotFoundExcpetion>()),
        );
      });

      test('lança CategoryNotFoundException para categoria inexistente', () {
        expect(
          () => service.answerQuestion(
            id: 1,
            category: 'categoriaInvalida',
            userEmail: 'cat@test.com',
            answerResp: 'qualquer',
          ),
          throwsA(isA<CategoryNotFoundException>()),
        );
      });

      test('resposta case-insensitive é aceita como correta', () {
        final result = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: 'case@test.com',
          answerResp: 'VATICANO',
        );

        expect(result.correct, isTrue);
      });

      test('modo mistério (revealResult=false) omite todos os campos de veredito', () {
        final result = service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: 'misterio@test.com',
          answerResp: 'Vaticano',
          revealResult: false,
        );

        expect(result.correct, isNull);
        expect(result.pointsEarned, isNull);
        expect(result.totalScore, isNull);
        expect(result.correctCount, isNull);
        expect(result.wrongCount, isNull);
        // totalAnswered é exposto para o cliente saber que registrou
        expect(result.totalAnswered, equals(1));

        // score é mantido por baixo dos panos — confirmado via getUserResult
        final reveal = service.getUserResult(userEmail: 'misterio@test.com');
        expect(reveal.totalScore, greaterThan(0));
        expect(reveal.correctCount, equals(1));
      });
    });

    // -------------------------------------------------------------------------
    // getUserResult
    // -------------------------------------------------------------------------
    group('getUserResult', () {
      test('retorna zeros para usuário sem histórico', () {
        final result = service.getUserResult(userEmail: 'novo@test.com');

        expect(result.userEmail, equals('novo@test.com'));
        expect(result.totalScore, equals(0));
        expect(result.totalAnswered, equals(0));
        expect(result.correctCount, equals(0));
        expect(result.wrongCount, equals(0));
      });

      test('retorna métricas acumuladas após respostas', () {
        final email = 'resultado@test.com';

        service.answerQuestion(
          id: 2,
          category: 'geography',
          userEmail: email,
          answerResp: 'Vaticano',
        );
        service.answerQuestion(
          id: 3,
          category: 'geography',
          userEmail: email,
          answerResp: 'errado',
        );

        final result = service.getUserResult(userEmail: email);

        expect(result.userEmail, equals(email));
        expect(result.totalAnswered, equals(2));
        expect(result.correctCount, equals(1));
        expect(result.wrongCount, equals(1));
        expect(result.totalScore, greaterThan(0));
      });
    });

    // -------------------------------------------------------------------------
    // generalKnowledge mixing & 100-limit
    // -------------------------------------------------------------------------
    group('generalKnowledge mixing and 100-limit', () {
      test('generalKnowledge mistura perguntas de outras categorias com IDs virtuais', () {
        final dto = service.generateQuestion(category: 'generalKnowledge');
        expect(dto.id, greaterThanOrEqualTo(1000)); // IDs virtuais começam acima de 1000

        // Tenta gerar várias perguntas e garante que os IDs pertençam a diferentes faixas
        final categoriesSeen = <int>{};
        for (var i = 0; i < 25; i++) {
          try {
            final q = service.generateQuestion(category: 'generalKnowledge', userEmail: 'mix@test.com');
            final categoryRange = q.id ~/ 1000;
            categoriesSeen.add(categoryRange);
          } catch (_) {
            break;
          }
        }
        // Deve ter visto perguntas de múltiplas categorias (faixas de IDs diferentes)
        expect(categoriesSeen.length, greaterThan(1));
      });

      test('limite de 100 perguntas lança erro após atingido', () {
        // Vamos criar um arquivo de teste com 105 perguntas para validar o limite
        final file = File('lib/data/v2/test100.json');
        final questionsList = List.generate(105, (i) => {
          'id': i + 1,
          'question': 'Questão ${i + 1}',
          'options': ['A', 'B'],
          'answer': 'A',
          'points': 10
        });
        file.writeAsStringSync(jsonEncode({
          'category': 'test100',
          'questions': questionsList,
        }));

        try {
          final userEmail = 'limite100@test.com';
          // Gera 100 perguntas com sucesso
          for (var i = 0; i < 100; i++) {
            final q = service.generateQuestion(category: 'test100', userEmail: userEmail);
            expect(q.id, isNotNull);
          }

          // A 101ª geração deve estourar o limite de 100
          expect(
            () => service.generateQuestion(category: 'test100', userEmail: userEmail),
            throwsA(isA<NotFoundExcpetion>()),
          );
        } finally {
          // Garante a limpeza do arquivo temporário
          if (file.existsSync()) {
            file.deleteSync();
          }
        }
      });
    });
  });
}

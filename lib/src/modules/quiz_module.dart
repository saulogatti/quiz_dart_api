import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'quiz_module.g.dart';

class QuizModule {
  Router get quizRouter => _$QuizModuleRouter(this);

  @Route.get('/questions/generate')
  Response _generateRandomQuestion(Request request) {
    // Lógica para gerar uma pergunta aleatória
    return Response.ok('Pergunta gerada!');
  }
}

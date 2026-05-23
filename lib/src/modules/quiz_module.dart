import 'package:quiz_api/src/controller/quiz_v2_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'quiz_module.g.dart';

/// Módulo de rotas da API V2, gerado via `shelf_router_generator`.
///
/// Mapeia os endpoints de geração de perguntas, envio de respostas e
/// consulta de resultado, delegando cada chamada ao [QuizV2Controller].
class QuizModule {
  final QuizV2Controller _controller = QuizV2Controller();

  Router get quizRouter => _$QuizModuleRouter(this);

  /// Gera uma pergunta aleatória da categoria informada.
  ///
  /// Query param obrigatório: `category`
  @Route.get('/questions/generate')
  Response generateQuestion(Request request) => _controller.generateQuestion(request);

  /// Verifica a resposta do usuário e retorna o resultado parcial.
  @Route.post('/questions/answer')
  Future<Response> answerQuestion(Request request) => _controller.answerQuestion(request);

  /// Retorna o resultado final acumulado do usuário.
  ///
  /// Query param obrigatório: `userEmail`
  @Route.get('/quiz/result')
  Response getResult(Request request) => _controller.getResult(request);
}

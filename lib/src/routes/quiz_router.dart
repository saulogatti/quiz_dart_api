import 'package:quiz_api/src/modules/quiz_module.dart';
import 'package:quiz_api/src/routes/routes_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'quiz_router.g.dart';

/// Roteador raiz da aplicação.
///
/// Monta a API V1 em `$_basePath/v1` via [RoutesHandler] e a API V2 em
/// `$_basePath/v2` via [QuizModule]. Gerado parcialmente via `shelf_router_generator`.
class QuizRouter {
  static const String _basePath = '/api';

  Handler get router => _$QuizRouterRouter(this).call;

  @Route.mount('$_basePath/v1')
  Router get _quizRouter => RoutesHandler.buildRouters();

  @Route.mount("$_basePath/v2")
  Router get _quizRouterV2 => QuizModule().quizRouter;
}

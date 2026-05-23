import 'package:quiz_api/src/modules/quiz_module.dart';
import 'package:quiz_api/src/routes/routes_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'quiz_router.g.dart';

class QuizRouter {
  static const String _basePath = '/api';

  Handler get router => _$QuizRouterRouter(this).call;

  @Route.mount('$_basePath/v1')
  Router get _quizRouter => RoutesHandler.buildRouters();

  @Route.mount("$_basePath/v2")
  Router get _quizRouterV2 => QuizModule().quizRouter;
}

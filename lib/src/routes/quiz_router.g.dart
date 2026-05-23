// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_router.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$QuizRouterRouter(QuizRouter service) {
  final router = Router();
  router.mount(r'/api/v1', service._quizRouter.call);
  router.mount(r'/api/v2', service._quizRouterV2.call);
  return router;
}

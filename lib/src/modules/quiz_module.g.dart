// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_module.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$QuizModuleRouter(QuizModule service) {
  final router = Router();
  router.add('GET', r'/questions/generate', service.generateQuestion);
  router.add('POST', r'/questions/answer', service.answerQuestion);
  router.add('GET', r'/quiz/result', service.getResult);
  return router;
}

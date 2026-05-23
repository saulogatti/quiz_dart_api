// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_module.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$QuizModuleRouter(QuizModule service) {
  final router = Router();
  router.add('GET', r'/questions/generate', service._generateRandomQuestion);
  return router;
}

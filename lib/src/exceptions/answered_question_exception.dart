import 'custom_exception.dart';

class AnsweredQuestionException extends CustomException implements Exception {
  AnsweredQuestionException({
    super.status = 403,
    super.message = 'Parabéns! Você já respondeu corretamente esta pergunta e não poderá responder novamente',
  });

  @override
  String toString() => message;
}

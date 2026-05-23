import 'custom_exception.dart';

/// Lançada quando o usuário tenta responder uma pergunta que já foi respondida
/// corretamente. Retorna HTTP 403.
class AnsweredQuestionException extends CustomException implements Exception {
  AnsweredQuestionException({
    super.status = 403,
    super.message =
        'Parabéns! Você já respondeu corretamente esta pergunta e não poderá responder novamente',
  });

  @override
  String toString() => message;
}

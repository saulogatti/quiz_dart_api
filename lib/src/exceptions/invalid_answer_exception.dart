import 'custom_exception.dart';

/// Lançada quando a resposta enviada pelo usuário não corresponde à resposta
/// correta da pergunta. Retorna HTTP 400.
class InvalidAnswerException extends CustomException implements Exception {
  InvalidAnswerException({
    super.status = 400,
    super.message = 'A resposta informada está incorreta',
  });

  @override
  String toString() => message;
}

import 'custom_exception.dart';

class InvalidAnswerException extends CustomException implements Exception {
  InvalidAnswerException({
    super.status = 400,
    super.message = 'A resposta informada está incorreta',
  });

  @override
  String toString() => message;
}

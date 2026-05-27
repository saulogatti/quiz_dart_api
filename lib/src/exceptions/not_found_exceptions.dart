import 'custom_exception.dart';

/// Lançada quando um recurso solicitado não é encontrado. Retorna HTTP 404.
///
/// A [message] deve identificar qual recurso não foi localizado
/// (ex.: "Pergunta não encontrada").
class NotFoundExcpetion extends CustomException implements Exception {
  NotFoundExcpetion({super.status = 404, required super.message});

  @override
  String toString() => message;
}

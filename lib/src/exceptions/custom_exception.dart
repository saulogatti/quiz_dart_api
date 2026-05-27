/// Exceção base para erros HTTP da aplicação.
///
/// Todas as exceções customizadas devem estender esta classe e fornecer um
/// [status] HTTP adequado e uma [message] descritiva, que será serializada
/// como resposta JSON ao cliente.
class CustomException implements Exception {
  /// Código de status HTTP associado ao erro.
  final int status;

  /// Mensagem de erro legível retornada ao cliente.
  final String message;

  /// Cria uma [CustomException] com o [status] HTTP e a [message] fornecidos.
  CustomException({required this.status, required this.message});
}

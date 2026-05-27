import 'package:quiz_api/server.dart';

/// Ponto de entrada da aplicação.
///
/// Inicializa o servidor HTTP chamando [startServer], que mantém o processo
/// em execução aguardando requisições na porta 5469.
void main(List<String> args) {
  startServer();
}

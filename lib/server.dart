import 'dart:io';

import 'package:quiz_api/src/routes/quiz_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

/// Cria e retorna o [Handler] do servidor sem iniciar o servidor HTTP.
///
/// Útil para testes que precisam chamar o handler diretamente, sem abrir uma porta.
Handler createHandler() {
  return Pipeline().addHandler(QuizRouter().router);
}

/// Inicia o servidor HTTP usando o pacote `shelf` e define as rotas usando `RoutesHandler`.
void startServer() async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(QuizRouter().router);

  final port = 5469;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

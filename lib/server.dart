import 'dart:io';

import 'package:quiz_api/src/routes/quiz_router.dart';
import 'package:quiz_api/src/static_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

/// Combina o roteador da API com o handler estático: se a API devolver 404,
/// cai para os arquivos em `web/` (que servem a UI).
Handler _composeHandler() {
  final apiHandler = QuizRouter().router;
  final staticHandler = createStaticHandler(root: 'web');

  return (Request request) async {
    final apiResponse = await apiHandler(request);
    if (apiResponse.statusCode == 404 &&
        !request.url.path.startsWith('api/')) {
      return staticHandler(request);
    }
    return apiResponse;
  };
}

/// Cria e retorna o [Handler] do servidor sem iniciar o servidor HTTP.
///
/// Útil para testes que precisam chamar o handler diretamente, sem abrir uma porta.
Handler createHandler() {
  return Pipeline().addHandler(_composeHandler());
}

/// Inicia o servidor HTTP usando o pacote `shelf` e define as rotas usando `RoutesHandler`.
void startServer() async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_composeHandler());

  final port = 5469;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
  print('UI disponível em http://localhost:${server.port}/');
}

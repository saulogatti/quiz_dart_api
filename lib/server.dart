import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'src/routes/routes_handler.dart';

/// Inicia o servidor HTTP usando o pacote `shelf` e define as rotas usando `RoutesHandler`.
void startServer() async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(RoutesHandler.buildRouters().call);

  final port = 5469;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

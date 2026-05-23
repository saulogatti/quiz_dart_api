import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// Handler estático simples para servir arquivos do diretório `web/`.
///
/// Resolve `/` para `web/index.html` e devolve 404 para qualquer outra rota
/// fora do diretório (sem path traversal).
Handler createStaticHandler({String root = 'web'}) {
  final rootDir = Directory(root).absolute;

  return (Request request) async {
    if (request.method != 'GET' && request.method != 'HEAD') {
      return Response.notFound('Not found');
    }

    var path = request.url.path;
    if (path.isEmpty || path == '/') path = 'index.html';

    final requested = File('${rootDir.path}${Platform.pathSeparator}'
        '${path.replaceAll('/', Platform.pathSeparator)}');
    final resolved = requested.absolute.path;

    if (!resolved.startsWith(rootDir.path)) {
      return Response.forbidden('Forbidden');
    }
    if (!await requested.exists()) {
      return Response.notFound('Not found');
    }

    final bytes = await requested.readAsBytes();
    return Response.ok(
      bytes,
      headers: {
        HttpHeaders.contentTypeHeader: _contentType(path),
        HttpHeaders.cacheControlHeader: 'no-cache',
      },
    );
  };
}

String _contentType(String path) {
  final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
  switch (ext) {
    case 'html': return 'text/html; charset=utf-8';
    case 'css':  return 'text/css; charset=utf-8';
    case 'js':   return 'application/javascript; charset=utf-8';
    case 'json': return 'application/json; charset=utf-8';
    case 'svg':  return 'image/svg+xml';
    case 'png':  return 'image/png';
    case 'jpg':
    case 'jpeg': return 'image/jpeg';
    case 'ico':  return 'image/x-icon';
    default:     return 'application/octet-stream';
  }
}

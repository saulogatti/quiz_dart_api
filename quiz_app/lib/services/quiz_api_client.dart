import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/answer_result.dart';
import '../models/quiz_result.dart';

/// Cliente HTTP para consumo dos endpoints da API V2 do Quiz.
///
/// Realiza requisições para geração de perguntas, envio de respostas e consulta
/// dos resultados finais consolidados por jogador.
class QuizApiClient {
  /// Endereço base da API (ex: `http://localhost:5469/api/v2`).
  String baseUrl;

  QuizApiClient({required this.baseUrl});

  /// Gera uma pergunta aleatória da categoria informada.
  Future<Question> generateQuestion({
    required String category,
    required String userEmail,
  }) async {
    final uri = Uri.parse('$baseUrl/questions/generate').replace(
      queryParameters: {
        'category': category,
        'userEmail': userEmail,
      },
    );

    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Question.fromJson(body);
      } else if (response.statusCode == 404) {
        // Categoria esgotada ou limite de 100 atingido
        throw CategoryExhaustedException(body['message'] ?? 'Sem mais perguntas nesta categoria.');
      } else {
        throw ApiException(body['message'] ?? 'Erro no servidor: ${response.statusCode}');
      }
    } on http.ClientException {
      throw NetworkException('Não foi possível conectar ao servidor. Verifique o endereço e se a API está rodando.');
    } catch (e) {
      if (e is CategoryExhaustedException || e is NetworkException) {
        rethrow;
      }
      throw ApiException('Falha ao processar requisição: $e');
    }
  }

  /// Envia a resposta do usuário e retorna o veredito parcial.
  Future<AnswerResult> answerQuestion({
    required int id,
    required String category,
    required String userEmail,
    required String answerResp,
    required bool revealResult,
  }) async {
    final uri = Uri.parse('$baseUrl/questions/answer');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'category': category,
          'userEmail': userEmail,
          'answerResp': answerResp,
          'revealResult': revealResult,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AnswerResult.fromJson(body);
      } else {
        throw ApiException(body['message'] ?? 'Erro ao enviar resposta: ${response.statusCode}');
      }
    } on http.ClientException {
      throw NetworkException('Não foi possível conectar ao servidor. Verifique a conexão.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw ApiException('Falha ao processar resposta: $e');
    }
  }

  /// Obtém o resultado final acumulado do usuário.
  Future<QuizResult> getFinalResult({required String userEmail}) async {
    final uri = Uri.parse('$baseUrl/quiz/result').replace(
      queryParameters: {'userEmail': userEmail},
    );

    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return QuizResult.fromJson(body);
      } else {
        throw ApiException(body['message'] ?? 'Erro ao obter resultado final.');
      }
    } on http.ClientException {
      throw NetworkException('Não foi possível conectar ao servidor.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw ApiException('Falha ao carregar resultado: $e');
    }
  }
}

/// Exceção lançada quando a API retorna um erro de processamento de negócio.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Exceção lançada quando a categoria solicitada não possui mais perguntas disponíveis
/// ou quando o jogador atinge o limite de 100 perguntas da sessão.
class CategoryExhaustedException implements Exception {
  final String message;
  CategoryExhaustedException(this.message);
  @override
  String toString() => message;
}

/// Exceção lançada quando não é possível estabelecer conexão com o servidor.
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

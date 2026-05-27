import 'dart:convert';

/// DTO de resposta para erros HTTP.
///
/// Retornado como JSON com o campo `message` descrevendo o erro ocorrido.
class ErrorDto {
  final String? message;

  ErrorDto({required this.message});

  factory ErrorDto.fromJson(String source) =>
      ErrorDto.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ErrorDto.fromMap(Map<String, dynamic> map) {
    return ErrorDto(message: map['message'] != null ? map['message'] as String : null);
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'message': message};
  }
}

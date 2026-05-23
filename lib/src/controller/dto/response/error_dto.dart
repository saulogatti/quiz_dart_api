// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorDto {
  final String? message;

  ErrorDto({required this.message});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ErrorDto.fromMap(Map<String, dynamic> map) {
    return ErrorDto(
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorDto.fromJson(String source) => ErrorDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

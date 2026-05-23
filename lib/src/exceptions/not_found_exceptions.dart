import 'custom_exception.dart';

class NotFoundExcpetion extends CustomException implements Exception {
  NotFoundExcpetion({
    super.status = 404,
    required super.message,
  });

  @override
  String toString() => message;
}

/// 
class CustomException implements Exception {
  final int status;
  final String message;

  CustomException({required this.status, required this.message});
}

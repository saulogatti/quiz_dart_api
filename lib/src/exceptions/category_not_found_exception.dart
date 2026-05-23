import 'custom_exception.dart';

/// Exceção lançada quando uma categoria de quiz não é encontrada nos dados V2.
class CategoryNotFoundException extends CustomException {
  CategoryNotFoundException({required String category})
      : super(status: 404, message: 'Categoria "$category" não encontrada.');
}

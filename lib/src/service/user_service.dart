import '../data/users.mock.dart';
import '../exceptions/not_found_exceptions.dart';
import '../model/user_model.dart';

/// Serviço de acesso e atualização de usuários armazenados no mock em memória.
class UserService {
  /// Busca e retorna o [UserModel] associado ao [email] informado.
  ///
  /// Lança [NotFoundExcpetion] caso nenhum usuário seja encontrado com o e-mail.
  UserModel findUserByEmail(String email) {
    Map<String, dynamic>? userMap = users
        .where((element) => element['email'] == email)
        .toList()
        .firstOrNull;
    if (userMap == null || userMap.isEmpty) {
      throw NotFoundExcpetion(
        message:
            'Usuário com e-mail $email não foi encontrado. Certifique-se que o email informado esteja correto.',
      );
    }

    UserModel userModel = UserModel.fromJson(userMap);
    return userModel;
  }

  /// Substitui o registro do usuário na lista mock pelo [updateUser] fornecido,
  /// identificando-o pelo campo `email`.
  void updateUser(Map<String, dynamic> updateUser) {
    for (var userMap in users) {
      if (userMap['email'] == updateUser['email']) {
        users.remove(userMap);
        users.add(updateUser);
      }
    }
  }
}

import '../data/users.mock.dart';
import '../exceptions/not_found_exceptions.dart';
import '../model/user_model.dart';

class UserService {
  UserModel findUserByEmail(String email) {
    Map<String, dynamic>? userMap = users.where((element) => element['email'] == email).toList().firstOrNull;
    if (userMap == null || userMap.isEmpty) {
      throw NotFoundExcpetion(
          message:
              'Usuário com e-mail $email não foi encontrado. Certifique-se que o email informado esteja correto.');
    }

    UserModel userModel = UserModel.fromMap(userMap);
    return userModel;
  }

  void updateUser(Map<String, dynamic> updateUser) {
    for (var userMap in users) {
      if (userMap['email'] == updateUser['email']) {
        users.remove(userMap);
        users.add(updateUser);
      }
    }
  }
}

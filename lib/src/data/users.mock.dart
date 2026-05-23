import '../model/user_model.dart';

final List<Map<String, dynamic>> users = [
  UserModel(email: 'user1@gmail.com', answeredQuestions: []).toJson(),
  UserModel(email: 'user2@gmail.com', answeredQuestions: []).toJson(),
];

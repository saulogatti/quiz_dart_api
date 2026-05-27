import '../model/user_model.dart';

/// Lista de usuários mock da API V1, mantida em memória.
///
/// Novos usuários não podem ser cadastrados via API — apenas os e-mails
/// pré-cadastrados aqui são aceitos.
final List<Map<String, dynamic>> users = [
  UserModel(email: 'user1@gmail.com', answeredQuestions: []).toJson(),
  UserModel(email: 'user2@gmail.com', answeredQuestions: []).toJson(),
];

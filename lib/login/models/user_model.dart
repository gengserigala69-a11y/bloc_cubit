class UserModel {
  final int id;
  final String documentId;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      documentId: map['documentId'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({
    int? id,
    String? documentId,
    String? username,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      documentId:
          documentId ?? this.documentId,
      username:
          username ?? this.username,
      email: email ?? this.email,
    );
  }
}
// Root model: Registermodel

class Registermodel {
  final bool success;
  final String message;
  final RegistermodelData? data;

  Registermodel({
    required this.success,
    required this.message,
    this.data,
  });

  Registermodel copyWith({
    bool? success,
    String? message,
    RegistermodelData? data,
  }) {
    return Registermodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory Registermodel.fromMap(Map<String, dynamic> json) {
    return Registermodel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RegistermodelData.fromMap(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }
}

class RegistermodelData {
  final String jwt;
  final RegistermodeldataUser? user;

  RegistermodelData({
    required this.jwt,
    this.user,
  });

  RegistermodelData copyWith({
    String? jwt,
    RegistermodeldataUser? user,
  }) {
    return RegistermodelData(
      jwt: jwt ?? this.jwt,
      user: user ?? this.user,
    );
  }

  factory RegistermodelData.fromMap(Map<String, dynamic> json) {
    return RegistermodelData(
      jwt: json['jwt'] ?? '',
      user: json['user'] != null
          ? RegistermodeldataUser.fromMap(
              Map<String, dynamic>.from(json['user']),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jwt': jwt,
      'user': user?.toMap(),
    };
  }
}

class RegistermodeldataUser {
  final int id;
  final String username;
  final String email;
  final String provider;
  final int confirmed;
  final int blocked;
  final DateTime? createdat;
  final DateTime? updatedat;
  final DateTime? publishedat;

  RegistermodeldataUser({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    this.createdat,
    this.updatedat,
    this.publishedat,
  });

  RegistermodeldataUser copyWith({
    int? id,
    String? username,
    String? email,
    String? provider,
    int? confirmed,
    int? blocked,
    DateTime? createdat,
    DateTime? updatedat,
    DateTime? publishedat,
  }) {
    return RegistermodeldataUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      publishedat: publishedat ?? this.publishedat,
    );
  }

  factory RegistermodeldataUser.fromMap(Map<String, dynamic> json) {
    return RegistermodeldataUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      provider: json['provider'] ?? '',
      confirmed: json['confirmed'] ?? 0,
      blocked: json['blocked'] ?? 0,
      createdat: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedat: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      publishedat: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'provider': provider,
      'confirmed': confirmed,
      'blocked': blocked,
      'createdAt': createdat?.toIso8601String(),
      'updatedAt': updatedat?.toIso8601String(),
      'publishedAt': publishedat?.toIso8601String(),
    };
  }
}
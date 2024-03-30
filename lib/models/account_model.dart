class AccountModel {
  final String accountId;
  final String? email;
  final String? provider;
  final String? socialId;
  final Role role;
  final DateTime createdAt;

  AccountModel({
    required this.accountId,
    required this.role,
    required this.createdAt,
    this.email,
    this.provider,
    this.socialId,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountId: json['account_id'],
      email: json['email'],
      provider: json['provider'],
      socialId: json['social_id'],
      role: Role.fromJson(json['role']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'email': email,
      'provider': provider,
      'social_id': socialId,
      'role': role.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Role {
  final int roleId;
  final String name;

  Role({
    required this.roleId,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['role_id'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'name': name,
    };
  }
}

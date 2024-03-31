import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/role_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  @JsonKey(name: 'account_id')
  final String accountId;
  final String? email;
  final String? provider;
  @JsonKey(name: 'social_id')
  final String? socialId;
  final RoleModel role;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  AccountModel({
    required this.accountId,
    required this.role,
    required this.createdAt,
    this.email,
    this.provider,
    this.socialId,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}

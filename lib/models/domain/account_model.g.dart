// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      accountId: json['account_id'] as String,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] as String?,
      provider: json['provider'] as String?,
      socialId: json['social_id'] as String?,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'email': instance.email,
      'provider': instance.provider,
      'social_id': instance.socialId,
      'role': instance.role,
      'created_at': instance.createdAt.toIso8601String(),
    };

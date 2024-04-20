// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_timer_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupTimerMemberModel _$GroupTimerMemberModelFromJson(
        Map<String, dynamic> json) =>
    GroupTimerMemberModel(
      memberId: json['member_id'] as String,
      nickname: json['nickname'] as String,
      imageUrl: json['image_url'] as String,
      joinedAtUTC: DateTime.parse(json['joinedAtUTC'] as String),
    );

Map<String, dynamic> _$GroupTimerMemberModelToJson(
        GroupTimerMemberModel instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'nickname': instance.nickname,
      'image_url': instance.imageUrl,
      'joinedAtUTC': instance.joinedAtUTC.toIso8601String(),
    };

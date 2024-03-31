// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      memberId: json['member_id'] as String,
      statusMessage: json['status_message'] as String,
      imageUrl: json['image_url'] as String,
      nickname: json['nickname'] as String,
      point: json['point'] as int,
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'status_message': instance.statusMessage,
      'image_url': instance.imageUrl,
      'nickname': instance.nickname,
      'point': instance.point,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_points_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardPointsResponse _$RewardPointsResponseFromJson(
        Map<String, dynamic> json) =>
    RewardPointsResponse(
      rewardPoint: json['reward_point'] as int,
      totalPoint: json['total_point'] as int,
    );

Map<String, dynamic> _$RewardPointsResponseToJson(
        RewardPointsResponse instance) =>
    <String, dynamic>{
      'reward_point': instance.rewardPoint,
      'total_point': instance.totalPoint,
    };

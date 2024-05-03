import 'package:json_annotation/json_annotation.dart';

part 'reward_points_response.g.dart';

@JsonSerializable()
class RewardPointsResponse {
  @JsonKey(name: 'reward_point')
  final int rewardPoint;
  @JsonKey(name: 'total_point')
  final int totalPoint;

  RewardPointsResponse({
    required this.rewardPoint,
    required this.totalPoint,
  });

  factory RewardPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$RewardPointsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardPointsResponseToJson(this);
}

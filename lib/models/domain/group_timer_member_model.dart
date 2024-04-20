import 'package:json_annotation/json_annotation.dart';

part 'group_timer_member_model.g.dart';

@JsonSerializable()
class GroupTimerMemberModel {
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'nickname')
  final String nickname;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'joinedAtUTC')
  final DateTime joinedAtUTC;

  GroupTimerMemberModel({
    required this.memberId,
    required this.nickname,
    required this.imageUrl,
    required this.joinedAtUTC,
  });

  factory GroupTimerMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupTimerMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTimerMemberModelToJson(this);
}

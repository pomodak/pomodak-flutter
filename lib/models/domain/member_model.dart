import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'status_message')
  final String statusMessage;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String nickname;
  final int point;

  MemberModel({
    required this.memberId,
    required this.statusMessage,
    required this.imageUrl,
    required this.nickname,
    required this.point,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}

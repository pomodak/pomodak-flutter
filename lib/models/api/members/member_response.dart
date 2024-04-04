import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/member_model.dart';

part 'member_response.g.dart';

@JsonSerializable()
class MemberResponse {
  final MemberModel member;

  MemberResponse({
    required this.member,
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberResponseToJson(this);
}

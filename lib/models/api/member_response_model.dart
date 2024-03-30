import 'package:pomodak/models/member_model.dart';

class MemberResponseData {
  final MemberModel member;

  MemberResponseData({
    required this.member,
  });

  factory MemberResponseData.fromJson(Map<String, dynamic> json) {
    return MemberResponseData(
      member: MemberModel.fromJson(json['member']),
    );
  }
}

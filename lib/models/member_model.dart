class MemberModel {
  final String memberId;
  final String statusMessage;
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

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberId: json['member_id'],
      statusMessage: json['status_message'],
      imageUrl: json['image_url'],
      nickname: json['nickname'],
      point: json['point'],
    );
  }
}

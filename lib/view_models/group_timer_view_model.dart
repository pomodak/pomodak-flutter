import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class GroupTimerViewModel with ChangeNotifier {
  final String _nestSocketEndpoint = dotenv.env['NEST_SOCKET_ENDPOINT']!;
  late socket_io.Socket socket;
  List<MemberInfo> members = [];

  void connectAndListen({required String accessToken}) {
    socket = socket_io.io('$_nestSocketEndpoint/study-group', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': accessToken}
    });

    socket.connect();

    socket.onConnect((_) {
      if (kDebugMode) {
        print('Connected to socket server');
      }
      socket.emit('joinGroup', {'jwtToken': accessToken});
    });

    socket.on('error', (data) {
      MessageUtil.showErrorToast(data);
    });

    socket.on('explodeGroup', (_) {
      MessageUtil.showErrorToast("문제가 생겨서 방이 폭파되었습니다 ㅜㅜ. 시간은 계속 기록됩니다!");
      socket.disconnect();
    });

    socket.on('groupInfo', (data) {
      members = List<MemberInfo>.from(
          data['members'].map((x) => MemberInfo.fromMap(x)));

      if (kDebugMode) {
        print("groupInfo: ${members.length} members");
      }
      notifyListeners();
      socket.off('groupInfo');
    });

    socket.on('newMember', (data) {
      var newMember = MemberInfo.fromMap(data);
      if (kDebugMode) {
        print("newMember: ${newMember.memberId}");
      }
      members = [
        ...members.where((m) => m.memberId != newMember.memberId),
        newMember,
      ];
      notifyListeners();
    });

    socket.on('memberLeft', (data) {
      if (kDebugMode) {
        print("memberLeft: ${data['memberId']}");
      }
      members = members.where((m) => m.memberId != data['memberId']).toList();
      notifyListeners();
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Disconnected from socket server');
      }
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}

class MemberInfo {
  final String memberId;
  final String nickname;
  final String imageUrl;
  final String joinedAtUTC;

  MemberInfo({
    required this.memberId,
    required this.nickname,
    required this.imageUrl,
    required this.joinedAtUTC,
  });

  factory MemberInfo.fromMap(Map<String, dynamic> data) {
    return MemberInfo(
      memberId: data['member_id'],
      nickname: data['nickname'],
      imageUrl: data['image_url'],
      joinedAtUTC: data['joinedAtUTC'],
    );
  }
}

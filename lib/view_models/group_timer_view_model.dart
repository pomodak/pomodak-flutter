import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/models/domain/group_timer_member_model.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class GroupTimerViewModel with ChangeNotifier {
  // State
  final String _nestSocketEndpoint = dotenv.env['NEST_SOCKET_ENDPOINT']!;
  late socket_io.Socket _socket;
  List<GroupTimerMemberModel> _members = [];
  DateTime? _connectedAt;

  // Getter
  List<GroupTimerMemberModel> get members => _members;
  DateTime? get connectedAt => _connectedAt;

  void connectAndListen({required String accessToken}) {
    _socket =
        socket_io.io('$_nestSocketEndpoint/study-group', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': accessToken}
    });
    _socket.connect();

    _socket.onConnect((_) {
      if (kDebugMode) {
        print('Connected to socket server');
      }
      _socket.emit('joinGroup', {'jwtToken': accessToken});
    });

    _socket.on('error', (data) {
      MessageUtil.showErrorToast(data);
    });

    _socket.on('explodeGroup', (_) {
      MessageUtil.showErrorToast("문제가 생겨서 방이 폭파되었습니다 ㅜㅜ. 시간은 계속 기록됩니다!");
      _socket.disconnect();
    });

    _socket.on('groupInfo', (data) {
      _members = List<GroupTimerMemberModel>.from(
          data['members'].map((x) => GroupTimerMemberModel.fromJson(x)));

      // 내 연결시간 저장
      String? myId = getIt<MemberViewModel>().member?.memberId;
      _connectedAt = _members.firstWhere((m) => m.memberId == myId).joinedAtUTC;
      notifyListeners();
      if (kDebugMode) {
        print("groupInfo: ${_members.length} members");
      }
      notifyListeners();
      _socket.off('groupInfo');
    });

    _socket.on('newMember', (data) {
      var newMember = GroupTimerMemberModel.fromJson(data);
      if (kDebugMode) {
        print("newMember: ${newMember.memberId}");
      }
      _members = [
        ..._members.where((m) => m.memberId != newMember.memberId),
        newMember,
      ];
      notifyListeners();
    });

    _socket.on('memberLeft', (data) {
      if (kDebugMode) {
        print("memberLeft: ${data['memberId']}");
      }
      _members = _members.where((m) => m.memberId != data['memberId']).toList();
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Disconnected from socket server');
      }
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}

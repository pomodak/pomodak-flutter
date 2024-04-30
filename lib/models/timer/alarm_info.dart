enum AlarmType { work, rest, finish, normal, giveup }

class AlarmInfo {
  final AlarmType alarmType;
  final int time;
  final bool isEndedInBackground;

  AlarmInfo({
    required this.alarmType,
    required this.time,
    required this.isEndedInBackground,
  });
}

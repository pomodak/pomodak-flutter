enum AlarmType { work, rest, finish, normal, giveup }

class AlarmInfo {
  final AlarmType alarmType;
  final int time;
  final bool isEndedInBackground;
  int? earnedPoints;

  AlarmInfo({
    required this.alarmType,
    required this.time,
    required this.isEndedInBackground,
    this.earnedPoints,
  });
}

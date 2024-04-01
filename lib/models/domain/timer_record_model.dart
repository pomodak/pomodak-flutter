import 'package:hive/hive.dart';

part 'timer_record_model.g.dart';

@HiveType(typeId: 0)
class TimerRecordModel {
  @HiveField(0)
  final String memberId;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int totalSeconds;

  @HiveField(3)
  final int totalCompleted;

  @HiveField(4)
  final Map<String, int> details; // 카테고리별 totalSeconds

  TimerRecordModel({
    required this.memberId,
    required this.date,
    required this.totalSeconds,
    required this.totalCompleted,
    required this.details,
  });
}

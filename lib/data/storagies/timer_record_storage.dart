import 'package:hive/hive.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:intl/intl.dart';

class TimerRecordStorage {
  final Box<TimerRecordModel> _box = Hive.box<TimerRecordModel>('timerRecords');

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String _generateKey(String memberId, DateTime dateTime) {
    return '${memberId}_${_formatDate(dateTime)}';
  }

  Future<void> saveOrUpdateRecord({
    required String memberId,
    required DateTime date,
    required int seconds,
    required bool isCompleted,
    String category = 'default',
  }) async {
    final String recordKey = _generateKey(memberId, date);

    final TimerRecordModel? existingRecord = _box.get(recordKey);

    if (existingRecord != null) {
      final updatedDetails = Map<String, int>.from(existingRecord.details);
      updatedDetails.update(
        category,
        (value) => value + seconds,
        ifAbsent: () => seconds,
      );

      final updatedRecord = TimerRecordModel(
        memberId: memberId,
        date: date,
        totalSeconds: existingRecord.totalSeconds + seconds,
        totalCompleted: isCompleted
            ? existingRecord.totalCompleted + 1
            : existingRecord.totalCompleted,
        details: updatedDetails,
      );

      await _box.put(recordKey, updatedRecord);
    } else {
      final newRecord = TimerRecordModel(
        memberId: memberId,
        date: date,
        totalSeconds: seconds,
        totalCompleted: isCompleted ? 1 : 0,
        details: {category: seconds},
      );

      await _box.put(recordKey, newRecord);
    }
  }

  List<TimerRecordModel> getTimerRecordModelsByMemberId(String memberId) {
    return _box.values.where((record) => record.memberId == memberId).toList();
  }

  TimerRecordModel? getTimerRecordByMemberIdAndDate(
      String memberId, DateTime date) {
    final String recordKey = _generateKey(memberId, date);
    return _box.get(recordKey);
  }
}

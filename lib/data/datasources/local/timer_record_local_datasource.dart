import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';

abstract class TimerRecordLocalDataSource {
  Future<TimerRecordModel> saveOrUpdateRecord({
    required String memberId,
    required DateTime date,
    required int seconds,
    required bool isCompleted,
    String category = 'default',
  });

  List<TimerRecordModel> getRecordsByMemberId(String memberId);
  TimerRecordModel? getRecordByMemberIdAndDate(String memberId, DateTime date);
}

class TimerRecordLocalDataSourceImpl implements TimerRecordLocalDataSource {
  final Box<TimerRecordModel> _box;

  TimerRecordLocalDataSourceImpl(this._box);

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String _generateKey(String memberId, DateTime dateTime) {
    return '${memberId}_${_formatDate(dateTime)}';
  }

  @override
  Future<TimerRecordModel> saveOrUpdateRecord({
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
      return updatedRecord;
    } else {
      final newRecord = TimerRecordModel(
        memberId: memberId,
        date: date,
        totalSeconds: seconds,
        totalCompleted: isCompleted ? 1 : 0,
        details: {category: seconds},
      );

      await _box.put(recordKey, newRecord);
      return newRecord;
    }
  }

  @override
  List<TimerRecordModel> getRecordsByMemberId(String memberId) {
    return _box.values.where((record) => record.memberId == memberId).toList();
  }

  @override
  TimerRecordModel? getRecordByMemberIdAndDate(String memberId, DateTime date) {
    final String recordKey = _generateKey(memberId, date);
    return _box.get(recordKey);
  }
}

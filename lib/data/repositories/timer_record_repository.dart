import 'package:pomodak/data/datasources/local/timer_record_local_datasource.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';

class TimerRecordRepository {
  final TimerRecordLocalDataSource localDataSource;

  TimerRecordRepository({required this.localDataSource});

  Future<TimerRecordModel> saveOrUpdateRecord({
    required String memberId,
    required DateTime date,
    required int seconds,
    required bool isCompleted,
    String category = 'default',
  }) async {
    return await localDataSource.saveOrUpdateRecord(
      memberId: memberId,
      date: date,
      seconds: seconds,
      isCompleted: isCompleted,
      category: category,
    );
  }

  List<TimerRecordModel> getRecordsByMemberId(String memberId) {
    return localDataSource.getRecordsByMemberId(memberId);
  }

  TimerRecordModel? getRecordByMemberIdAndDate(String memberId, DateTime date) {
    return localDataSource.getRecordByMemberIdAndDate(memberId, date);
  }
}

import 'package:flutter/material.dart';
import 'package:pomodak/data/storagies/timer_record_storage.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class TimerRecordViewModel extends ChangeNotifier {
  final TimerRecordStorage storage;
  late final MemberViewModel memberViewModel;
  // 캐시로 사용될 타이머 기록 리스트
  List<TimerRecordModel> records = [];

  Map<DateTime, int> get recordDatasets => {
        for (var record in records)
          DateTime(record.date.year, record.date.month, record.date.day):
              record.totalSeconds
      };

  TimerRecordViewModel({
    required this.storage,
    required this.memberViewModel,
  }) {
    memberViewModel.addListener(_updateOnMemberChange);
    _initRecords();
  }

  // member 변화 감지
  void _updateOnMemberChange() {
    if (memberViewModel.member != null) {
      _initRecords();
    }
  }

  // 초기데이터 로드
  Future<void> _initRecords() async {
    var memberId = memberViewModel.member?.memberId ?? '';
    if (memberId.isNotEmpty) {
      records = storage.getTimerRecordModelsByMemberId(memberId);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    memberViewModel.removeListener(_updateOnMemberChange);
    super.dispose();
  }

  Future<void> saveRecord({
    required DateTime date,
    required int seconds,
    required bool isCompleted,
    String category = 'default',
  }) async {
    String? memberId = memberViewModel.member?.memberId;
    if (memberId == null) return;

    final newOrUpdatedRecord = await storage.saveOrUpdateRecord(
      memberId: memberId,
      date: DateTime(date.year, date.month, date.day),
      seconds: seconds,
      isCompleted: isCompleted,
      category: category,
    );

    // 새로 저장되거나 업데이트된 기록을 캐시에 반영
    _updateCacheWithRecord(newOrUpdatedRecord);
  }

  // 캐시에 새로운 기록을 추가하거나 기존 기록을 업데이트하는 메소드
  void _updateCacheWithRecord(TimerRecordModel record) {
    final index = records.indexWhere((r) => r.date == record.date);
    if (index != -1) {
      // 기존 기록 업데이트
      records[index] = record;
    } else {
      // 새 기록 추가
      records.add(record);
    }
    notifyListeners();
  }

  MonthlyStatistics getMonthlyStatistics(int year, int month) {
    DateTime startOfMonth = DateTime(year, month);
    DateTime endOfMonth =
        DateTime(year, month + 1).subtract(const Duration(days: 1));

    int totalSeconds = 0;
    int totalCompleted = 0;
    Map<String, int> categoryDetails = {};

    for (var record in records) {
      if (record.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          record.date.isBefore(endOfMonth.add(const Duration(days: 1)))) {
        totalSeconds += record.totalSeconds;
        totalCompleted += record.totalCompleted;

        // 카테고리별 집중 시간 계산
        record.details.forEach((category, seconds) {
          if (categoryDetails.containsKey(category)) {
            categoryDetails[category] = categoryDetails[category]! + seconds;
          } else {
            categoryDetails[category] = seconds;
          }
        });
      }
    }

    return MonthlyStatistics(
      totalSeconds: totalSeconds,
      totalCompleted: totalCompleted,
      categoryDetails: categoryDetails,
    );
  }

  TimerRecordModel? getTimerRecordByDate(int year, int month, int day) {
    return storage.getTimerRecordByMemberIdAndDate(
      memberViewModel.member?.memberId ?? "",
      DateTime(year, month, day),
    );
  }
}

class MonthlyStatistics {
  final int totalSeconds;
  final int totalCompleted;
  final Map<String, int> categoryDetails; // 카테고리별 집중 시간

  MonthlyStatistics({
    required this.totalSeconds,
    required this.totalCompleted,
    required this.categoryDetails,
  });
}

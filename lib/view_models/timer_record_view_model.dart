import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/timer_record_repository.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';

class TimerRecordViewModel extends ChangeNotifier {
  final TimerRecordRepository repository;
  // 캐시로 사용될 타이머 기록 리스트
  List<TimerRecordModel> records = [];

  Map<DateTime, int> get recordDatasets => {
        for (var record in records)
          DateTime(record.date.year, record.date.month, record.date.day):
              record.totalSeconds
      };

  TimerRecordViewModel({
    required this.repository,
  });

  // 초기데이터 로드
  void initRecords() {
    var memberId = _getMemberId();
    if (memberId.isNotEmpty) {
      records = repository.getRecordsByMemberId(memberId);
      notifyListeners();
    }
  }

  void clearRecords() {
    records.clear();
    notifyListeners();
  }

  Future<void> saveRecord({
    required DateTime date,
    required int seconds,
    required bool isCompleted,
    String category = 'default',
  }) async {
    String? memberId = _getMemberId();

    if (memberId.isEmpty) {
      MessageUtil.showErrorToast("로그인이 필요합니다.");
      return;
    }

    final newOrUpdatedRecord = await repository.saveOrUpdateRecord(
      memberId: memberId,
      date: DateTime(date.year, date.month, date.day),
      seconds: seconds,
      isCompleted: isCompleted,
      category: category,
    );
    getIt<TransactionViewModel>().applyTimeToItemInventory(seconds);

    // 새로 저장되거나 업데이트된 기록을 캐시에 반영
    updateCacheWithRecord(newOrUpdatedRecord);
  }

  // 캐시에 새로운 기록을 추가하거나 기존 기록을 업데이트하는 메소드
  void updateCacheWithRecord(TimerRecordModel record) {
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
    String memberId = _getMemberId();
    if (memberId.isEmpty) {
      MessageUtil.showErrorToast("로그인이 필요합니다.");
      return null;
    }
    return repository.getRecordByMemberIdAndDate(
      getIt<MemberViewModel>().member?.memberId ?? "",
      DateTime(year, month, day),
    );
  }

  String _getMemberId() {
    return getIt<MemberViewModel>().member?.memberId ?? "";
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

import 'package:flutter/material.dart';
import 'package:pomodak/data/storagies/timer_record_storage.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class TimerRecordViewModel extends ChangeNotifier {
  final TimerRecordStorage storage;
  late final MemberViewModel memberViewModel;
  // 캐시로 사용될 타이머 기록 리스트
  List<TimerRecordModel> records = [];

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

    print(newOrUpdatedRecord.date);
    print(newOrUpdatedRecord.totalCompleted);
    print(newOrUpdatedRecord.totalSeconds);

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
}

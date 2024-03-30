import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/repositories/member_repository.dart';

class MemberViewModel with ChangeNotifier {
  final _myRepo = MemberRepository();

  MemberModel? _member;

  MemberModel? get member => _member;

  Future<MemberModel?> loadMember() async {
    _member = await _myRepo.fetchMemberData();
    notifyListeners();
    return _member;
  }

  Future<void> remove() async {
    return _myRepo.clearMemberData();
  }

  Future<void> onAppStart() async {
    await loadMember();
    notifyListeners();
  }
}

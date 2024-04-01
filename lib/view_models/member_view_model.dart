import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/data/repositories/member_repository.dart';

class MemberViewModel with ChangeNotifier {
  late final MemberRepository repository;
  MemberModel? _member;

  MemberModel? get member => _member;

  MemberViewModel({required this.repository});

  Future<MemberModel?> loadMember() async {
    _member = await repository.fetchMemberData();
    notifyListeners();
    return _member;
  }

  Future<void> remove() async {
    return repository.clearMemberData();
  }

  Future<void> onAppStart() async {
    await loadMember();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/domain/palette_model.dart';

class MemberViewModel with ChangeNotifier {
  late final MemberRepository repository;
  MemberModel? _member;
  PaletteModel? _palette;

  MemberModel? get member => _member;
  PaletteModel? get palette => _palette;

  MemberViewModel({required this.repository});

  Future<MemberModel?> loadMember() async {
    _member = await repository.fetchMemberData();
    notifyListeners();
    return _member;
  }

  Future<PaletteModel?> loadPalette() async {
    if (member != null) {
      _palette =
          await repository.fetchMemberPalette(member?.memberId as String);
    }
    notifyListeners();
    return _palette;
  }

  Future<void> remove() async {
    return repository.clearMemberData();
  }

  Future<void> login() async {
    await loadMember();
    if (_member != null) {
      await loadPalette();
    }
    notifyListeners();
  }

  Future<void> onAppStart() async {
    await login();
  }
}

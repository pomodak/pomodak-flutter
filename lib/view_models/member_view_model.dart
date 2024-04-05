import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/domain/palette_model.dart';

class MemberViewModel with ChangeNotifier {
  late final MemberRepository repository;
  MemberModel? _member;
  PaletteModel? _palette;
  List<ItemInventoryModel> _foodInventory = [];
  List<ItemInventoryModel> _consumableInventory = [];
  List<CharacterInventoryModel> _characterInventory = [];

  MemberModel? get member => _member;
  PaletteModel? get palette => _palette;
  List<ItemInventoryModel> get foodInventory => _foodInventory;
  List<ItemInventoryModel> get consumableInventory => _consumableInventory;
  List<CharacterInventoryModel> get characterInventory => _characterInventory;

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

  Future<void> loadFoodInventory() async {
    if (member != null) {
      _foodInventory = await repository.fetchMemberItemInventory(
          member?.memberId as String, ItemType.food);
    }
    notifyListeners();
  }

  Future<void> loadConsumableInventory() async {
    if (member != null) {
      _consumableInventory = await repository.fetchMemberItemInventory(
          member?.memberId as String, ItemType.consumable);
    }
    notifyListeners();
  }

  Future<void> loadCharacters() async {
    if (member != null) {
      _characterInventory = await repository
          .fetchMemberCharacterInventory(member?.memberId as String);
    }
    notifyListeners();
  }

  Future<void> remove() async {
    return repository.clearMemberData();
  }

  // 로그인 후 초기데이터 조회 후 캐싱
  // 이후 데이터 변경작업 발생 시 개별 load 함수 호출로 캐시 업데이트
  Future<void> login() async {
    await loadMember();
    if (_member != null) {
      loadPalette();
      loadFoodInventory();
      loadConsumableInventory();
      loadCharacters();
    }
    notifyListeners();
  }

  Future<void> onAppStart() async {
    await login();
  }
}

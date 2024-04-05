import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/utils/message_util.dart';

class MemberViewModel with ChangeNotifier {
  // DI
  late final MemberRepository repository;

  // Data
  MemberModel? _member;
  PaletteModel? _palette;
  List<ItemInventoryModel> _foodInventory = [];
  List<ItemInventoryModel> _consumableInventory = [];
  List<CharacterInventoryModel> _characterInventory = [];

  // 로딩 상태
  bool _isLoadingMember = false;
  bool _isLoadingPalette = false;
  bool _isLoadingFoodInventory = false;
  bool _isLoadingConsumableInventory = false;
  bool _isLoadingCharacterInventory = false;

  // 에러 메시지
  String? _memberError;
  String? _paletteError;
  String? _foodInventoryError;
  String? _consumableInventoryError;
  String? _characterInventoryError;

  MemberModel? get member => _member;
  PaletteModel? get palette => _palette;
  List<ItemInventoryModel> get foodInventory => _foodInventory;
  List<ItemInventoryModel> get consumableInventory => _consumableInventory;
  List<CharacterInventoryModel> get characterInventory => _characterInventory;

  bool get isLoadingMember => _isLoadingMember;
  bool get isLoadingPalette => _isLoadingPalette;
  bool get isLoadingFoodInventory => _isLoadingFoodInventory;
  bool get isLoadingConsumableInventory => _isLoadingConsumableInventory;
  bool get isLoadingCharacterInventory => _isLoadingCharacterInventory;

  String? get memberError => _memberError;
  String? get paletteError => _paletteError;
  String? get foodInventoryError => _foodInventoryError;
  String? get consumableInventoryError => _consumableInventoryError;
  String? get characterInventoryError => _characterInventoryError;

  MemberViewModel({required this.repository});

  Future<void> loadMember() async {
    if (_isLoadingMember) return;
    _setLoadingState('member', isLoading: true);
    try {
      _member = await repository.fetchMemberData();
      _memberError = null;
    } catch (e) {
      _handleError("member", e);
    } finally {
      _setLoadingState('member', isLoading: false);
    }
  }

  Future<void> loadPalette() async {
    if (_isLoadingPalette) return;
    _setLoadingState('palette', isLoading: true);
    try {
      _palette =
          await repository.fetchMemberPalette(member?.memberId as String);
      _setError('palette');
    } catch (e) {
      _handleError("palette", e);
    } finally {
      _setLoadingState('palette', isLoading: false);
    }
  }

  Future<void> loadFoodInventory() async {
    if (_isLoadingFoodInventory) return;
    _setLoadingState('foodInventory', isLoading: true);
    try {
      _foodInventory = await repository.fetchMemberItemInventory(
          member?.memberId as String, ItemType.food);
      _setError('foodInventory');
    } catch (e) {
      _handleError("foodInventory", e);
    } finally {
      _setLoadingState('foodInventory', isLoading: false);
    }
  }

  Future<void> loadConsumableInventory() async {
    if (_isLoadingConsumableInventory) return;
    _setLoadingState('consumableInventory', isLoading: true);
    try {
      _consumableInventory = await repository.fetchMemberItemInventory(
          member?.memberId as String, ItemType.food);
      _setError('consumableInventory');
    } catch (e) {
      _handleError("consumableInventory", e);
    } finally {
      _setLoadingState('consumableInventory', isLoading: false);
    }
  }

  Future<void> loadCharacterInventory() async {
    if (_isLoadingCharacterInventory) return;
    _setLoadingState('characterInventory', isLoading: true);
    try {
      _characterInventory = await repository
          .fetchMemberCharacterInventory(member?.memberId as String);
      _setError('characterInventory');
    } catch (e) {
      _handleError("characterInventory", e);
    } finally {
      _setLoadingState('characterInventory', isLoading: false);
    }
  }

  Future<void> remove() async {
    return repository.clearMemberData();
  }

  // 로그인 후 초기데이터 조회 후 캐싱
  // 이후 데이터 변경작업 발생 시 개별 load 함수 호출로 캐시 업데이트
  Future<void> loadMemberRelatedData() async {
    await loadMember();
    if (_member != null) {
      loadPalette();
      loadFoodInventory();
      loadConsumableInventory();
      loadCharacterInventory();
    }
    notifyListeners();
  }

  Future<void> onAppStart() async {
    await loadMemberRelatedData();
  }

  void _handleError(String field, Object e) {
    final errorMessage = e.toString();
    _setError(field, errorMessage);
    MessageUtil.showErrorToast(errorMessage);
  }

  void _setLoadingState(String field, {required bool isLoading}) {
    switch (field) {
      case 'member':
        _isLoadingMember = isLoading;
        break;
      case 'palette':
        _isLoadingPalette = isLoading;
        break;
      case "foodInventory":
        _isLoadingFoodInventory = isLoading;
        break;
      case "consumableInventory":
        _isLoadingConsumableInventory = isLoading;
        break;
      case "characterInventory":
        _isLoadingCharacterInventory = isLoading;
        break;
    }
    notifyListeners();
  }

  void _setError(String field, [String? errorMessage]) {
    switch (field) {
      case 'member':
        _memberError = errorMessage;
        break;
      case 'palette':
        _paletteError = errorMessage;
        break;
      case "foodInventory":
        _foodInventoryError = errorMessage;
        break;
      case "consumableInventory":
        _consumableInventoryError = errorMessage;
        break;
      case "characterInventory":
        _characterInventoryError = errorMessage;
        break;
    }
    notifyListeners();
  }
}

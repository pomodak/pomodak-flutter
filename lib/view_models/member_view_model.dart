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
  bool _isLoadingConsumeItem = false;
  bool _isLoadingMemberUpdate = false;

  // 에러 메시지
  String? _memberError;
  String? _paletteError;
  String? _foodInventoryError;
  String? _consumableInventoryError;
  String? _characterInventoryError;
  String? _consumeItemError;
  String? _memberUpdateError;

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
  bool get isLoadingConsumeItem => _isLoadingConsumeItem;
  bool get isLoadingMemberUpdate => _isLoadingMemberUpdate;

  String? get memberError => _memberError;
  String? get paletteError => _paletteError;
  String? get foodInventoryError => _foodInventoryError;
  String? get consumableInventoryError => _consumableInventoryError;
  String? get characterInventoryError => _characterInventoryError;
  String? get consumeItemError => _consumeItemError;
  String? get memberUpdateError => _memberUpdateError;

  MemberViewModel({required this.repository});

  Future<void> loadMember({bool? refresh}) async {
    if (_isLoadingMember) return;
    _setLoadingState('member', isLoading: true);
    try {
      _setError("member");
      if (refresh != null && refresh) {
        _member = await repository.fetchMemberFromApi(); // 새로 요청
      } else {
        _member = await repository.fetchMemberData();
      }
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
          member?.memberId as String, ItemType.consumable);
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

  Future<void> updateMemberInfo({
    required String nickname,
    required String imageUrl,
    required String statusMessage,
  }) async {
    if (member == null || _isLoadingMemberUpdate) return;
    _setLoadingState('memberUpdate', isLoading: true);
    try {
      await repository.updateMember(
        member?.memberId ?? "",
        nickname: nickname,
        imageUrl: imageUrl,
        statusMessage: statusMessage,
      );
      await loadMember(refresh: true);
      MessageUtil.showSuccessToast("성공적으로 업데이트 되었습니다.");
    } catch (e) {
      _handleError("memberUpdate", e);
    } finally {
      _setLoadingState('memberUpdate', isLoading: false);
    }
  }

  // ConsumableItemAcquisition, CharacterAcquisition, PaletteAcuisition, PointAcquisition
  // 위 타입으로 캐스팅 해야함
  Future<dynamic> consumeItem(String inventoryId) async {
    if (_isLoadingConsumeItem) return;
    _setLoadingState('consumeItem', isLoading: true);
    try {
      _setError('consumeItem');
      var result = await repository.consumeItem(inventoryId);

      if (result.result == acquisitionResults['consumableItem']) {
        // loadConsumableInventory();
      } else if (result.result == acquisitionResults['character']) {
        loadCharacterInventory();
      } else if (result.result == acquisitionResults['palette']) {
        loadPalette();
      } else if (result.result == acquisitionResults['point']) {
        loadMember(refresh: true);
      }

      loadConsumableInventory();

      return result;
    } catch (e) {
      _handleError('consumeItem', e);
    } finally {
      _setLoadingState('consumeItem', isLoading: false);
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
      case "consumeItem":
        _isLoadingConsumeItem = isLoading;
        break;
      case 'memberUpdate':
        _isLoadingMemberUpdate = isLoading;
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
      case "consumeItem":
        _consumeItemError = errorMessage;
        break;
      case 'memberUpdate':
        _memberUpdateError = errorMessage;
        break;
    }
    notifyListeners();
  }
}

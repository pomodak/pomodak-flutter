import 'package:flutter/material.dart';
import 'package:pomodak/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:pomodak/data/repositories/transaction_repository.dart';
import 'package:pomodak/models/api/shop/transaction_record_model.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class TransactionViewModel with ChangeNotifier {
  // DI
  late final TransactionRepository repository;
  late final MemberViewModel memberViewModel;

  // 로딩 상태
  bool _isLoadingBuyItem = false;
  bool _isLoadingSellCharacter = false;
  bool _isLoadingApplyTime = false;
  bool _isLoadingConsumeItem = false;

  // 에러 메시지
  String? _buyItemError;
  String? _sellCharacterError;
  String? _consumeItemError;
  String? _applyTimeError;

  bool get isLoadingBuyItem => _isLoadingBuyItem;
  bool get isLoadingSellCharacter => _isLoadingSellCharacter;
  bool get isLoadingConsumeItem => _isLoadingConsumeItem;
  bool get isLoadingApplyTime => _isLoadingApplyTime;

  String? get buyItemError => _buyItemError;
  String? get sellCharacterError => _sellCharacterError;
  String? get consumeItemError => _consumeItemError;
  String? get applyTimeError => _applyTimeError;

  TransactionViewModel({
    required this.repository,
    required this.memberViewModel,
  });

  Future<TransactionRecordModel?> buyItem(int itemId, int count) async {
    if (_isLoadingBuyItem) return null;
    _setLoadingState('buyItem', isLoading: true);
    try {
      _setError("buyItem");
      var result = await repository.buyItem(itemId, count);

      memberViewModel.loadFoodInventory();
      memberViewModel.loadConsumableInventory();
      memberViewModel.loadMember(forceUpdate: true);

      MessageUtil.showSuccessToast(result.notes);
      return result;
    } catch (e) {
      _handleError('buyItem', e);
    } finally {
      _setLoadingState('buyItem', isLoading: false);
    }
    return null;
  }

  Future<TransactionRecordModel?> sellCharacter(
      String characterInventoryId, int count) async {
    if (_isLoadingSellCharacter) return null;
    _setLoadingState('sellCharacter', isLoading: true);
    try {
      _setError("sellCharacter");
      var result = await repository.sellCharacter(characterInventoryId, count);

      memberViewModel.loadCharacterInventory();
      memberViewModel.loadMember(forceUpdate: true);

      MessageUtil.showSuccessToast(result.notes);
      return result;
    } catch (e) {
      _handleError('sellCharacter', e);
    } finally {
      _setLoadingState('sellCharacter', isLoading: false);
    }
    return null;
  }

  Future<void> applyTimeToItemInventory(int seconds) async {
    if (memberViewModel.member == null) return;
    _setLoadingState('applyTime', isLoading: true);
    try {
      await repository.applyTimeToItemInventory(seconds);
      await memberViewModel.loadFoodInventory();

      for (var item in memberViewModel.foodInventory) {
        if (item.progress == 0) {
          MessageUtil.showSuccessToast("부화 가능한 알이 존재합니다.");
        }
      }
    } catch (e) {
      _handleError("applyTime", e);
    } finally {
      _setLoadingState('applyTime', isLoading: false);
    }
  }

  // ConsumableItemAcquisition, CharacterAcquisition, PaletteAcuisition, PointAcquisition
  // 위 타입으로 캐스팅 해야함
  Future<dynamic> consumeItem(
      {required String inventoryId, bool isFood = false}) async {
    if (_isLoadingConsumeItem) return;
    _setLoadingState('consumeItem', isLoading: true);
    try {
      _setError('consumeItem');
      var result = await repository.consumeItem(inventoryId);

      if (result.result == acquisitionResults['consumableItem']) {
        memberViewModel.loadConsumableInventory();
      } else if (result.result == acquisitionResults['character']) {
        memberViewModel.loadCharacterInventory();
      } else if (result.result == acquisitionResults['palette']) {
        memberViewModel.loadPalette();
      } else if (result.result == acquisitionResults['point']) {
        memberViewModel.loadMember(forceUpdate: true);
      }

      if (isFood) {
        memberViewModel.loadFoodInventory();
      } else {
        if (result.result != acquisitionResults['consumableItem']) {
          memberViewModel.loadConsumableInventory();
        }
      }

      return result;
    } catch (e) {
      _handleError('consumeItem', e);
    } finally {
      _setLoadingState('consumeItem', isLoading: false);
    }
  }

  void _handleError(String field, Object e) {
    final errorMessage = e.toString();
    _setError(field, errorMessage);
    MessageUtil.showErrorToast(errorMessage);
  }

  void _setLoadingState(String field, {required bool isLoading}) {
    switch (field) {
      case 'buyItem':
        _isLoadingBuyItem = isLoading;
        break;
      case 'sellCharacter':
        _isLoadingSellCharacter = isLoading;
        break;
      case "consumeItem":
        _isLoadingConsumeItem = isLoading;
        break;
      case 'applyTime':
        _isLoadingApplyTime = isLoading;
        break;
    }
    notifyListeners();
  }

  void _setError(String field, [String? errorMessage]) {
    switch (field) {
      case 'buyItem':
        _buyItemError = errorMessage;
        break;
      case 'sellCharacter':
        _sellCharacterError = errorMessage;
        break;
      case "consumeItem":
        _consumeItemError = errorMessage;
        break;
      case 'applyTime':
        _applyTimeError = errorMessage;
        break;
    }
    notifyListeners();
  }
}

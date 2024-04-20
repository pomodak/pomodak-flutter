import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class ShopViewModel with ChangeNotifier {
  // DI
  late final ShopRepository repository;
  late final MemberViewModel memberViewModel;

  // Data
  List<ItemModel>? _foodItems;
  List<ItemModel>? _consumableItems;

  // 로딩 상태
  bool _isLoadingFoodItems = false;
  bool _isLoadingConsumableItems = false;
  bool _isLoadingbuyItem = false;
  bool _isLoadingsellCharacter = false;

  // 에러 메시지
  String? _foodItemsError;
  String? _consumableItemsError;
  String? _buyItemError;
  String? _sellCharacterError;

  List<ItemModel> get foodItems => _foodItems ?? [];
  List<ItemModel> get consumableItems => _consumableItems ?? [];

  bool get isLoadingFoodItems => _isLoadingFoodItems;
  bool get isLoadingConsumableItems => _isLoadingConsumableItems;
  bool get isLoadingbuyItem => _isLoadingbuyItem;
  bool get isLoadingsellCharacter => _isLoadingsellCharacter;

  String? get foodItemsError => _foodItemsError;
  String? get consumableItemsError => _consumableItemsError;
  String? get buyItemError => _buyItemError;
  String? get sellCharacterError => _sellCharacterError;

  ShopViewModel({required this.repository, required this.memberViewModel});

  Future<void> loadFoodItems() async {
    if (_isLoadingFoodItems) return;
    _setLoadingState('foodItems', isLoading: true);
    try {
      _setError('foodItems');
      _foodItems = await repository.fetchShopItems(ItemType.food);

      notifyListeners();
    } catch (e) {
      _handleError("foodItems", e);
    } finally {
      _setLoadingState('foodItems', isLoading: false);
    }
  }

  Future<void> loadConsumableItems() async {
    if (_isLoadingConsumableItems) return;
    _setLoadingState('consumableItems', isLoading: true);
    try {
      _setError('consumableItems');
      _consumableItems = await repository.fetchShopItems(ItemType.consumable);

      notifyListeners();
    } catch (e) {
      _handleError("consumableItems", e);
    } finally {
      _setLoadingState('consumableItems', isLoading: false);
    }
  }

  // 첫 로드만 실행
  Future<void> loadShop() async {
    if (_foodItems == null) {
      await loadFoodItems();
    }
    if (_consumableItems == null) {
      await loadConsumableItems();
    }
  }

  // 에러 발생 시 재시도를 위한 refetch
  Future<void> refetchShop() async {
    await loadFoodItems();
    await loadConsumableItems();
  }

  void _handleError(String field, Object e) {
    final errorMessage = e.toString();
    _setError(field, errorMessage);
    MessageUtil.showErrorToast(errorMessage);
  }

  void _setLoadingState(String field, {required bool isLoading}) {
    switch (field) {
      case 'foodItems':
        _isLoadingFoodItems = isLoading;
        break;
      case 'consumableItems':
        _isLoadingConsumableItems = isLoading;
        break;
      case 'buyItem':
        _isLoadingbuyItem = isLoading;
        break;
      case 'sellCharacter':
        _isLoadingsellCharacter = isLoading;
        break;
    }
    notifyListeners();
  }

  void _setError(String field, [String? errorMessage]) {
    switch (field) {
      case 'foodItems':
        _foodItemsError = errorMessage;
        break;
      case 'consumableItems':
        _consumableItemsError = errorMessage;
        break;
      case 'buyItem':
        _buyItemError = errorMessage;
        break;
      case 'sellCharacter':
        _sellCharacterError = errorMessage;
        break;
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/domain/item_model.dart';

class ShopViewModel with ChangeNotifier {
  late final ShopRepository repository;
  List<ItemModel> _foodItems = [];
  List<ItemModel> _consumableItems = [];

  List<ItemModel> get foodItems => _foodItems;
  List<ItemModel> get consumableItems => _consumableItems;

  ShopViewModel({required this.repository});

  Future<void> loadShop() async {
    _foodItems = await repository.fetchShopItems(ItemType.food);
    _consumableItems = await repository.fetchShopItems(ItemType.consumable);
    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/shop/shop_item_response.dart';
import 'package:pomodak/models/domain/item_model.dart';

enum ItemType { food, consumable }

class ShopRepository {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  late BaseApiServices apiService;

  ShopRepository({required this.apiService});

  Future<List<ItemModel>> fetchShopItems(ItemType itemType) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/items?item_type=${itemType == ItemType.food ? "Food" : "Consumable"}',
      );
      BaseApiResponse<ShopItemResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => ShopItemResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      return data?.items ?? [];
    } catch (e) {
      rethrow;
    }
  }
}

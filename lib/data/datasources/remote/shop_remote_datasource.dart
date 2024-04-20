import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/shop/shop_item_response.dart';

abstract class ShopRemoteDataSource {
  Future<ShopItemResponse> fetchShopItemsApi(ItemType itemType);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  late BaseApiServices apiService;

  ShopRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ShopItemResponse> fetchShopItemsApi(ItemType itemType) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/items?item_type=${itemType == ItemType.food ? "Food" : "Consumable"}',
      );
      BaseApiResponse<ShopItemResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => ShopItemResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      if (data == null) {
        throw Exception('Failed to fetch shop items');
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }
}

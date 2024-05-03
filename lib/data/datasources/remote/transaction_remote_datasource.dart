import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/api/shop/reward_points_response.dart';
import 'package:pomodak/models/api/shop/transaction_response.dart';

const String consumableItemAcquisition = "Consumable Item Acquisition";
const String characterAcquisition = "Character Acquisition";
const String paletteAcquisition = "Palette Acquisition";
const String pointAcquisition = "Point Acquisition";

// 외부에서 타입 캐스팅을 하기 위해 Map으로 저장
Map<String, String> acquisitionResults = {
  'consumableItem': consumableItemAcquisition,
  'character': characterAcquisition,
  'palette': paletteAcquisition,
  'point': pointAcquisition,
};

abstract class TransactionRemoteDataSource {
  // 아이템 구매
  Future<TransactionResponse> buyItemApi(int itemId, int count);
  // 캐릭터 판매
  Future<TransactionResponse> sellCharacterApi(
    String characterInventoryId,
    int count,
  );
  // 타이머 기록 인벤토리(알)에 반영
  Future<void> applyTimeToItemInventoryApi(int seconds);
  // 아이템 사용
  Future<dynamic> consumeItemApi(String inventoryId);

  // 포인트 지급
  Future<RewardPointsResponse> rewardPointsApi(int points);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final String _springApiEndpoint = dotenv.env['SPRING_API_ENDPOINT']!;
  late BaseApiServices apiService;

  TransactionRemoteDataSourceImpl({required this.apiService});

  @override
  Future<TransactionResponse> buyItemApi(int itemId, int count) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getPostApiResponse(
        '$_springApiEndpoint/v2/shop/purchase',
        {
          'item_id': itemId,
          'count': count,
        },
      );
      BaseApiResponse<TransactionResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => TransactionResponse.fromJson(json as Map<String, dynamic>),
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to buy item');
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> sellCharacterApi(
      String characterInventoryId, int count) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getPostApiResponse(
        '$_springApiEndpoint/v2/shop/sell',
        {
          'character_inventory_id': characterInventoryId,
          'count': count,
        },
      );
      BaseApiResponse<TransactionResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => TransactionResponse.fromJson(json as Map<String, dynamic>),
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to sell character');
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> applyTimeToItemInventoryApi(int seconds) async {
    try {
      var responseJson = await apiService.getPostApiResponse(
        '$_springApiEndpoint/item-inventory/apply-time',
        {
          'seconds': seconds,
        },
      );
      return responseJson;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> consumeItemApi(String inventoryId) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getPostApiResponse(
        '$_springApiEndpoint/v2/item-inventory/$inventoryId',
        {},
      );
      final String result = responseJson["data"]["result"];
      late final BaseApiResponse<dynamic> response;
      switch (result) {
        case consumableItemAcquisition:
          response = BaseApiResponse.fromJson(
            responseJson,
            (json) => ConsumableItemAcquisition.fromJson(
                json as Map<String, dynamic>),
          );
          break;
        case characterAcquisition:
          response = BaseApiResponse.fromJson(
            responseJson,
            (json) =>
                CharacterAcquisition.fromJson(json as Map<String, dynamic>),
          );
          break;
        case paletteAcquisition:
          response = BaseApiResponse.fromJson(
            responseJson,
            (json) => PaletteAcquisition.fromJson(json as Map<String, dynamic>),
          );
          break;
        case pointAcquisition:
          response = BaseApiResponse.fromJson(
            responseJson,
            (json) => PointAcquisition.fromJson(json as Map<String, dynamic>),
          );
          break;
        default:
          throw Exception('Unknown result type: $result');
      }

      var data = response.data;
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RewardPointsResponse> rewardPointsApi(int points) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getPostApiResponse(
        '$_springApiEndpoint/transaction/reward',
        {
          'point': points,
        },
      );
      BaseApiResponse<RewardPointsResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => RewardPointsResponse.fromJson(json as Map<String, dynamic>),
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to reward points');
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/members/character_inventory_response.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/api/members/item_inventory_response.dart';
import 'package:pomodak/models/api/members/member_response.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/models/domain/streak_model.dart';

abstract class MemberRemoteDataSource {
  Future<MemberModel?> fetchMember();
  Future<PaletteModel?> fetchMemberPalette(String memberId);
  Future<List<CharacterInventoryModel>> fetchMemberCharacterInventory(
    String memberId,
  );
  Future<List<ItemInventoryModel>> fetchMemberItemInventory(
    String memberId,
    ItemType itemType,
  );
  Future<void> updateMember(
    String memberId,
    String nickname,
    String imageUrl,
    String statusMessage,
  );

  Future<void> applyTimeToItemInventory(int seconds);
  Future<dynamic> consumeItem(String inventoryId);
}

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

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final String _springApiEndpoint = dotenv.env['SPRING_API_ENDPOINT']!;
  late BaseApiServices apiService;

  MemberRemoteDataSourceImpl({required this.apiService});

  @override
  Future<MemberModel?> fetchMember() async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/members/me',
      );
      BaseApiResponse<MemberResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => MemberResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;

      return data?.member;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaletteModel?> fetchMemberPalette(String memberId) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/members/$memberId/study-streak',
      );
      BaseApiResponse<StreakModel> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => StreakModel.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      return data?.palette;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CharacterInventoryModel>> fetchMemberCharacterInventory(
      String memberId) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/members/$memberId/character-inventory',
      );
      BaseApiResponse<CharacterInventoryResponse> response =
          BaseApiResponse.fromJson(
        responseJson,
        (json) =>
            CharacterInventoryResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      return data?.characterInventory ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemInventoryModel>> fetchMemberItemInventory(
    String memberId,
    ItemType itemType,
  ) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/members/$memberId/item-inventory?${itemType == ItemType.food ? "item_type=Food" : "item_type=Consumable"}',
      );
      BaseApiResponse<ItemInventoryResponse> response =
          BaseApiResponse.fromJson(
        responseJson,
        (json) => ItemInventoryResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      return data?.itemInventory ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMember(
    String memberId,
    String nickname,
    String imageUrl,
    String statusMessage,
  ) async {
    try {
      Map<String, dynamic> responseJson = await apiService.getPatchApiResponse(
        '$_nestApiEndpoint/members/$memberId',
        {
          'nickname': nickname,
          'image_url': imageUrl,
          'status_message': statusMessage,
        },
      );
      BaseApiResponse<void> response = BaseApiResponse.fromJson(
        responseJson,
        (json) {},
      );
      var data = response.data;
      return data;
    } catch (e) {
      rethrow;
    }
  }

  // 타이머 기록 인벤토리(알)에 반영
  @override
  Future<void> applyTimeToItemInventory(int seconds) async {
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
  Future<dynamic> consumeItem(String inventoryId) async {
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
}

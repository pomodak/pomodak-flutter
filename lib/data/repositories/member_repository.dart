import 'dart:async';
import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';

String memberKey = "6E45EF1G1AUI3E51BD1VG9SD68";

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

class MemberRepository {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final String _springApiEndpoint = dotenv.env['SPRING_API_ENDPOINT']!;
  late BaseApiServices apiService;

  // 캐시 저장소
  late final SharedPreferences sharedPreferences;

  MemberRepository({required this.apiService}) {
    _init();
  }
  Future<void> _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<MemberModel?> fetchMemberData() async {
    try {
      String? memberData = sharedPreferences.getString(memberKey);
      if (memberData != null) {
        return MemberModel.fromJson(json.decode(memberData));
      } else {
        return await fetchMemberFromApi();
      }
    } catch (e) {
      clearMemberData();
      return null;
    }
  }

  Future<MemberModel?> fetchMemberFromApi() async {
    try {
      Map<String, dynamic> responseJson = await apiService.getGetApiResponse(
        '$_nestApiEndpoint/members/me',
      );
      BaseApiResponse<MemberResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => MemberResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      if (data != null) {
        await _storeMemberData(data.member);
      }

      return data?.member;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> updateMember(
    String memberId, {
    required String nickname,
    required String imageUrl,
    required String statusMessage,
  }) async {
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

  Future<void> _storeMemberData(MemberModel member) async {
    await sharedPreferences.setString(memberKey, json.encode(member.toJson()));
  }

  Future<void> clearMemberData() async {
    await sharedPreferences.remove(memberKey);
  }
}

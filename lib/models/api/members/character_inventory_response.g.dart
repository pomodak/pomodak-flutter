// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_inventory_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterInventoryResponse _$CharacterInventoryResponseFromJson(
        Map<String, dynamic> json) =>
    CharacterInventoryResponse(
      characterInventory: (json['character_inventory'] as List<dynamic>)
          .map((e) =>
              CharacterInventoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CharacterInventoryResponseToJson(
        CharacterInventoryResponse instance) =>
    <String, dynamic>{
      'character_inventory': instance.characterInventory,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_inventory_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemInventoryResponse _$ItemInventoryResponseFromJson(
        Map<String, dynamic> json) =>
    ItemInventoryResponse(
      itemInventory: (json['item_inventory'] as List<dynamic>)
          .map((e) => ItemInventoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemInventoryResponseToJson(
        ItemInventoryResponse instance) =>
    <String, dynamic>{
      'item_inventory': instance.itemInventory,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemInventoryModel _$ItemInventoryModelFromJson(Map<String, dynamic> json) =>
    ItemInventoryModel(
      itemInventoryId: json['item_inventory_id'] as String,
      quantity: json['quantity'] as int,
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemInventoryModelToJson(ItemInventoryModel instance) =>
    <String, dynamic>{
      'item_inventory_id': instance.itemInventoryId,
      'quantity': instance.quantity,
      'item': instance.item,
    };

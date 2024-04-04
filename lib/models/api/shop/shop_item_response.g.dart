// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemResponse _$ShopItemResponseFromJson(Map<String, dynamic> json) =>
    ShopItemResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopItemResponseToJson(ShopItemResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

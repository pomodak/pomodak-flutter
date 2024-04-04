import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/item_model.dart';

part 'shop_item_response.g.dart';

@JsonSerializable()
class ShopItemResponse {
  final List<ItemModel> items;

  ShopItemResponse({
    required this.items,
  });

  factory ShopItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemResponseToJson(this);
}

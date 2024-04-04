import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';

part 'item_inventory_response.g.dart';

@JsonSerializable()
class ItemInventoryResponse {
  @JsonKey(name: 'item_inventory')
  final List<ItemInventoryModel> itemInventory;

  ItemInventoryResponse({
    required this.itemInventory,
  });

  factory ItemInventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemInventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemInventoryResponseToJson(this);
}

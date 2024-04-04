import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/item_model.dart';

part 'item_inventory_model.g.dart';

@JsonSerializable()
class ItemInventoryModel {
  @JsonKey(name: 'item_inventory_id')
  final String itemInventoryId;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'item')
  final ItemModel item;

  ItemInventoryModel({
    required this.itemInventoryId,
    required this.quantity,
    required this.item,
  });

  factory ItemInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$ItemInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemInventoryModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/character_model.dart';

part 'character_inventory_model.g.dart';

@JsonSerializable()
class CharacterInventoryModel {
  @JsonKey(name: 'character_inventory_id')
  final String characterInventoryId;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'character')
  final CharacterModel character;

  CharacterInventoryModel({
    required this.characterInventoryId,
    required this.quantity,
    required this.character,
  });

  factory CharacterInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterInventoryModelToJson(this);
}

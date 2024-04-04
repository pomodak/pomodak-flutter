import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';

part 'character_inventory_response.g.dart';

@JsonSerializable()
class CharacterInventoryResponse {
  @JsonKey(name: 'character_inventory')
  final List<CharacterInventoryModel> characterInventory;

  CharacterInventoryResponse({
    required this.characterInventory,
  });

  factory CharacterInventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterInventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterInventoryResponseToJson(this);
}

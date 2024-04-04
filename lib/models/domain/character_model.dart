import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  @JsonKey(name: 'character_id')
  final String characterId;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'grade')
  final String grade;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String name;
  @JsonKey(name: 'sell_price')
  final int sellPrice;

  CharacterModel({
    required this.characterId,
    required this.description,
    required this.grade,
    required this.imageUrl,
    required this.name,
    required this.sellPrice,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);
}

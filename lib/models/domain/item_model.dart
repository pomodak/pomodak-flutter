import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  @JsonKey(name: 'item_id')
  final int itemId;
  final String name;
  @JsonKey(name: 'item_type') // Food | Consumable
  final String itemType;
  final String description;
  @JsonKey(name: 'required_study_time', includeIfNull: false)
  final int? requiredStudyTime;
  final int cost;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  ItemModel({
    required this.itemId,
    required this.name,
    required this.itemType,
    required this.description,
    this.requiredStudyTime,
    required this.cost,
    required this.imageUrl,
  });

  // JSON 역직렬화 생성자
  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  // JSON 직렬화 메서드
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}

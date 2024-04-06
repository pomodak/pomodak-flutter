import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/character_model.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/models/domain/palette_model.dart';

part 'consume_item_response.g.dart';

@JsonSerializable()
class ConsumableItemAcquisition {
  final String result;
  final ItemModel item;

  ConsumableItemAcquisition({required this.result, required this.item});

  factory ConsumableItemAcquisition.fromJson(Map<String, dynamic> json) =>
      _$ConsumableItemAcquisitionFromJson(json);
  Map<String, dynamic> toJson() => _$ConsumableItemAcquisitionToJson(this);
}

@JsonSerializable()
class CharacterAcquisition {
  final String result;
  final CharacterModel character;
  @JsonKey(name: 'character_inventory_id')
  final int characterInventoryId;

  CharacterAcquisition({
    required this.result,
    required this.character,
    required this.characterInventoryId,
  });

  factory CharacterAcquisition.fromJson(Map<String, dynamic> json) =>
      _$CharacterAcquisitionFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterAcquisitionToJson(this);
}

@JsonSerializable()
class PaletteAcquisition {
  final String result;
  final PaletteModel palette;

  PaletteAcquisition({
    required this.result,
    required this.palette,
  });

  factory PaletteAcquisition.fromJson(Map<String, dynamic> json) =>
      _$PaletteAcquisitionFromJson(json);
  Map<String, dynamic> toJson() => _$PaletteAcquisitionToJson(this);
}

@JsonSerializable()
class PointAcquisition {
  final String result;
  final PointAcquisitionMember member;

  PointAcquisition({
    required this.result,
    required this.member,
  });

  factory PointAcquisition.fromJson(Map<String, dynamic> json) =>
      _$PointAcquisitionFromJson(json);
  Map<String, dynamic> toJson() => _$PointAcquisitionToJson(this);
}

@JsonSerializable()
class PointAcquisitionMember {
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'earned_point')
  final int earnedPoint;
  final int point;

  PointAcquisitionMember({
    required this.memberId,
    required this.earnedPoint,
    required this.point,
  });

  factory PointAcquisitionMember.fromJson(Map<String, dynamic> json) =>
      _$PointAcquisitionMemberFromJson(json);
  Map<String, dynamic> toJson() => _$PointAcquisitionMemberToJson(this);
}

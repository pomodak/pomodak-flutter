// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consume_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumableItemAcquisition _$ConsumableItemAcquisitionFromJson(
        Map<String, dynamic> json) =>
    ConsumableItemAcquisition(
      result: json['result'] as String,
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConsumableItemAcquisitionToJson(
        ConsumableItemAcquisition instance) =>
    <String, dynamic>{
      'result': instance.result,
      'item': instance.item,
    };

CharacterAcquisition _$CharacterAcquisitionFromJson(
        Map<String, dynamic> json) =>
    CharacterAcquisition(
      result: json['result'] as String,
      character:
          CharacterModel.fromJson(json['character'] as Map<String, dynamic>),
      characterInventoryId: json['character_inventory_id'] as int,
    );

Map<String, dynamic> _$CharacterAcquisitionToJson(
        CharacterAcquisition instance) =>
    <String, dynamic>{
      'result': instance.result,
      'character': instance.character,
      'character_inventory_id': instance.characterInventoryId,
    };

PaletteAcquisition _$PaletteAcquisitionFromJson(Map<String, dynamic> json) =>
    PaletteAcquisition(
      result: json['result'] as String,
      palette: PaletteModel.fromJson(json['palette'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaletteAcquisitionToJson(PaletteAcquisition instance) =>
    <String, dynamic>{
      'result': instance.result,
      'palette': instance.palette,
    };

PointAcquisition _$PointAcquisitionFromJson(Map<String, dynamic> json) =>
    PointAcquisition(
      result: json['result'] as String,
      member: PointAcquisitionMember.fromJson(
          json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PointAcquisitionToJson(PointAcquisition instance) =>
    <String, dynamic>{
      'result': instance.result,
      'member': instance.member,
    };

PointAcquisitionMember _$PointAcquisitionMemberFromJson(
        Map<String, dynamic> json) =>
    PointAcquisitionMember(
      memberId: json['member_id'] as String,
      earnedPoint: json['earned_point'] as int,
      point: json['point'] as int,
    );

Map<String, dynamic> _$PointAcquisitionMemberToJson(
        PointAcquisitionMember instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'earned_point': instance.earnedPoint,
      'point': instance.point,
    };

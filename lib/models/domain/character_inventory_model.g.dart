// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterInventoryModel _$CharacterInventoryModelFromJson(
        Map<String, dynamic> json) =>
    CharacterInventoryModel(
      characterInventoryId: json['character_inventory_id'] as String,
      quantity: json['quantity'] as int,
      character:
          CharacterModel.fromJson(json['character'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterInventoryModelToJson(
        CharacterInventoryModel instance) =>
    <String, dynamic>{
      'character_inventory_id': instance.characterInventoryId,
      'quantity': instance.quantity,
      'character': instance.character,
    };

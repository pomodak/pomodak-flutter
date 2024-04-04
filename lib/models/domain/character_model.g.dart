// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      characterId: json['character_id'] as String,
      description: json['description'] as String,
      grade: json['grade'] as String,
      imageUrl: json['image_url'] as String,
      name: json['name'] as int,
      sellPrice: json['sell_price'] as int,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'character_id': instance.characterId,
      'description': instance.description,
      'grade': instance.grade,
      'image_url': instance.imageUrl,
      'name': instance.name,
      'sell_price': instance.sellPrice,
    };

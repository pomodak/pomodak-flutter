// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      characterId: json['character_id'] as int,
      description: json['description'] as String,
      grade: CharacterModel._gradeFromJson(json['grade'] as String),
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
      sellPrice: json['sell_price'] as int,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'character_id': instance.characterId,
      'grade': CharacterModel._gradeToJson(instance.grade),
      'image_url': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'sell_price': instance.sellPrice,
    };

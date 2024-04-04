// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'palette_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaletteModel _$PaletteModelFromJson(Map<String, dynamic> json) => PaletteModel(
      paletteId: json['palette_id'] as int,
      name: json['name'] as String,
      grade: json['grade'] as String,
      lightColor: json['light_color'] as String,
      normalColor: json['normal_color'] as String,
      darkColor: json['dark_color'] as String,
      darkerColor: json['darker_color'] as String,
    );

Map<String, dynamic> _$PaletteModelToJson(PaletteModel instance) =>
    <String, dynamic>{
      'palette_id': instance.paletteId,
      'name': instance.name,
      'grade': instance.grade,
      'light_color': instance.lightColor,
      'normal_color': instance.normalColor,
      'dark_color': instance.darkColor,
      'darker_color': instance.darkerColor,
    };

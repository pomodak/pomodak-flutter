// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakModel _$StreakModelFromJson(Map<String, dynamic> json) => StreakModel(
      studyStreakId: json['study_streak_id'] as int,
      palette: json['palette'] == null
          ? null
          : PaletteModel.fromJson(json['palette'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreakModelToJson(StreakModel instance) =>
    <String, dynamic>{
      'study_streak_id': instance.studyStreakId,
      'palette': instance.palette,
    };

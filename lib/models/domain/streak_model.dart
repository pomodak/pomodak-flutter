import 'package:json_annotation/json_annotation.dart';
import 'package:pomodak/models/domain/palette_model.dart';

part 'streak_model.g.dart';

@JsonSerializable()
class StreakModel {
  @JsonKey(name: 'study_streak_id')
  final int studyStreakId;
  @JsonKey(name: 'palette')
  final PaletteModel? palette;

  StreakModel({
    required this.studyStreakId,
    required this.palette,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) =>
      _$StreakModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreakModelToJson(this);
}

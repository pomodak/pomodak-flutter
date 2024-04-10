import 'package:json_annotation/json_annotation.dart';

part 'palette_model.g.dart';

enum PaletteGrade { common, rare, epic, legendary }

@JsonSerializable()
class PaletteModel {
  @JsonKey(name: 'palette_id')
  final int paletteId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'grade', fromJson: _gradeFromJson, toJson: _gradeToJson)
  final PaletteGrade grade;
  @JsonKey(name: 'light_color')
  final String lightColor;
  @JsonKey(name: 'normal_color')
  final String normalColor;
  @JsonKey(name: 'dark_color')
  final String darkColor;
  @JsonKey(name: 'darker_color')
  final String darkerColor;

  PaletteModel({
    required this.paletteId,
    required this.name,
    required this.grade,
    required this.lightColor,
    required this.normalColor,
    required this.darkColor,
    required this.darkerColor,
  });

  factory PaletteModel.fromJson(Map<String, dynamic> json) =>
      _$PaletteModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaletteModelToJson(this);

  static PaletteGrade _gradeFromJson(String grade) =>
      stringToPaletteGrade(grade);

  static String _gradeToJson(PaletteGrade grade) =>
      characterGradeToString(grade);
}

String characterGradeToString(PaletteGrade grade) {
  return grade.toString().split('.').last;
}

PaletteGrade stringToPaletteGrade(String grade) {
  return PaletteGrade.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == grade.toLowerCase());
}

import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

enum CharacterGrade { common, rare, epic, legendary }

@JsonSerializable()
class CharacterModel {
  @JsonKey(name: 'character_id')
  final int characterId;
  @JsonKey(name: 'grade', fromJson: _gradeFromJson, toJson: _gradeToJson)
  final CharacterGrade grade;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String name;
  final String description;
  @JsonKey(name: 'sell_price')
  final int sellPrice;

  CharacterModel({
    required this.characterId,
    required this.description,
    required this.grade,
    required this.imageUrl,
    required this.name,
    required this.sellPrice,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  static CharacterGrade _gradeFromJson(String grade) =>
      stringToCharacterGrade(grade);

  static String _gradeToJson(CharacterGrade grade) =>
      characterGradeToString(grade);
}

String characterGradeToString(CharacterGrade grade) {
  return grade.toString().split('.').last;
}

CharacterGrade stringToCharacterGrade(String grade) {
  return CharacterGrade.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == grade.toLowerCase());
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemId: json['item_id'] as int,
      name: json['name'] as String,
      itemType: json['item_type'] as String,
      description: json['description'] as String,
      requiredStudyTime: json['required_study_time'] as int?,
      cost: json['cost'] as int,
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) {
  final val = <String, dynamic>{
    'item_id': instance.itemId,
    'name': instance.name,
    'item_type': instance.itemType,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('required_study_time', instance.requiredStudyTime);
  val['cost'] = instance.cost;
  val['image_url'] = instance.imageUrl;
  return val;
}

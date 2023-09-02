// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationCategory _$LocationCategoryFromJson(Map<String, dynamic> json) =>
    LocationCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      coverImage: json['coverImage'] as String,
    );

Map<String, dynamic> _$LocationCategoryToJson(LocationCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverImage': instance.coverImage,
    };

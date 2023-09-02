// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_subcategory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationSubcategory _$LocationSubcategoryFromJson(Map<String, dynamic> json) =>
    LocationSubcategory(
      id: json['id'] as int,
      name: json['name'] as String,
      coverImage: json['coverImage'] as String,
    );

Map<String, dynamic> _$LocationSubcategoryToJson(
        LocationSubcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverImage': instance.coverImage,
    };

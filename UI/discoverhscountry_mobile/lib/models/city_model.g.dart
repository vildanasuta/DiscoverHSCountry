// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      cityId: json['cityId'] as int,
      name: json['name'] as String,
      coverImage: json['coverImage'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'name': instance.name,
      'coverImage': instance.coverImage,
    };

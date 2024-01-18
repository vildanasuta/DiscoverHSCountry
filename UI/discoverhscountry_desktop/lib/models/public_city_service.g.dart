// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_city_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicCityService _$PublicCityServiceFromJson(Map<String, dynamic> json) =>
    PublicCityService(
      publicCityServiceId: json['publicCityServiceId'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String?,
      coverImage: json['coverImage'] as String?,
      cityId: json['cityId'] as int?,
    );

Map<String, dynamic> _$PublicCityServiceToJson(PublicCityService instance) =>
    <String, dynamic>{
      'publicCityServiceId': instance.publicCityServiceId,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'cityId': instance.cityId,
      'coverImage': instance.coverImage,
    };

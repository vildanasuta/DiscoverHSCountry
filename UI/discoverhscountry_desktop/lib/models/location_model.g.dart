// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String,
      address: json['address'] as String,
      cityId: json['cityId'] as int,
      locationCategoryId: json['locationCategoryId'] as int,
      locationSubcategoryId: json['locationSubcategoryId'] as int,
      touristAttractionOwnerId: json['touristAttractionOwnerId'] as int,
      facebookUrl: json['facebookUrl'] as String,
      instagramUrl: json['instagramUrl'] as String,
      bookingUrl: json['bookingUrl'] as String,
      isApproved: json['isApproved'] as bool,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'coverImage': instance.coverImage,
      'address': instance.address,
      'cityId': instance.cityId,
      'locationCategoryId': instance.locationCategoryId,
      'locationSubcategoryId': instance.locationSubcategoryId,
      'touristAttractionOwnerId': instance.touristAttractionOwnerId,
      'facebookUrl': instance.facebookUrl,
      'instagramUrl': instance.instagramUrl,
      'bookingUrl': instance.bookingUrl,
      'isApproved': instance.isApproved,
    };

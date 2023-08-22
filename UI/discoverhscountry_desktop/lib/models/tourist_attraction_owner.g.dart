// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tourist_attraction_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TouristAttractionOwner _$TouristAttractionOwnerFromJson(
        Map<String, dynamic> json) =>
    TouristAttractionOwner(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$TouristAttractionOwnerToJson(
        TouristAttractionOwner instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
    };

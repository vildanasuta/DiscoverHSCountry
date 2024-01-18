// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tourist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tourist _$TouristFromJson(Map<String, dynamic> json) => Tourist(
      touristId: json['touristId'] as int,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      userId: json['userId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String,
      countryId: json['countryId'] as int,
    );

Map<String, dynamic> _$TouristToJson(Tourist instance) => <String, dynamic>{
      'touristId': instance.touristId,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
      'email': instance.email,
      'countryId': instance.countryId,
    };

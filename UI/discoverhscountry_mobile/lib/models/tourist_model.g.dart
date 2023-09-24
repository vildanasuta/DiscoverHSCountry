// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tourist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tourist _$TouristFromJson(Map<String, dynamic> json) => Tourist(
      touristId: json['touristId'] as int?,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      userId: json['userId'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      password: json['password'] as String,
      profileImage: json['profileImage'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$TouristToJson(Tourist instance) => <String, dynamic>{
      'touristId': instance.touristId,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'password': instance.password,
      'profileImage': instance.profileImage,
      'email': instance.email,
    };

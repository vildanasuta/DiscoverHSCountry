// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_issue_tourist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicalIssueTourist _$TechnicalIssueTouristFromJson(
        Map<String, dynamic> json) =>
    TechnicalIssueTourist(
      tehnicalIssueTouristId: json['tehnicalIssueTouristId'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      touristId: json['touristId'] as int?,
      locationId: json['locationId'] as int?,
    );

Map<String, dynamic> _$TechnicalIssueTouristToJson(
        TechnicalIssueTourist instance) =>
    <String, dynamic>{
      'tehnicalIssueTouristId': instance.tehnicalIssueTouristId,
      'title': instance.title,
      'description': instance.description,
      'touristId': instance.touristId,
      'locationId': instance.locationId,
    };

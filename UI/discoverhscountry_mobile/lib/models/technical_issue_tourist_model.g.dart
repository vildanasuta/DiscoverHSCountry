// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_issue_tourist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicalIssueTourist _$TechnicalIssueTouristFromJson(
        Map<String, dynamic> json) =>
    TechnicalIssueTourist(
      title: json['title'] as String,
      description: json['description'] as String,
      touristId: json['touristId'] as int?,
      locationId: json['locationId'] as int?,
    );

Map<String, dynamic> _$TechnicalIssueTouristToJson(
        TechnicalIssueTourist instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'touristId': instance.touristId,
      'locationId': instance.locationId,
    };

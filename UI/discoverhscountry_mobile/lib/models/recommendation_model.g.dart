// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      recommendationId: json['recommendationId'] as int?,
      touristId: json['touristId'] as int,
      locationId: json['locationId'] as int,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'touristId': instance.touristId,
      'locationId': instance.locationId,
    };

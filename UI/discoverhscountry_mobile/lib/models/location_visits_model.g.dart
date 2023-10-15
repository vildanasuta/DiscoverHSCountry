// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_visits_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationVisits _$LocationVisitsFromJson(Map<String, dynamic> json) =>
    LocationVisits(
      locationVisitsId: json['locationVisitsId'] as int?,
      locationId: json['locationId'] as int,
      touristId: json['touristId'] as int,
      numberOfVisits: json['numberOfVisits'] as int,
    );

Map<String, dynamic> _$LocationVisitsToJson(LocationVisits instance) =>
    <String, dynamic>{
      'locationVisitsId': instance.locationVisitsId,
      'locationId': instance.locationId,
      'touristId': instance.touristId,
      'numberOfVisits': instance.numberOfVisits,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visited_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitedLocation _$VisitedLocationFromJson(Map<String, dynamic> json) =>
    VisitedLocation(
      visitedLocationId: json['visitedLocationId'] as int?,
      locationId: json['locationId'] as int,
      touristId: json['touristId'] as int,
      visitDate: DateTime.parse(json['visitDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$VisitedLocationToJson(VisitedLocation instance) =>
    <String, dynamic>{
      'visitedLocationId': instance.visitedLocationId,
      'locationId': instance.locationId,
      'touristId': instance.touristId,
      'visitDate': instance.visitDate.toIso8601String(),
      'notes': instance.notes,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visited_location_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitedLocationImage _$VisitedLocationImageFromJson(
        Map<String, dynamic> json) =>
    VisitedLocationImage(
      visitedLocationImageId: json['visitedLocationImageId'] as int?,
      visitedLocationId: json['visitedLocationId'] as int,
      image: json['image'] as String,
    );

Map<String, dynamic> _$VisitedLocationImageToJson(
        VisitedLocationImage instance) =>
    <String, dynamic>{
      'visitedLocationImageId': instance.visitedLocationImageId,
      'visitedLocationId': instance.visitedLocationId,
      'image': instance.image,
    };

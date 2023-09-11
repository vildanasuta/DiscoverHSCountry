// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricalEvent _$HistoricalEventFromJson(Map<String, dynamic> json) =>
    HistoricalEvent(
      title: json['title'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String,
      cityId: json['cityId'] as int?,
    );

Map<String, dynamic> _$HistoricalEventToJson(HistoricalEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'cityId': instance.cityId,
      'coverImage': instance.coverImage,
    };

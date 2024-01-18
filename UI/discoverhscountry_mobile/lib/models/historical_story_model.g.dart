// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricalStory _$HistoricalStoryFromJson(Map<String, dynamic> json) =>
    HistoricalStory(
      historicalEventId: json['historicalEventId'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String?,
      cityId: json['cityId'] as int,
    );

Map<String, dynamic> _$HistoricalStoryToJson(HistoricalStory instance) =>
    <String, dynamic>{
      'historicalEventId': instance.historicalEventId,
      'title': instance.title,
      'description': instance.description,
      'coverImage': instance.coverImage,
      'cityId': instance.cityId,
    };

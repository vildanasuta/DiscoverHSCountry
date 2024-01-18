// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      eventId: json['eventId'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      address: json['address'] as String?,
      ticketCost: (json['ticketCost'] as num?)?.toDouble(),
      cityId: json['cityId'] as int?,
      eventCategoryId: json['eventCategoryId'] as int?,
      locationId: json['locationId'] as int?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'address': instance.address,
      'ticketCost': instance.ticketCost,
      'cityId': instance.cityId,
      'eventCategoryId': instance.eventCategoryId,
      'locationId': instance.locationId,
    };

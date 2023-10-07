// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationService _$ReservationServiceFromJson(Map<String, dynamic> json) =>
    ReservationService(
      reservationServiceId: json['reservationServiceId'] as int?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfPeople: json['numberOfPeople'] as int,
      additionalDescription: json['additionalDescription'] as String,
      reservationId: json['reservationId'] as int,
      serviceId: json['serviceId'] as int,
    );

Map<String, dynamic> _$ReservationServiceToJson(ReservationService instance) =>
    <String, dynamic>{
      'reservationServiceId': instance.reservationServiceId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'numberOfPeople': instance.numberOfPeople,
      'additionalDescription': instance.additionalDescription,
      'reservationId': instance.reservationId,
      'serviceId': instance.serviceId,
    };

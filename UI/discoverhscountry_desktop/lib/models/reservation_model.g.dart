// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      reservationId: json['reservationId'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfPeople: json['numberOfPeople'] as int,
      additionalDescription: json['additionalDescription'] as String?,
      touristId: json['touristId'] as int?,
      serviceId: json['serviceId'] as int?,
      locationId: json['locationId'] as int?,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'numberOfPeople': instance.numberOfPeople,
      'additionalDescription': instance.additionalDescription,
      'touristId': instance.touristId,
      'serviceId': instance.serviceId,
      'locationId': instance.locationId,
      'price': instance.price,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      reservationId: json['reservationId'] as int?,
      touristId: json['touristId'] as int?,
      locationId: json['locationId'] as int?,
      price: (json['price'] as num).toDouble(),
      isPaid: json['isPaid'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
      payPalPaymentId: json['payPalPaymentId'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'touristId': instance.touristId,
      'locationId': instance.locationId,
      'price': instance.price,
      'isPaid': instance.isPaid,
      'isConfirmed': instance.isConfirmed,
      'payPalPaymentId': instance.payPalPaymentId,
    };

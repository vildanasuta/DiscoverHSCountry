// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'reservation_model.g.dart';

@JsonSerializable()
class Reservation {
  int? reservationId;
  final int? touristId;
  final int? locationId;
  final double price;
  final bool isPaid;
  final bool isConfirmed;
  String? payPalPaymentId;

  Reservation({
    this.reservationId,
    this.touristId,
    this.locationId,
    required this.price,
    required this.isPaid,
    required this.isConfirmed,
    this.payPalPaymentId
  });
   factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}


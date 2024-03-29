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

  Reservation({
    this.reservationId,
    this.touristId,
    this.locationId,
    required this.price,
    required this.isPaid,
    required this.isConfirmed
  });
   factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
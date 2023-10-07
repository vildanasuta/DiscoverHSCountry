// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'reservation_model.g.dart';

@JsonSerializable()
class Reservation {
  int? reservationId;
  final int touristId;
  final int locationId;
  double price;

  Reservation({
    this.reservationId,
    required this.touristId,
    required this.locationId,
    required this.price,
  });
   factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}


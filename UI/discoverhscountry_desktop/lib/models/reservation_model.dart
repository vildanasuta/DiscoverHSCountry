import 'package:json_annotation/json_annotation.dart';
part 'reservation_model.g.dart';

@JsonSerializable()
class Reservation {
  final int reservationId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPeople;
  final String? additionalDescription;
  final int? touristId;
  final int? serviceId;
  final int? locationId;
  final double price;

  Reservation({
    required this.reservationId,
    required this.startDate,
    required this.endDate,
    required this.numberOfPeople,
    this.additionalDescription,
    this.touristId,
    this.serviceId,
    this.locationId,
    required this.price,
  });
   factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
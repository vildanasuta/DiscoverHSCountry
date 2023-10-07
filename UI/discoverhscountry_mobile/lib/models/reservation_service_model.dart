// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'reservation_service_model.g.dart';

@JsonSerializable()
class ReservationService {
  int? reservationServiceId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPeople;
  final String additionalDescription;
  int reservationId;
  final int serviceId;

  ReservationService({
    this.reservationServiceId,
    required this.startDate,
    required this.endDate,
    required this.numberOfPeople,
    required this.additionalDescription,
    required this.reservationId,
    required this.serviceId,
  });

   factory ReservationService.fromJson(Map<String, dynamic> json) =>
      _$ReservationServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationServiceToJson(this);
}


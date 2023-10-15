// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'location_visits_model.g.dart';

@JsonSerializable()
class LocationVisits {
  int? locationVisitsId;
  final int locationId;
  final int touristId;
  final int numberOfVisits;

  LocationVisits({
    this.locationVisitsId,
    required this.locationId,
    required this.touristId,
    required this.numberOfVisits,
  });

  factory LocationVisits.fromJson(Map<String, dynamic> json) =>
      _$LocationVisitsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationVisitsToJson(this);
}
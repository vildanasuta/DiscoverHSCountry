// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'visited_location_model.g.dart';

@JsonSerializable()
class VisitedLocation {
  int? visitedLocationId;
  final int locationId;
  final int touristId;
  DateTime visitDate;
  String? notes;

  VisitedLocation({
    this.visitedLocationId,
    required this.locationId,
    required this.touristId,
    required this.visitDate,
    this.notes
  });
   factory VisitedLocation.fromJson(Map<String, dynamic> json) =>
      _$VisitedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$VisitedLocationToJson(this);
}


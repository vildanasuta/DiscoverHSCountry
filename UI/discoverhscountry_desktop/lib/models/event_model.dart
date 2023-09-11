import 'package:json_annotation/json_annotation.dart';
part 'event_model.g.dart';


@JsonSerializable()
class Event {
  String title;
  String description;
  DateTime date;
  String startTime;
  String? address;
  double? ticketCost;
  int? cityId;
  int? eventCategoryId;
  int? locationId;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    this.address,
    this.ticketCost,
    this.cityId,
    this.eventCategoryId,
    this.locationId,
  });
   factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
  
  }
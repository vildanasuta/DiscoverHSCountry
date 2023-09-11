import 'package:json_annotation/json_annotation.dart';
part 'historical_event.g.dart';


@JsonSerializable()
class HistoricalEvent {
  String title;
  String description;
  int? cityId;
  final String coverImage;

  HistoricalEvent({
    required this.title,
    required this.description,
    required this.coverImage,
    this.cityId,
  });
   factory HistoricalEvent.fromJson(Map<String, dynamic> json) =>
      _$HistoricalEventFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricalEventToJson(this);
  
  }
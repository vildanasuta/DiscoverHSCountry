// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'historical_story_model.g.dart';

@JsonSerializable()
class HistoricalStory {
  final int? historicalEventId;
  final String title;
  final String description;
  final String? coverImage;
  final int cityId;

  HistoricalStory({
    this.historicalEventId,
    required this.title,
    required this.description,
    this.coverImage,
    required this.cityId,
  });
   factory HistoricalStory.fromJson(Map<String, dynamic> json) =>
      _$HistoricalStoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricalStoryToJson(this);
}


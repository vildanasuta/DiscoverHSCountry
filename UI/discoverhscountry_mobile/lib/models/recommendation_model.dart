// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'recommendation_model.g.dart';

@JsonSerializable()
class Recommendation {
  int? recommendationId;
  final int touristId;
  final int locationId;

  Recommendation({
    this.recommendationId,
    required this.touristId,
    required this.locationId,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'visited_location_image_model.g.dart';

@JsonSerializable()
class VisitedLocationImage {
  int? visitedLocationImageId;
  int visitedLocationId;
  String image;

  VisitedLocationImage({
    this.visitedLocationImageId,
    required this.visitedLocationId,
    required this.image,
  });
   factory VisitedLocationImage.fromJson(Map<String, dynamic> json) =>
      _$VisitedLocationImageFromJson(json);

  Map<String, dynamic> toJson() => _$VisitedLocationImageToJson(this);
}


import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class Location {
  final int? locationId;
  final String name;
  final String description;
  final String coverImage;
  final String address;
  final int cityId;
  final int locationCategoryId;
  final int locationSubcategoryId;
  final int? touristAttractionOwnerId;
  final String facebookUrl;
  final String instagramUrl;
  final String bookingUrl;
  final bool isApproved;

  Location({
    this.locationId,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.address,
    required this.cityId,
    required this.locationCategoryId,
    required this.locationSubcategoryId,
    this.touristAttractionOwnerId,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.bookingUrl,
    required this.isApproved,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

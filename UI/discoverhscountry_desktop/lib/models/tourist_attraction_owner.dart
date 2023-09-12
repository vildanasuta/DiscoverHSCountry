import 'package:json_annotation/json_annotation.dart';
part 'tourist_attraction_owner.g.dart';

@JsonSerializable()
class TouristAttractionOwner {
  int? touristAttractionOwnerId;
  int? userId;
  String email;
  String? password;
  String firstName;
  String lastName;
  String? profileImage;

  TouristAttractionOwner({
    this.touristAttractionOwnerId,
    this.userId,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory TouristAttractionOwner.fromJson(Map<String, dynamic> json) =>
      _$TouristAttractionOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$TouristAttractionOwnerToJson(this);
}

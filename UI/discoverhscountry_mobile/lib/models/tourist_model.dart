// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'tourist_model.g.dart';

@JsonSerializable()
class Tourist {
  final int? touristId;
  final DateTime dateOfBirth;
  final int? userId;
  final String firstName;
  final String lastName;
  final String password;
  String? profileImage;
  final String email;
  final int countryId;

  Tourist({
    this.touristId,
    required this.dateOfBirth,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.password,
    this.profileImage,
    required this.email,
    required this.countryId
  });

   factory Tourist.fromJson(Map<String, dynamic> json) =>
      _$TouristFromJson(json);

  Map<String, dynamic> toJson() => _$TouristToJson(this);
}
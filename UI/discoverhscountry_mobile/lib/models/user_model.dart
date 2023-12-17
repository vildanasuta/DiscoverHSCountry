// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int userId;
  String firstName;
  String lastName;
  String? profileImage;
  final String email;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.email,
  });
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
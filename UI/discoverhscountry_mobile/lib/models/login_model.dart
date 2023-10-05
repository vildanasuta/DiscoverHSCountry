// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  String email;
  String password;
  String deviceType;

  LoginModel({
    required this.email,
    required this.password,
    required this.deviceType,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
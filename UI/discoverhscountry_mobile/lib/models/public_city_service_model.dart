// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'public_city_service_model.g.dart';

@JsonSerializable()
class PublicCityService {
  int? publicCityServiceId;
  final String name;
  final String description;
  final String address;
  final String coverImage;
  final int cityId;

  PublicCityService({
    this.publicCityServiceId,
    required this.name,
    required this.description,
    required this.address,
    required this.coverImage,
    required this.cityId,
  });
   factory PublicCityService.fromJson(Map<String, dynamic> json) =>
      _$PublicCityServiceFromJson(json);

  Map<String, dynamic> toJson() => _$PublicCityServiceToJson(this);
}


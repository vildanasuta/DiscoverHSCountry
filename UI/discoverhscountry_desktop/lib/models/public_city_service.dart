import 'package:json_annotation/json_annotation.dart';
part 'public_city_service.g.dart';


@JsonSerializable()
class PublicCityService {
  int? publicCityServiceId;
  String name;
  String description;
  String? address;
  int? cityId;
  String? coverImage;

  PublicCityService({
    this.publicCityServiceId,
    required this.name,
    required this.description,
    this.address,
    this.coverImage,
    this.cityId,
  });
   factory PublicCityService.fromJson(Map<String, dynamic> json) =>
      _$PublicCityServiceFromJson(json);

  Map<String, dynamic> toJson() => _$PublicCityServiceToJson(this);
  
  }
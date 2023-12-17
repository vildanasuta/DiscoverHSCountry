// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'city_model.g.dart';

@JsonSerializable()
class City {
  final int cityId;
  final String name;
  String coverImage;

  City({
    required this.cityId,
    required this.name,
    required this.coverImage,
  });
   factory City.fromJson(Map<String, dynamic> json) =>
      _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}


// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'country_model.g.dart';

@JsonSerializable()
class Country {
  final int countryId;
  final String name;
  Country({
    required this.countryId,
    required this.name,
  });
   factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}


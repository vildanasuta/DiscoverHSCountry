import 'package:json_annotation/json_annotation.dart';
part 'location_category_model.g.dart';

@JsonSerializable()
class LocationCategory {
  final int id;
  final String name;
  final String coverImage;

  LocationCategory({
    required this.id,
    required this.name,
    required this.coverImage,
  });
   factory LocationCategory.fromJson(Map<String, dynamic> json) =>
      _$LocationCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCategoryToJson(this);
}

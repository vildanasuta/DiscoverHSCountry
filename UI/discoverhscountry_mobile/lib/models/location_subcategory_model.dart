// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'location_subcategory_model.g.dart';

@JsonSerializable()
class LocationSubcategory {
  final int id;
  final String name;
  final String coverImage;
  final int categoryId;

  LocationSubcategory({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.categoryId,
  });
   factory LocationSubcategory.fromJson(Map<String, dynamic> json) =>
      _$LocationSubcategoryFromJson(json);

  Map<String, dynamic> toJson() => _$LocationSubcategoryToJson(this);
}


import 'package:json_annotation/json_annotation.dart';
part 'event_category.g.dart';

@JsonSerializable()
class EventCategory {
  final int id;
  final String name;

  EventCategory({
    required this.id,
    required this.name,
  });
   factory EventCategory.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$EventCategoryToJson(this);
}

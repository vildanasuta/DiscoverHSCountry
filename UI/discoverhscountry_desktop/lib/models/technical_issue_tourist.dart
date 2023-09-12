import 'package:json_annotation/json_annotation.dart';
part 'technical_issue_tourist.g.dart';

@JsonSerializable()
class TechnicalIssueTourist {
  final String title;
  final String description;
  final int? touristId;
  final int? locationId;

  TechnicalIssueTourist({
    required this.title,
    required this.description,
    this.touristId,
    this.locationId,
  });

 factory TechnicalIssueTourist.fromJson(Map<String, dynamic> json) =>
      _$TechnicalIssueTouristFromJson(json);

  Map<String, dynamic> toJson() => _$TechnicalIssueTouristToJson(this);
}

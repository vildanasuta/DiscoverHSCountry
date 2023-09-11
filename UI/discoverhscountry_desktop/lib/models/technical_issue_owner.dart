import 'package:json_annotation/json_annotation.dart';
part 'technical_issue_owner.g.dart';

@JsonSerializable()
class TechnicalIssueOwner {
  final String title;
  final String description;
  final int? touristAttractionOwnerId;

  TechnicalIssueOwner({
    required this.title,
    required this.description,
    this.touristAttractionOwnerId,
  });

 factory TechnicalIssueOwner.fromJson(Map<String, dynamic> json) =>
      _$TechnicalIssueOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$TechnicalIssueOwnerToJson(this);
}

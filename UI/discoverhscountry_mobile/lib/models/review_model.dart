// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'review_model.g.dart';

@JsonSerializable()
class Review {
  int? reviewId;
  String? title;
  String? description;
  double rate;
  DateTime reviewDate;
  final int touristId;
  final int locationId;

  Review({
    this.reviewId,
    this.title,
    this.description,
    required this.rate,
    required this.reviewDate,
    required this.touristId,
    required this.locationId,
  });
   factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}


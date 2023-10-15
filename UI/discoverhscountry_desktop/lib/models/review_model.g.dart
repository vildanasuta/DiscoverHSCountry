// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      reviewId: json['reviewId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      rate: (json['rate'] as num).toDouble(),
      reviewDate: DateTime.parse(json['reviewDate'] as String),
      touristId: json['touristId'] as int,
      locationId: json['locationId'] as int,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'reviewId': instance.reviewId,
      'title': instance.title,
      'description': instance.description,
      'rate': instance.rate,
      'reviewDate': instance.reviewDate.toIso8601String(),
      'touristId': instance.touristId,
      'locationId': instance.locationId,
    };

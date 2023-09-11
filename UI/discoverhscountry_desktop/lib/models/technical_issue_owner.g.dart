// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_issue_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicalIssueOwner _$TechnicalIssueOwnerFromJson(Map<String, dynamic> json) =>
    TechnicalIssueOwner(
      title: json['title'] as String,
      description: json['description'] as String,
      touristAttractionOwnerId: json['touristAttractionOwnerId'] as int?,
    );

Map<String, dynamic> _$TechnicalIssueOwnerToJson(
        TechnicalIssueOwner instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'touristAttractionOwnerId': instance.touristAttractionOwnerId,
    };

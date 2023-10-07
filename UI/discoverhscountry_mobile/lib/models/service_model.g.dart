// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      serviceId: json['serviceId'] as int?,
      serviceName: json['serviceName'] as String,
      serviceDescription: json['serviceDescription'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      locationId: json['locationId'] as int,
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'serviceDescription': instance.serviceDescription,
      'unitPrice': instance.unitPrice,
      'locationId': instance.locationId,
    };

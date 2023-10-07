// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'service_model.g.dart';

@JsonSerializable()
class Service {
  int? serviceId;
  String serviceName;
  String serviceDescription;
  double unitPrice;
  int locationId;

  Service({
    this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.unitPrice,
    required this.locationId,
  });
  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}

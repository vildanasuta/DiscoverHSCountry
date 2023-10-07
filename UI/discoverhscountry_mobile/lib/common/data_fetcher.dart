// ignore: file_names
import 'dart:convert';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/location_category_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/location_subcategory_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;


mixin DataFetcher {

Future<List<City>> fetchCities({int? page, int? pageSize}) async {
  final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City');
  final Map<String, dynamic> queryParameters = {};

  if (page != null && pageSize != null) {
    queryParameters['Page'] = page.toString();
    queryParameters['PageSize'] = pageSize.toString();
  }
  final response = await http.get(uri.replace(queryParameters: queryParameters));

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body)['result']['\$values'] as List<dynamic>;
    final cities = jsonData.map<City>((json) {
      return City.fromJson(json);
    }).toList();
    return cities;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<LocationCategory>> fetchLocationCategories() async {
  final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationCategory');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body)['result']['\$values'] as List<dynamic>;
    var locationCategories = <LocationCategory>[];
    for (var locationCategoryData in jsonData) {
      var locationCategory = LocationCategory(
        id: locationCategoryData['locationCategoryId'] as int,
        name: locationCategoryData['name'] as String,
        coverImage: locationCategoryData['coverImage'] as String,
      );
      locationCategories.add(locationCategory);
    }
    return locationCategories;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<LocationSubcategory>> fetchSubcategoriesByCategoryId(int categoryId) async {
  final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationSubcategory/GetSubcategoriesByCategory/$categoryId');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
    var locationSubcategories = <LocationSubcategory>[];
    for (var locationSubcategoryData in jsonData) {
      var locationSubcategory = LocationSubcategory(
        id: locationSubcategoryData['locationSubcategoryId'] as int,
        name: locationSubcategoryData['name'] as String,
        coverImage: locationSubcategoryData['coverImage'] as String,
        categoryId: locationSubcategoryData['locationCategoryId'] as int,
      );
      locationSubcategories.add(locationSubcategory);
    }
    return locationSubcategories;
  } else {
    throw Exception('Failed to load data');
  }
}
Future<List<Location>> fetchLocationsBySubcategoryId(int categoryId, int subcategoryId) async {
final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/GetLocationsBySubcategoryId/$categoryId/$subcategoryId');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
    final locations = jsonData.map<Location>((json) {
      return Location.fromJson(json);
    }).toList();
    return locations;
  } else if(response.statusCode==404){
    return [];
  }
  else {
    throw Exception('Failed to load data');
  }
}

Future<City> getCityById(int cityId) async{
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City/$cityId');
    final response= await http.get(uri);
    if(response.statusCode==200){
          final jsonData = json.decode(response.body);
          final city = City.fromJson(jsonData);
          return city;
      }
    else {
    throw Exception('Failed to load data');
  }

}

Future<int?> getTouristIdByUserId(int userId) async{
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/GetTouristIdByUserId/$userId');
    final response= await http.get(uri);
    if(response.statusCode==200){
                  return int.tryParse(response.body);

      }
    else {
    throw Exception('Failed to load data');
  }

}

Future<List<Service>> getServicesByLocationId(int locationId) async {
  final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Service/GetServicesByLocationId/$locationId');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
    final services = jsonData.map((json) {
      return Service(
        serviceId: json['serviceId'],
        serviceName: json['serviceName'],
        serviceDescription: json['serviceDescription'],
        unitPrice: json['unitPrice'],
        locationId: json['locationId'],
      );
    }).toList();
    return services;
  } else {
    throw Exception('Failed to load data');
  }
}


}

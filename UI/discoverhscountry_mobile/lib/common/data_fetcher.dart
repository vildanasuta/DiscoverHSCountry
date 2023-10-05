// ignore: file_names
import 'dart:convert';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
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
 print(queryParameters);
  final response = await http.get(uri.replace(queryParameters: queryParameters));

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body)['result']['\$values'] as List<dynamic>;
    var cities = <City>[];
    for (var cityData in jsonData) {
      var city = City(
        id: cityData['cityId'] as int,
        name: cityData['name'] as String,
        coverImage: cityData['coverImage'] as String,
      );
      cities.add(city);
    }
    return cities;
  } else {
    throw Exception('Failed to load data');
  }
}

}

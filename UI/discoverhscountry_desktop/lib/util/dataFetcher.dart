// ignore_for_file: file_names

import 'dart:convert';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/event_category.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/location_subcategory_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';


mixin DataFetcher {
  Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/City'));
    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
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

  Future<List<LocationCategory>> fetchLocationCategories(
      bool isTouristAttractionOwner) async {
    final response =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/LocationCategory'));
    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      var categories = <LocationCategory>[];
      for (var categoryData in jsonData) {
        var categoryName = categoryData['name'] as String;
        // it doesn't make sense for tourist attraction owners to add historical & religious sites or natural landmarks
        // the idea is that they add their own tourist attractions (which are their properties)
        // administrator will be adding public tourist attractions like natural landmarks, historical & religious sites
        if (isTouristAttractionOwner) {
          if (categoryName == "Historical & Religious Sites" ||
              categoryName == "Natural Landmarks") {
            continue;
          }
        }
        var category = LocationCategory(
          id: categoryData['locationCategoryId'] as int,
          name: categoryData['name'] as String,
          coverImage: categoryData['coverImage'] as String,
        );
        categories.add(category);
      }
      return categories;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<LocationSubcategory>> fetchLocationSubcategories(
      int categoryId) async {
    final response = await http.get(Uri.parse(
      '${ApiConstants.baseUrl}/LocationSubcategory/GetSubcategoriesByCategory/$categoryId',
    ));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      var subcategories = <LocationSubcategory>[];
      if (jsonData.containsKey("\$values")) {
        var subcategoryDataList = jsonData["\$values"];
        for (var subcategoryData in subcategoryDataList) {
          var subcategory = LocationSubcategory(
            id: subcategoryData['locationSubcategoryId'] as int,
            name: subcategoryData['name'] as String,
            coverImage: subcategoryData['coverImage'] as String,
          );
          subcategories.add(subcategory);
        }
      }
      return subcategories;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<EventCategory>> fetchEventCategories() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/EventCategory'));
    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      var categories = <EventCategory>[];
      for (var categoryData in jsonData) {
        var category = EventCategory(
          id: categoryData['eventCategoryId'] as int,
          name: categoryData['categoryName'] as String,
        );
        categories.add(category);
      }
      return categories;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<int>> fetchLocationIdsByTouristAttractionOwnerId(
      int taoId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/LocationTouristAttractionOwner/GetLocationIdsByTouristAttractionOwnerId/$taoId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['\$values'];

      // ignore: unnecessary_null_comparison
      if (jsonData != null && jsonData.isNotEmpty) {
        final List<int> locationIds =
            jsonData.map<int>((value) => value as int).toList();
        return locationIds;
      } else {
        throw Exception(
            'No location IDs found for the specified tourist attraction owner.');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLocationsByIds(
      List<int> locationIds) async {
    final List<Map<String, dynamic>> locationsData = [];

    for (int id in locationIds) {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/Location/$id'),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        final locationData = {
          'locationId': jsonData['locationId'] as int,
          'name': jsonData['name'] as String,
          'description': jsonData['description'] as String,
        };
        locationsData.add(locationData);
      } else {
        throw Exception('Failed to load location data for ID: $id');
      }
    }
    return locationsData;
  }

  Future<List<Reservation>> fetchReservationsByLocationId(
      int locationId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/Reservation/GetReservationByLocationId/$locationId'),
    );

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body)['\$values'];
        if (data is List) {
          final List<Reservation> reservations = data
              .map((reservationJson) => Reservation.fromJson(reservationJson))
              .toList();
          return reservations;
        } else {
          throw Exception('Unexpected data format: $data');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load reservations: ${response.statusCode}');
    }
  }

  Future<int?> getTouristAttractionOwnerIdByUserId(int userId) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/TouristAttractionOwner/GetTouristAttractionOwnerIdByUserId/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  Future<Tourist> getTouristById(int touristId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId'),
    );
    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        var user = await getUserByUserId(data['userId']);
        final tourist= Tourist(touristId: data['touristId'], 
        dateOfBirth: data['dateOfBirth'],
        userId: data['userId'], 
        firstName: user.firstName, 
        lastName: user.lastName, 
        email: user.email, 
        profileImage: user.profileImage);

      return tourist;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      throw Exception('Failed to parse user data');
    }
  } else {
    throw Exception('Failed to fetch user data');
  }
    }
  
Future<User> getUserByUserId(int userId) async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/User/$userId'),
  );
  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);
      final user = User(
        userId: data['userId'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        profileImage: data['profileImage'],
        email: data['email']
      );

      return user;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      throw Exception('Failed to parse user data');
    }
  } else {
    throw Exception('Failed to fetch user data');
  }
}
Future<Service> getServiceByServiceId(int serviceId) async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/Service/$serviceId'),
  );
  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);
      final service = Service(
        serviceId: data['serviceId'],
        serviceName: data['serviceName'],
      );

      return service;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      throw Exception('Failed to parse user data');
    }
  } else {
    throw Exception('Failed to fetch user data');
  }
}

  Future<List<Location>> fetchAllDisapprovedLocations() async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/Location'),
    );

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body)['result']['\$values'];
        if (data is List) {
          final List<Location> locations = data
              .map((locationsjson) => Location.fromJson(locationsjson))
              .where((location) => location.isApproved == false) 
              .toList();
          return locations;
        } else {
          throw Exception('Unexpected data format: $data');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load reservations: ${response.statusCode}');
    }


    
  }
Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

}
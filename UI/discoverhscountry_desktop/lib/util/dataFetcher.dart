// ignore_for_file: file_names

import 'dart:convert';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/event_category.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/location_subcategory_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_service_model.dart';
import 'package:discoverhscountry_desktop/models/review_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_owner.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_tourist.dart';
import 'package:discoverhscountry_desktop/models/tourist_attraction_owner.dart';
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

 Future<List<String>> fetchAllEmails() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/User'));
    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      var users = <User>[];
      for (var userData in jsonData) {
        var user = User(
          userId: userData['userId'] as int,
          email: userData['email'] as String,
          firstName: userData['firstName'] as String,
          lastName: userData['lastName'] as String, 
          profileImage: userData['profileImage'],
        );
        users.add(user);
      }
      List<String> emails=[];
      for (var user in users){
        emails.add(user.email);
      }
      return emails;
    } else {
      throw Exception('Failed to load data');
    }
  }




  Future<List<Review>> getReviewByLocationId(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final reviews = jsonData
          .map<Review>((json) {
            return Review.fromJson(json);
          })
          .where((review) => review.locationId == locationId)
          .toList();
      return reviews;
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
      if (jsonData.isNotEmpty) {
        final List<int> locationIds =
            jsonData.map<int>((value) => value as int).toList();
        return locationIds;
      } else {
        // ignore: avoid_print
        print(
            'No location IDs found for the specified tourist attraction owner.');
            return [];
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

  Future<List<Location>> fetchLocationDetailsByIds(
      List<int> locationIds) async {
    List<Location> locationsData = [];

    for (int id in locationIds) {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/Location/$id'),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var locationData = Location.fromJson(jsonData);
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
        final tourist = Tourist(
            touristId: data['touristId'],
            dateOfBirth: DateTime.parse(data['dateOfBirth']),
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
Future<Location> getLocationById(int locationId) async{
  final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$locationId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final location = Location.fromJson(jsonData);
      return location;
    } else {
      throw Exception('Failed to load data');
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
            email: data['email']);

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
          serviceDescription: data['serviceDescription'],
          unitPrice: data['unitPrice'],
          locationId: data['locationId'],
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
      Uri.parse('${ApiConstants.baseUrl}/Location'),
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

  Future<List<TechnicalIssueOwner>> fetchAllTechnicalIssuesOwner() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/TechnicalIssueOwner'),
    );

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body)['result']['\$values'];
        if (data is List) {
          final List<TechnicalIssueOwner> technicalIssuesOwnerList = data
              .map((technicalIssuesOwner) =>
                  TechnicalIssueOwner.fromJson(technicalIssuesOwner))
              .toList();
          return technicalIssuesOwnerList;
        } else {
          throw Exception('Unexpected data format: $data');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load issues: ${response.statusCode}');
    }
  }

  Future<List<TechnicalIssueTourist>> fetchAllTechnicalIssuesTourist() async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/TechnicalIssueTourist'),
  );

  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body)['result']['\$values'];
      if (data is List) {
        final List<TechnicalIssueTourist> technicalIssuesTouristList = [];

        for (var item in data) {
          final technicalIssueTourist = TechnicalIssueTourist.fromJson(item);
          technicalIssuesTouristList.add(technicalIssueTourist);
        }

        return technicalIssuesTouristList;
      } else {
        throw Exception('Unexpected data format: $data');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load issues: ${response.statusCode}');
  }
}

  Future<TouristAttractionOwner> getTouristAttractionOwnerById(
      int taoId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/TouristAttractionOwner/$taoId'),
    );
    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        var user = await getUserByUserId(data['userId']);
        final tao = TouristAttractionOwner(
            touristAttractionOwnerId: data['touristAttractionOwnerId'],
            userId: data['userId'],
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            profileImage: user.profileImage);

        return tao;
      } catch (e) {
        // ignore: avoid_print
        print('Error: $e');
        throw Exception('Failed to parse user data');
      }
    } else {
      throw Exception('Failed to fetch user data');
    }
  }


Future<List<ReservationService>> getReservationDetailsById(int reservationId) async {
  final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/ReservationService'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    var resultList = jsonData["result"]['\$values'];
    final List<ReservationService> reservationServicesList = [];

    for (var reservationServiceData in resultList) {
      final reservationService = ReservationService(
      additionalDescription: reservationServiceData['additionalDescription'], 
      startDate: DateTime.parse(reservationServiceData['startDate']),
      endDate: DateTime.parse(reservationServiceData['endDate']),
      numberOfPeople: reservationServiceData['numberOfPeople'],
      reservationId: reservationServiceData['reservationId'],
      serviceId: reservationServiceData['serviceId']
      );
      if (reservationService.reservationId == reservationId) {
        reservationServicesList.add(reservationService);
      }
    }

    return reservationServicesList;
  } else {
    throw Exception('Failed to load data');
  }
}


}

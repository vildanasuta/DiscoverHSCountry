// ignore: file_names
import 'dart:convert';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/location_category_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/location_subcategory_model.dart';
import 'package:discoverhscountry_mobile/models/location_visits_model.dart';
import 'package:discoverhscountry_mobile/models/public_city_service_model.dart';
import 'package:discoverhscountry_mobile/models/recommendation_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/review_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/tourist_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_image_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

mixin DataFetcher {
  Future<List<City>> fetchCities({int? page, int? pageSize}) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City');
    final Map<String, dynamic> queryParameters = {};

    if (page != null && pageSize != null) {
      queryParameters['Page'] = page.toString();
      queryParameters['PageSize'] = pageSize.toString();
    }
    final response =
        await http.get(uri.replace(queryParameters: queryParameters));

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
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
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
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

  Future<List<LocationSubcategory>> fetchSubcategoriesByCategoryId(
      int categoryId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/LocationSubcategory/GetSubcategoriesByCategory/$categoryId');
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

  Future<List<Location>> fetchLocationsBySubcategoryId(
      int categoryId, int subcategoryId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Location/GetLocationsBySubcategoryId/$categoryId/$subcategoryId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
      final locations = jsonData.map<Location>((json) {
        return Location.fromJson(json);
      }).toList();
      return locations;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<City> getCityById(int cityId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City/$cityId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final city = City.fromJson(jsonData);
      return city;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Tourist> getTouristById(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final tourist = Tourist.fromJson(jsonData);
      return tourist;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<User> getUserById(int userId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/User/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final user = User.fromJson(jsonData);
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<int?> getTouristIdByUserId(int userId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Tourist/GetTouristIdByUserId/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return int.tryParse(response.body);
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

  Future<List<Review>> getBestReviewsByOthersForUsersBestRatedLocation(
      int locationId, int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final reviews = jsonData
          .map<Review>((json) {
            return Review.fromJson(json);
          })
          .where((review) =>
              review.locationId == locationId &&
              review.rate > 4.0 &&
              review.touristId != touristId)
          .toList();
      return reviews;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Service>> getServicesByLocationId(int locationId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Service/GetServicesByLocationId/$locationId');
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

  Future<List<PublicCityService>> getAllPublicCityServices() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/PublicCityService');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final publicCityServices = jsonData.map<PublicCityService>((json) {
        return PublicCityService.fromJson(json);
      }).toList();
      return publicCityServices;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void launchMaps(String locationName) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$locationName';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  Future<List<Location>> fetchLocations() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final locations = jsonData.map<Location>((json) {
        return Location.fromJson(json);
      }).toList();
      return locations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Location>> fetchLocationsByCityId(int cityId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final locations = jsonData
          .map<Location>((json) {
            return Location.fromJson(json);
          })
          .where((location) =>
              location.cityId == cityId && location.isApproved == true)
          .toList();
      return locations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getUserNameForReviewDisplay(int touristId) async {
    int? userId;
    User? user;
    String? fullName;

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null) {
          userId = jsonData['userId'];
        }
        if (userId != null) {
          final uriSecond = Uri.parse('${ApiConstants.baseUrl}/User/$userId');
          final responseSecond = await http.get(uriSecond);

          if (responseSecond.statusCode == 200) {
            final jsonData = json.decode(responseSecond.body);
            user = User.fromJson(jsonData);
          }
        }
        if (user != null) {
          fullName = '${user.firstName} ${user.lastName}';
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return fullName ?? ''; // Return an empty string if fullName is null
  }

  Future<List<VisitedLocation>> getAllVisitedLocations(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/VisitedLocation');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final visitedLocations = jsonData
          .map<VisitedLocation>((json) {
            return VisitedLocation.fromJson(json);
          })
          .where((visitedLocation) => visitedLocation.touristId == touristId)
          .toList();
      return visitedLocations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Location?> getLocationById(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$locationId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final location = Location.fromJson(jsonData);
      return location;
    } else if (response.statusCode==204){
      return null;
    }
    else{
      throw Exception('Failed to load data');
    }
  }

  Future<List<VisitedLocationImage>> getVisitedLocationImages(
      int visitedLocationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/VisitedLocationImage');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final images = jsonData
          .map<VisitedLocationImage>((json) {
            return VisitedLocationImage.fromJson(json);
          })
          .where((visitedLocationImage) =>
              visitedLocationImage.visitedLocationId == visitedLocationId)
          .toList();
      return images;
    } else {
      throw Exception('Failed to load data');
    }
  }

  getExistingReservationsForService(int serviceId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/ReservationService');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final images = jsonData
          .map<ReservationService>((json) {
            return ReservationService.fromJson(json);
          })
          .where(
              (reservationService) => reservationService.serviceId == serviceId)
          .toList();
      return images;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<LocationVisits?> getLocationVisitsByLocationIdAndTouristId(
      int locationId, int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationVisits');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['result']['\$values'];

      try {
        final locationVisits = jsonData
            .map<LocationVisits>((json) => LocationVisits.fromJson(json))
            .firstWhere(
              (locationVisit) =>
                  locationVisit.locationId == locationId &&
                  locationVisit.touristId == touristId,
            );

        return locationVisits;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Review>> getBestReviewsByTouristId(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      final reviews = jsonData
          .map<Review>((json) {
            return Review.fromJson(json);
          })
          .where((review) => review.touristId == touristId && review.rate > 4.0)
          .toList();
      return reviews;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Recommendation>> getRecommendationByTouristId(int userId) async {
    var touristId = await getTouristIdByUserId(userId);

    final Uri getAllUri = Uri.parse('${ApiConstants.baseUrl}/Recommendation');
    final responseAll = await http.get(getAllUri);
    if (responseAll.statusCode == 200) {
      var jsonData = json.decode(responseAll.body)['result']['\$values'];
      final existingRecommendations = jsonData
          .map<Recommendation>((json) {
            return Recommendation.fromJson(json);
          })
          .where((recommendation) => recommendation.touristId == touristId)
          .toList();
      if (existingRecommendations.isNotEmpty) {
        for (var recommendation in existingRecommendations) {
          Uri deleteUri = Uri.parse(
              '${ApiConstants.baseUrl}/Recommendation/${recommendation.recommendationId}');
          final responseDelete = await http.delete(deleteUri);
          if(responseDelete.statusCode==200){
          }
        }
        existingRecommendations.clear();
      }
    }

    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Recommendation/Recommendations/$touristId');
    final response = await http.get(uri);
   
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
      final recommendations = jsonData
          .map<Recommendation>((json) {
            return Recommendation.fromJson(json);
          }).toList();
      return recommendations;
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

}

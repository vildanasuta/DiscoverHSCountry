// ignore: file_names
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/country_model.dart';
import 'package:discoverhscountry_mobile/models/event_model.dart';
import 'package:discoverhscountry_mobile/models/historical_story_model.dart';
import 'package:discoverhscountry_mobile/models/location_category_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/location_subcategory_model.dart';
import 'package:discoverhscountry_mobile/models/location_visits_model.dart';
import 'package:discoverhscountry_mobile/models/public_city_service_model.dart';
import 'package:discoverhscountry_mobile/models/recommendation_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/review_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/tourist_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_image_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

mixin DataFetcher {
  Future<http.Response> makeAuthenticatedRequest(
    Uri uri,
    String method, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final headers = {'Authorization': 'Bearer $token'};

    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }

    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: json.encode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: json.encode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw UnsupportedError('Unsupported HTTP method: $method');
    }
  }

  Future<List<City>> fetchCities({int? page, int? pageSize}) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City');
    final Map<String, dynamic> queryParameters = {};

    if (page != null && pageSize != null) {
      queryParameters['Page'] = page.toString();
      queryParameters['PageSize'] = pageSize.toString();
    }

    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'GET',
        queryParameters: queryParameters,
      );

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Country>> fetchCountries() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Country/GetAllCountries');
    try {
      final response = await http.get(
        uri);
      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final countries = jsonData.map<Country>((json) {
          return Country.fromJson(json);
        }).toList();
        return countries;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Event>> fetchEvents(
      {int? page, int? pageSize, DateTime? selectedDate}) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Event');
    final Map<String, dynamic> queryParameters = {};

    if (page != null && pageSize != null) {
      queryParameters['Page'] = page.toString();
      queryParameters['PageSize'] = pageSize.toString();
    }

    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'GET',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final now = DateTime.now();
        final DateTime yesterday = now.subtract(const Duration(days: 1));
        // ignore: prefer_typing_uninitialized_variables
        var events;
        if (selectedDate == null) {
          events = jsonData
              .map<Event>((json) => Event.fromJson(json))
              .where((event) => event.date.isAfter(yesterday))
              .toList();
        } else {
          events = jsonData
              .map<Event>((json) => Event.fromJson(json))
              .where((event) => event.date == selectedDate)
              .toList();
        }
        return events;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<String> getEventCategoryById(int eventCategoryId) async {
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/EventCategory/$eventCategoryId');
    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['categoryName'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<dynamic>> fetchEventCategories() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventCategory');
    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;

        List<Map<String, dynamic>> categories = jsonData
            .map((categoryJson) => {
                  'eventCategoryId': categoryJson['eventCategoryId'] as int,
                  'categoryName': categoryJson['categoryName'] as String,
                })
            .toList();

        return categories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<LocationCategory>> fetchLocationCategories() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationCategory');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<LocationSubcategory>> fetchSubcategoriesByCategoryId(
      int categoryId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/LocationSubcategory/GetSubcategoriesByCategory/$categoryId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Location>> fetchLocationsBySubcategoryId(
      int categoryId, int subcategoryId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Location/GetLocationsBySubcategoryId/$categoryId/$subcategoryId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData =
            json.decode(response.body)['\$values'] as List<dynamic>;
        final locations = jsonData.map<Location>((json) {
          return Location.fromJson(json);
        }).toList();
        return locations;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<City> getCityById(int cityId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City/$cityId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final city = City.fromJson(jsonData);
        return city;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<Tourist> getTouristById(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tourist = Tourist.fromJson(jsonData);
        return tourist;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<User> getUserById(int userId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/User/$userId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final user = User.fromJson(jsonData);
        return user;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<int?> getTouristIdByUserId(int userId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Tourist/GetTouristIdByUserId/$userId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Review>> getReviewByLocationId(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Review>> getBestReviewsByOthersForUsersBestRatedLocation(
      int locationId, int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Service>> getServicesByLocationId(int locationId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Service/GetServicesByLocationId/$locationId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData =
            json.decode(response.body)['\$values'] as List<dynamic>;
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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Service>> getServices() async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Service');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<PublicCityService>> getAllPublicCityServices() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/PublicCityService');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }


  Future<List<HistoricalStory>> getAllHistoricalEvents() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/HistoricalEvent');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final historicalEvents = jsonData.map<HistoricalStory>((json) {
          return HistoricalStory.fromJson(json);
        }).toList();
        return historicalEvents;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  void launchMaps(String locationName, var context) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$locationName';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      Flushbar(
        message: "Address isn't correct so it cannot be found on Google Maps.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ).show(context);
    }
  }

  Future<List<Location>> fetchLocations() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Location>> fetchLocationsByCityId(int cityId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<String> getUserNameForReviewDisplay(int touristId) async {
    int? userId;
    User? user;
    String? fullName;

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null) {
          userId = jsonData['userId'];
        }
        if (userId != null) {
          final uriSecond = Uri.parse('${ApiConstants.baseUrl}/User/$userId');
          final responseSecond =
              await makeAuthenticatedRequest(uriSecond, 'GET');

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

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<int> getTAOByLocation(int locationId) async {
    int userId = 0;
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/LocationTouristAttractionOwner');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> values = jsonData['result']['\$values'];
        final locationItem = values.firstWhere(
            (element) => element['locationId'] == locationId,
            orElse: () => null);
        var touristAttractionOwnerId = 0;
        if (locationItem != null) {
          touristAttractionOwnerId =
              locationItem?['touristAttractionOwnerId'] as int;
        }
        final Uri newUri = Uri.parse(
            '${ApiConstants.baseUrl}/TouristAttractionOwner/$touristAttractionOwnerId');
        try {
          final responseNew = await makeAuthenticatedRequest(newUri, 'GET');
          if (responseNew.statusCode == 200) {
            final jsonData = json.decode(responseNew.body);
            userId = jsonData['userId'];
          }
        } catch (error) {
          throw Exception('Failed to make authenticated request: $error');
        }

        return userId;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<Location?> getLocationById(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$locationId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final location = Location.fromJson(jsonData);
        return location;
      } else if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<int?> getLocationIdByEventId(int eventId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventLocation/$eventId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['locationId'];
      } else if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<VisitedLocationImage>> getVisitedLocationImages(
      int visitedLocationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/VisitedLocationImage');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<ReservationService>> getExistingReservationsForService(
      int serviceId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/ReservationService');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final reservations = jsonData
            .map<ReservationService>((json) {
              return ReservationService.fromJson(json);
            })
            .where((reservationService) =>
                reservationService.serviceId == serviceId)
            .toList();
        return reservations;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Reservation>> getReservationsForTourist(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Reservation');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final reservations = jsonData
            .map<Reservation>((json) {
              return Reservation.fromJson(json);
            })
            .where((reservation) => reservation.touristId == touristId)
            .toList();
        return reservations;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<ReservationService>> getReservationServicesByReservationId(
      int reservationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/ReservationService');
    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final services = jsonData
            .map<ReservationService>((json) {
              return ReservationService.fromJson(json);
            })
            .where((service) => service.reservationId == reservationId)
            .toList();
        return services;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<LocationVisits?> getLocationVisitsByLocationIdAndTouristId(
      int locationId, int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationVisits');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Review>> getBestReviewsByTouristId(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        final reviews = jsonData
            .map<Review>((json) {
              return Review.fromJson(json);
            })
            .where(
                (review) => review.touristId == touristId && review.rate > 4.0)
            .toList();
        return reviews;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Recommendation>> getRecommendationByTouristId(int userId) async {
    var touristId = await getTouristIdByUserId(userId);

    final Uri getAllUri = Uri.parse('${ApiConstants.baseUrl}/Recommendation');

    try {
      final responseAll = await makeAuthenticatedRequest(getAllUri, 'GET');

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
            final responseDelete =
                await makeAuthenticatedRequest(deleteUri, 'DELETE');
            if (responseDelete.statusCode == 200) {
              // Do something after successful deletion if needed
            }
          }
          existingRecommendations.clear();
        }
      }

      final Uri uri = Uri.parse(
          '${ApiConstants.baseUrl}/Recommendation/Recommendations/$touristId');
      final response = await makeAuthenticatedRequest(uri, 'GET');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body)['\$values'] as List<dynamic>;
        final recommendations = jsonData.map<Recommendation>((json) {
          return Recommendation.fromJson(json);
        }).toList();
        return recommendations;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<String>> fetchAllEmails() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/User/GetAllUsers');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonData =
            json.decode(response.body)['result']['\$values'] as List<dynamic>;
        var users = <User>[];
        for (var userData in jsonData) {
          var user = User(
            userId: userData['userId'] as int,
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            profileImage: userData['profileImage'],
          );
          users.add(user);
        }

        List<String> emails = [];
        for (var user in users) {
          emails.add(user.email);
        }
        return emails;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<Reservation?> updateIsPaid(int id, bool isPaid) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Reservation/UpdateIsPaid/$id/$isPaid');
    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'PUT',
        body: jsonEncode({
          'id': id,
          'isPaid': isPaid,
        }),
      );
      if (response.statusCode == 200) {
        return Reservation.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

 Future<Reservation?> addPayPalPaymentId(int id, String paymentId) async {
  final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}/Reservation/AddPayPalPaymentId/$id/$paymentId');
  try {
    final response = await makeAuthenticatedRequest(
      uri,
      'PUT',
      body: {
        'id': id,
        'payPalPaymentId': paymentId,
      },
    );
    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } catch (error) {
    throw Exception('Failed to make authenticated request: $error');
  }
}

}

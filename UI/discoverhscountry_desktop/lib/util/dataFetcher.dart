// ignore_for_file: file_names

import 'dart:convert';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/country_model.dart';
import 'package:discoverhscountry_desktop/models/event_category.dart';
import 'package:discoverhscountry_desktop/models/event_model.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/location_subcategory_model.dart';
import 'package:discoverhscountry_desktop/models/public_city_service.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_service_model.dart';
import 'package:discoverhscountry_desktop/models/review_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_owner.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_tourist.dart';
import 'package:discoverhscountry_desktop/models/tourist_attraction_owner.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

mixin DataFetcher {
  Future<http.Response> makeAuthenticatedRequest(
    Uri uri,
    String method, {
    dynamic body,
  }) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final headers = {'Authorization': 'Bearer $token'};

    if (body != null) {
      headers['Content-Type'] = 'application/json';
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

  Future<List<City>> fetchCities() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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

  Future<List<Map<String, dynamic>>> fetchLocationTAO() async {
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/LocationTouristAttractionOwner');
    final response = await makeAuthenticatedRequest(uri, 'GET');
    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'] as List<dynamic>;
      List<Map<String, dynamic>> extractedData =
          jsonData.map<Map<String, dynamic>>((element) {
        return {
          'locationId': element['locationId'].toString(),
          'touristAttractionOwnerId': element['touristAttractionOwnerId'],
        };
      }).toList();

      return extractedData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> fetchAllEmails() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/User');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
      List<String> emails = [];
      for (var user in users) {
        emails.add(user.email);
      }
      return emails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Country>> fetchCountries() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Country');
    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'GET',
      );
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

  Future<Country> fetchCountryById(int countryId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Country/$countryId');
    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'GET',
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        final country = Country.fromJson(jsonData);
        return country;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<City> fetchCityById(int cityId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/City/$cityId');
    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'GET',
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        final city = City(id: jsonData['cityId'], name: jsonData['name'], coverImage: jsonData['coverImage']);
        return city;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to make authenticated request: $error');
    }
  }

  Future<List<Review>> getReviewByLocationId(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Review');
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
  }

    Future<List<PublicCityService>> fetchAllPublicCityServices() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/PublicCityService');
    final response = await makeAuthenticatedRequest(uri, 'GET');

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(response.body)['result']['\$values'];
      final publicCityServices = jsonData
          .map<PublicCityService>((json) {
            return PublicCityService.fromJson(json);
          }).toList();
      return publicCityServices;
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<List<LocationCategory>> fetchLocationCategories(
      bool isTouristAttractionOwner) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationCategory');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}/LocationSubcategory/GetSubcategoriesByCategory/$categoryId',
    );
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventCategory');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/LocationTouristAttractionOwner/GetLocationIdsByTouristAttractionOwnerId/$taoId');
    final response = await makeAuthenticatedRequest(uri, 'GET');

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
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$id');
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$id');
      final response = await makeAuthenticatedRequest(uri, 'GET');

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
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Reservation/GetReservationByLocationId/$locationId');
    final response = await makeAuthenticatedRequest(uri, 'GET');

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
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/TouristAttractionOwner/GetTouristAttractionOwnerIdByUserId/$userId');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  Future<Tourist> getTouristById(int touristId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
            profileImage: user.profileImage,
            countryId: data['countryId']);
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

  Future<Location> getLocationById(int locationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location/$locationId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final location = Location.fromJson(jsonData);
      return location;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<User> getUserByUserId(int userId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/User/$userId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Service/$serviceId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');
    final response = await makeAuthenticatedRequest(uri, 'GET');

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
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/TechnicalIssueOwner');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/TechnicalIssueTourist');
    final response = await makeAuthenticatedRequest(uri, 'GET');

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
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/TouristAttractionOwner/$taoId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
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

  Future<List<ReservationService>> getReservationDetailsById(
      int reservationId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/ReservationService');
    final response = await makeAuthenticatedRequest(uri, 'GET');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var resultList = jsonData["result"]['\$values'];
      final List<ReservationService> reservationServicesList = [];

      for (var reservationServiceData in resultList) {
        final reservationService = ReservationService(
            additionalDescription:
                reservationServiceData['additionalDescription'],
            startDate: DateTime.parse(reservationServiceData['startDate']),
            endDate: DateTime.parse(reservationServiceData['endDate']),
            numberOfPeople: reservationServiceData['numberOfPeople'],
            reservationId: reservationServiceData['reservationId'],
            serviceId: reservationServiceData['serviceId']);
        if (reservationService.reservationId == reservationId) {
          reservationServicesList.add(reservationService);
        }
      }

      return reservationServicesList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Location>> getAllLocations() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Location');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      final List<Location> locations = [];
      if (response.statusCode == 200) {
        final jsonDataList = json.decode(response.body);
        var resultList = jsonDataList["result"]['\$values'];
        for (var locationData in resultList) {
          final location = Location(
              locationId: locationData['locationId'],
              name: locationData['name'],
              description: locationData['description'],
              coverImage: locationData['coverImage'],
              address: locationData['address'],
              cityId: locationData['cityId'],
              locationCategoryId: locationData['locationCategoryId'],
              locationSubcategoryId: locationData['locationSubcategoryId'],
              facebookUrl: locationData['facebookUrl'],
              instagramUrl: locationData['instagramUrl'],
              bookingUrl: locationData['bookingUrl'],
              isApproved: locationData['isApproved']);
          locations.add(location);
        }
        return locations;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<bool> deleteLocationById(int id) async {
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/Location/DeleteById/$id');
    final response = await makeAuthenticatedRequest(uri, 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> deleteServiceById(int id) async {
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/Service/$id');
    final response = await makeAuthenticatedRequest(uri, 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

 Future<bool> deletePublicCityServiceById(int id) async {
    final Uri uri =
        Uri.parse('${ApiConstants.baseUrl}/PublicCityService/$id');
    final response = await makeAuthenticatedRequest(uri, 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getAllEvents() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Event');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      final List events = [];
      if (response.statusCode == 200) {
        final jsonDataList = json.decode(response.body);
        var resultList = jsonDataList["result"]['\$values'];
        for (var eventData in resultList) {
          var locationId = await getLocationIdByEventId(eventData['eventId']);
          var eventDate = DateTime.parse(eventData['date']);
          var now = DateTime.now();
          if (eventDate.isBefore(now)) {
            await deleteEventById(eventData['eventId']);
          } else {
            var event = (
              eventId: eventData['eventId'],
              title: eventData['title'],
              description: eventData['description'],
              date: eventData['date'],
              startTime: eventData['startTime'],
              address: eventData['address'],
              ticketCost: eventData['ticketCost'],
              cityId: eventData['cityId'],
              eventCategoryId: eventData['eventCategoryId'],
              locationId: locationId
            );

            events.add(event);
          }
        }
        return events;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List> getEventsByTAO(int userId) async {
    List allEventsForTao = [];
    var tao = await getTouristAttractionOwnerIdByUserId(userId);
    var locationsfortao =
        await fetchLocationIdsByTouristAttractionOwnerId(tao!);
    var eventLocations = [];

    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventLocation');
    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      final jsonDataList = json.decode(response.body);
      var resultList = jsonDataList["result"]['\$values'];
      for (var eventData in resultList) {
        if (locationsfortao.contains(eventData['locationId'])) {
          var eventLocation = (
            eventId: eventData['eventId'],
            locationId: eventData['locationId']
          );
          eventLocations.add(eventLocation);
        }
      }

      for (var event in eventLocations) {
        var eventForTao = await getEventById(event.eventId);
        allEventsForTao.add(eventForTao);
      }
      return allEventsForTao;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<bool> deleteEventById(int id) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventLocation');
    final response = await makeAuthenticatedRequest(uri, 'GET');
    if (response.statusCode == 200) {
      final jsonDataList = json.decode(response.body);
      var resultList = jsonDataList["result"]['\$values'];
      for (var result in resultList) {
        if (result['eventId'] == id) {
          final Uri uri2 =
              Uri.parse('${ApiConstants.baseUrl}/EventLocation/$id');
          // ignore: unused_local_variable
          final response2 = await makeAuthenticatedRequest(uri2, 'DELETE');
        }
      }
    }
    final Uri uri3 = Uri.parse('${ApiConstants.baseUrl}/Event/$id');
    final response3 = await makeAuthenticatedRequest(uri3, 'DELETE');
    if (response3.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> deleteHistoricalEventById(int id) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/HistoricalEvent/$id');
    final response = await makeAuthenticatedRequest(uri, 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Event> getEventById(int eventId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Event/$eventId');
    final response = await makeAuthenticatedRequest(uri, 'GET');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final event = Event.fromJson(jsonData);
      return event;
    } else {
      throw Exception('Failed to load data');
    }
  }

  editEventById(int eventId, Event eventForUpdate) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/Event/$eventId');
    final response = await makeAuthenticatedRequest(uri, 'PUT',
        body: eventForUpdate.toJson());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final event = Event.fromJson(jsonData);
      return event;
    } else {
      throw Exception('Failed to load data');
    }
  }

  getLocationIdByEventId(int eventId) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/EventLocation');
    // ignore: prefer_typing_uninitialized_variables
    var locationId;
    final response = await makeAuthenticatedRequest(uri, 'GET');
    if (response.statusCode == 200) {
      final jsonDataList = json.decode(response.body);
      var resultList = jsonDataList["result"]['\$values'];
      for (var result in resultList) {
        if (result['eventId'] == eventId) {
          locationId = result['locationId'];
        }
      }
    }
    return locationId;
  }

  Future<List<Service>> fetchServicesByLocationId(int locationId) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Service/GetServicesByLocationId/$locationId');
    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body)['\$values'];
        final services = jsonData.map<Service>((json) {
          return Service.fromJson(json);
        }).toList();
        return services;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List> getAllHistoricalEvents() async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/HistoricalEvent');

    try {
      final response = await makeAuthenticatedRequest(uri, 'GET');
      final List events = [];
      if (response.statusCode == 200) {
        final jsonDataList = json.decode(response.body);
        var resultList = jsonDataList["result"]['\$values'];
        for (var eventData in resultList) {
          var event = (
            historicalEventId: eventData['historicalEventId'],
            title: eventData['title'],
            description: eventData['description'],
            coverImage: eventData['coverImage'],
            cityId: eventData['cityId'],
            eventCategoryId: eventData['eventCategoryId'],
          );
          events.add(event);
        }
        return events;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Reservation?> updateIsConfirmed(int id, bool isConfirmed) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/Reservation/UpdateIsConfirmed/$id/$isConfirmed');
    try {
      final response = await makeAuthenticatedRequest(
        uri,
        'PUT',
        body: jsonEncode({
          'id': id,
          'isConfirmed': isConfirmed,
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
}

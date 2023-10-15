import 'dart:math';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/location_visits_model.dart';
import 'package:discoverhscountry_mobile/models/review_model.dart';
import 'package:discoverhscountry_mobile/models/tourist_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class RecommendedLocations extends StatefulWidget {
  User user;
  RecommendedLocations({super.key, required this.user});

  @override
  State<RecommendedLocations> createState() => _RecommendedLocationsState();
}

class _RecommendedLocationsState extends State<RecommendedLocations>
    with DataFetcher {
  bool isLoading = true;
  List<VisitedLocation> visitedLocations = [];
  int? touristId;
  List<Location> locations = [];
  List<LocationVisits> locationVisits = [];
  List<Review> reviews = [];
  List<Location> bestRatedLocations = [];
  List<Review> bestReviewsByOthers = [];
  List<Tourist> usersThatRateSimilar = [];

  Map<int, Map<int, double>> userItemMatrix = {};
  double threshold = 0.2;

  double calculateCosineSimilarity(
      Map<int, double> userA, Map<int, double> userB) {
    double dotProduct = 0;
    double magnitudeA = 0;
    double magnitudeB = 0;

    for (int item in userA.keys) {
      if (userB.containsKey(item)) {
        dotProduct += (userA[item]! * userB[item]!);
      }
      magnitudeA += (userA[item]! * userA[item]!);
    }

    for (int item in userB.keys) {
      magnitudeB += (userB[item]! * userB[item]!);
    }

    if (magnitudeA == 0 || magnitudeB == 0) {
      // Handles division by zero error
      return 0.0;
    }

    double cosineSimilarity =
        dotProduct / (sqrt(magnitudeA) * sqrt(magnitudeB));
    return cosineSimilarity;
  }

  List<int> findSimilarUsers(
      int targetUserId, Map<int, Map<int, double>> userItemMatrix) {
    List<int> similarUsers = [];
    for (int userId in userItemMatrix.keys) {
      if (userId != targetUserId) {
        double similarity = calculateCosineSimilarity(
            userItemMatrix[targetUserId]!, userItemMatrix[userId]!);
        if (similarity > threshold) {
          similarUsers.add(userId);
        }
      }
    }
    return similarUsers;
  }

  List<int> generateRecommendations(
      int targetUserId, Map<int, Map<int, double>> userItemMatrix) {
    List<int> recommendations = [];
    Set<int> visitedLocationIds = Set<int>.from(
        visitedLocations.map((visitedLocation) => visitedLocation.locationId));

    // 1. Recommendations based on visited locations
    if (visitedLocationIds.isNotEmpty) {
      for (int locationId in visitedLocationIds) {
        recommendations.addAll(userItemMatrix[locationId]!.keys);
      }
    }

    // 2. Recommendations based on best-rated locations
    for (int locationId in userItemMatrix.keys) {
      if (locations.isNotEmpty) {
        Location location = locations
            .firstWhere((location) => location.locationId == locationId);
        if (bestRatedLocations.contains(location)) {
          recommendations.addAll(userItemMatrix[locationId]!.keys);
        }
      }
    }

    // 3. Recommendations based on locations highly rated by similar users
    List<int> similarUsers = findSimilarUsers(targetUserId, userItemMatrix);
    if (similarUsers.isNotEmpty) {
      for (int userId in similarUsers) {
        Set<int> highlyRatedLocationsBySimilarUser =
            userItemMatrix[userId]!.keys.toSet();
        for (int locationId in highlyRatedLocationsBySimilarUser) {
          if (!visitedLocationIds.contains(locationId)) {
            recommendations.add(locationId);
          }
        }
      }
    }

    // Remove visited locations from recommendations to not repeat locations
    recommendations = recommendations
        .where((locationId) => !visitedLocationIds.contains(locationId))
        .toList();

    return recommendations;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<int> recommendations = [];

  Future<void> _loadData() async {
    await _getTouristId().then((_) {
      return _getVisitedLocations();
    }).then((_) {
      return _getAllLocations();
    }).then((_) {
      return _getReviewsByTourist();
    }).then((_) {
      return _getBestReviewsByOthersForUsersBestRatedLocation();
    }).then((_) {
      recommendations = generateRecommendations(touristId!, userItemMatrix);
      print("Recommendations: $recommendations");
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getTouristId() async {
    touristId = await getTouristIdByUserId(widget.user.userId);
  }

  _getVisitedLocations() async {
    visitedLocations = await getAllVisitedLocations(touristId!);
  }

  _getAllLocations() async {
    locations = await fetchLocations();
    for (var location in locations) {
      var visits = await getLocationVisitsByLocationIdAndTouristId(
          location.locationId!, touristId!);
      if (visits != null) {
        locationVisits.add(visits);
      }
    }
  }

  _getReviewsByTourist() async {
    reviews = await getBestReviewsByTouristId(touristId!);
    for (var location in reviews) {
      var ratedLocation = await getLocationById(location.locationId);
      bestRatedLocations.add(ratedLocation);

      Map<int, double> userInteractions = {};
      userInteractions[location.locationId] = location.rate;
      userItemMatrix[location.locationId!] = userInteractions;
    }
  }

  _getBestReviewsByOthersForUsersBestRatedLocation() async {
    for (var location in bestRatedLocations) {
      bestReviewsByOthers =
          await getBestReviewsByOthersForUsersBestRatedLocation(
              location.locationId!, touristId!);
    }

    for (var review in bestReviewsByOthers) {
      var tourist = await getTouristById(review.touristId);
      usersThatRateSimilar.add(tourist);

      Map<int, double> userInteractions = {};
      userInteractions[review.locationId] = review.rate;
      userItemMatrix[review.locationId!] = userInteractions;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(recommendations);
    return const Placeholder();
  }
}

import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/review_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class ViewReviews extends StatefulWidget {
  final User? user;
  const ViewReviews({super.key, this.user});

  @override
  State<ViewReviews> createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
  bool isLoading = true;
  List<int> locationIds = [];
  List<Map<String, dynamic>> locations = [];
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    final userId = widget.user!.userId;
    getTouristAttractionOwnerIdByUserId(userId).then((taoId) {
      if (taoId != null) {
        setState(() {
          taoId = taoId;
        });

        fetchLocationIdsByTouristAttractionOwnerId(taoId!)
            .then((fetchedIds) async {
          setState(() {
            locationIds = fetchedIds;
          });
          return await fetchLocationsByIds(locationIds);
        }).then((fetchedLocations) async {
          setState(() {
            locations = fetchedLocations;
          });
        }).then((value) => {isLoading = false});
      } else {
        // ignore: avoid_print
        print('Failed to fetch Tourist Attraction Owner ID');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        userType: 'touristattractionowner',
        onLogout: () async {
          await authService.logout();
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(), // Loading indicator
                  )
                : buildReviewsList(),
          ),
        ],
      ),
    );
  }

  Widget buildReviewsList() {
    if (locationIds.isEmpty) {
      return const Text('No locations available for reviews.');
    }

    return ListView.builder(
      itemCount: locationIds.length,
      itemBuilder: (context, index) {
        final locationId = locationIds[index];

        return FutureBuilder<Location>(
          future: getLocationById(locationId),
          builder: (context, locationSnapshot) {
            if (locationSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(), // Loading indicator
              );
            } else if (locationSnapshot.hasError) {
              return const Text('Greška pri učitavanju lokacija.');
            } else {
              final location = locationSnapshot.data;

              if (location == null) {
                return const Text('Lokacija nije pronađena.');
              }

              return Column(
                children: [
                  Text(
                    'Recenzije za lokaciju: ${location.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Review>>(
                    future: getReviewByLocationId(locationId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child:
                              CircularProgressIndicator(), // Loading indicator
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Greška pri učitavanju recenzija.');
                      } else {
                        final reviewsForLocation = snapshot.data;

                        if (reviewsForLocation == null ||
                            reviewsForLocation.isEmpty) {
                          return const Text(
                              'Nema recenzija dostupnih za prikaz.');
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviewsForLocation.map((review) {
                            return Card(child:ListTile(
                              title: Text('Naslov: ${review.title}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ocjena: ${review.rate}'),
                                  Text('Komentar: ${review.description}'),
                                ],
                              ),
                            ));
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

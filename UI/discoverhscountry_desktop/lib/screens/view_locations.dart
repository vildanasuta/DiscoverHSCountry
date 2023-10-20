import 'dart:convert';

import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/add_service.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewLocations extends StatefulWidget {
  User user;
  String userType;
  ViewLocations({Key? key, required this.user, required this.userType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewLocationsState createState() => _ViewLocationsState();
}

class _ViewLocationsState extends State<ViewLocations> with DataFetcher {
  List<Location> locations = [];
  bool isLoading = true; // Added loading indicator state
  final AuthenticationService authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    try {
      final touristAttractionOwnerId =
          await getTouristAttractionOwnerIdByUserId(widget.user.userId);
      if (touristAttractionOwnerId != null) {
        final locationIds = await fetchLocationIdsByTouristAttractionOwnerId(
            touristAttractionOwnerId);
        locations = await fetchLocationDetailsByIds(locationIds);
      }
    } catch (e) {
      // Handle errors
    } finally {
      // Set isLoading to false when loading is complete
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        userType: widget.userType,
        onLogout: () async {
          await authService.logout();
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.memory(base64.decode(location.coverImage)),
                    title: Text(location.name),
                    subtitle: Text(location.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*ElevatedButton(
                          onPressed: () {
                          },
                          child: const Text('Uredi'),
                        ),*/
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddService(
                                  user: widget.user,
                                  userType: widget.userType,
                                  locationId: location.locationId,
                                ),
                              ),
                            );
                          },
                          child: const Text('Dodaj uslugu'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

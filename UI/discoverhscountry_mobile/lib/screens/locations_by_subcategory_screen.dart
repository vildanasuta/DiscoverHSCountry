import 'dart:convert';
import 'dart:ui';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/location_details_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LocationsBySubcategoryScreen extends StatefulWidget {
  User user;
  int categoryId;
  int subcategoryId;
  LocationsBySubcategoryScreen({super.key, required this.user, required this.categoryId, required this.subcategoryId });

  @override
  State<LocationsBySubcategoryScreen> createState() => _LocationsBySubcategoryScreenState();
}

class _LocationsBySubcategoryScreenState extends State<LocationsBySubcategoryScreen> with DataFetcher{
   List<Location> locations = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchLocationsBySubcategoryId(widget.categoryId, widget.subcategoryId);
  }

  _fetchLocationsBySubcategoryId(int categoryId, int subcategoryId) async {
    final fetchedLocations = await fetchLocationsBySubcategoryId(categoryId, subcategoryId);
  final approvedLocations = fetchedLocations.where((location) => location.isApproved == true).toList();
    setState(() {
      isLoading = false;
      locations=approvedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 2, 89, 1.0),
          foregroundColor: Colors.white,
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
          title: Center(
            child: Text(
              'Locations in selected subcategory',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return GestureDetector(
                        onTap: () {
  Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LocationDetailsScreen(
                                    user: widget.user, location: location,
                                  )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Image.memory(
                                  base64.decode(location.coverImage),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)
                                        .withOpacity(0.2),
                                    child: Center(
                                      child: Text(
                                        location.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ]));
  }
}